//
//  AddAlbumVC.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit
import YPImagePicker


protocol AddAlbumVCDelegate: AnyObject {

    func didCreateImage()
}

final class AddAlbumVC: UIViewController {

    private lazy var transition: HalfScreenTransitionDelegate = .init(infoVC: self)
    private lazy var coreDataProvider = diContainer.resolve(CoreDataProviderProtocol.self)!
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.heightToWidth()
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 12
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageDidPress))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = R.string.localizable.addAlbumTextPlaceholder()
        textField.textColor = .white
        textField.tintColor = .white
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
        return textField
    }()

    private let textFieldHighlighter: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.highlightBgColor
        view.setHeight(value: 1)
        return view
    }()

    private var lastText: String? = ""
    private var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    private var popUpPresenter: PresentationController? {
        navigationController?.presentationController as? PresentationController
    }

    private lazy var textBottomConstraint: NSLayoutConstraint = textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)

    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localizable.addAlbumCreateButtonTitle(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveDidPress), for: .touchUpInside)
        return button
    }()

    private var isSaving = false



    weak var delegate: AddAlbumVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .init(rgb: 0x141414).withAlphaComponent(0.8)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        navigationItem.title = R.string.localizable.addAlbumTitle()
        let button = UIBarButtonItem(customView: createButton)
        navigationItem.setRightBarButton(button, animated: true)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidPress)))

        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeNotifications()
    }

    private func setupNotifications() {
        let notif = NotificationCenter.default
        notif.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        notif.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureLayout() {
        view.addSubview(imageView)
        view.addSubview(textField)
        view.addSubview(textFieldHighlighter)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -32),

            textField.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textBottomConstraint,

            textFieldHighlighter.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -8),
            textFieldHighlighter.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            textFieldHighlighter.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 3)
        ])
    }

    @objc
    private func textFieldDidChange() {
        defer { lastText = textField.text }
        guard lastText != textField.text else { return }
        textField.sizeToFit()
        textField.invalidateIntrinsicContentSize()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    @objc
    private func keyboardWillShow(_ sender: NSNotification) {
        popUpPresenter?.popUpHeight = UIScreen.height / 2 + sender.keyboardHeight
        textBottomConstraint.constant = -sender.keyboardHeight - 16
        updatePopUpSize()
        UIView.animate(withDuration: sender.keyboardAnimation) { [weak self] in
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }

    @objc
    private func keyboardWillHide(_ sender: NSNotification) {
        popUpPresenter?.popUpHeight = Self.popUpMinimumHeight
        updatePopUpSize()
        textBottomConstraint.constant = -16
        UIView.animate(withDuration: sender.keyboardAnimation) { [weak self] in
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }
    }

    @objc
    private func viewDidPress() {
        textField.resignFirstResponder()
    }

    @objc
    private func saveDidPress() {
        guard let text = textField.text else {
            textFieldNotValid()
            return
        }
        guard text.isEmpty == false else {
            textFieldNotValid()
            return
        }
        guard isSaving == false else { return }
        isSaving = true
        coreDataProvider.performTask { [weak self] context in
            guard let context = context else {
                self?.isSaving = false
                return
            }
            var image = self?.selectedImage?.jpegData(compressionQuality: 1)
            var currentCompression: Double = 1
            while image?.megabyte ?? .zero > 0.5 {
                currentCompression -= 0.1
                image = self?.selectedImage?.jpegData(compressionQuality: currentCompression)
            }
            AlbumEntity(context: context,
                        nameOfAlbum: text,
                        image: image)
        } saveCallback: { [weak self] _ in
            self?.delegate?.didCreateImage()
            self?.dismissSelf()
        }
    }

    @objc
    private func imageDidPress() {
        presentSinglePhotoPicker(from: self) { [weak self] image in
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                guard let image = image else { return }
                guard var data = image.jpegData(compressionQuality: 1) else {
                    self.setImage(image)
                    return
                }
//                var image = self?.selectedImage?.jpegData(compressionQuality: 1)
                var currentCompression: Double = 1

                // autoreleasepool
                while data.megabyte > 0.5 {
                    currentCompression -= 0.1
                    guard let tempData = image.jpegData(compressionQuality: currentCompression) else {
                        self.setImage(image)
                        return
                    }
                    data = tempData
                }
                guard let compressedImage = UIImage(data: data) else {
                    self.setImage(image)
                    return
                }
                self.setImage(compressedImage)
            }
        }
    }

    private func setImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.selectedImage = image
        }
    }

    private func dismissSelf() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func textFieldNotValid() {
        Vibration.error.vibrate()
        textFieldHighlighter.backgroundColor = .systemRed
//        setTextFieldHighliter(color: .systemRed)
        let timeInterval: TimeInterval = 0.2
        textFieldHighlighter.shake(count: 2, for: timeInterval, withTranslation: 2)
        textField.shake(count: 2, for: timeInterval, withTranslation: 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) { [weak self] in
            self?.setTextFieldHighliter(color: ColorManager.highlightBgColor)

        }
    }

    private func setTextFieldHighliter(color: UIColor) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.textFieldHighlighter.backgroundColor = color
        }
    }

    private func updatePopUpSize() {
        popUpPresenter?.containerView?.setNeedsLayout()
        popUpPresenter?.containerView?.layoutIfNeeded()
    }

    static func build(delegate: AddAlbumVCDelegate) -> UINavigationController {
        let vc = AddAlbumVC()
        vc.delegate = delegate
        let nav = HiddenNavigationBar(rootViewController: vc)
        nav.transitioningDelegate = vc.transition
        nav.modalPresentationStyle = .custom
        return nav
    }

    static let popUpMinimumHeight: CGFloat = 300
}

//extension AddAlbumVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print(info)
//    }
//}

extension AddAlbumVC: DISupportable {}

public extension UIView {

    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = 5) {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}
