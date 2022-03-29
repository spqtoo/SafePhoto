//
//  ImageViewerCell.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 30.11.2021.
//

import UIKit

final class ImageViewerCell: UICollectionViewCell, IdentifiableProtocol, UIScrollViewDelegate {

    private var initialCenter: CGPoint = .zero

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.bouncesZoom = true
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.setZoomScale(1.0, animated: false)
        return scrollView
    }()

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true

        return imageView
    }()

    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.scrollView.delegate = self
        configureLayout()
//        configureCellUI()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        configureLayout()
//        configureCellUI()
    }

    // MARK: - Functions

    func configure(with image: UIImage?) {
        imageView.image = image
        imageView.backgroundColor = .black

    }

    // MARK: - Private functions

    private func configureLayout() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.pinAnchors(to: nil, anchors: .top, .bottom, .left, .right)
//-
        configurateFor(imageSize: imageView.image?.size ?? CGSize())
//        imageView.pin(to: scrollView)
    }

    func configurateFor(imageSize: CGSize) {
        scrollView.contentSize = imageSize

        setCurrentMaxandMinZoomScale()
        scrollView.zoomScale = scrollView.minimumZoomScale

        imageView.addGestureRecognizer(self.zoomingTap)
        imageView.isUserInteractionEnabled = true

    }

    func setCurrentMaxandMinZoomScale() {
        let boundsSize = scrollView.bounds.size
        let imageSize = imageView.bounds.size

        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)

        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
    }

    private func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageView.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        imageView.frame = frameToCenter
    }

    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }

    func zoom(point: CGPoint, animated: Bool) {
        let currectScale = scrollView.zoomScale
        let minScale = scrollView.minimumZoomScale
        let maxScale = scrollView.maximumZoomScale

        if (minScale == maxScale && minScale > 1) {
            return
        }

        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        scrollView.zoom(to: zoomRect, animated: animated)
    }

    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds

        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale

        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }


    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.zoomScale = 1.0
    }

}
