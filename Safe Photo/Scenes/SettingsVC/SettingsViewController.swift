//
//  SettingsViewController.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 21.11.2021.
//
import UIKit

final class SettingsViewController: AutomaticBackButtonViewController {

    private var dataSource: [SectionModel] = [
        .init(type: .security,
              cellModel: []),
        .init(type: .general,
              cellModel: [])
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.register(SettingsTableViewTextCell.self,
                           forCellReuseIdentifier: SettingsTableViewTextCell
                            .identifier)
        tableView.register(SettingsTableViewSwitchCell.self,
                           forCellReuseIdentifier: SettingsTableViewSwitchCell
                            .identifier)
        tableView.register(SettingsTableViewBaseCell.self,
                           forCellReuseIdentifier: SettingsTableViewBaseCell
                            .identifier)
        tableView.register(SettingsTableViewHeader.self,
                           forHeaderFooterViewReuseIdentifier: SettingsTableViewHeader
                            .identifier)
        tableView.register(SettingsTableViewImageCell.self,
                           forCellReuseIdentifier: SettingsTableViewImageCell
                            .identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        setupDataSource()
    }

    private func setupDataSource() {

        // Security section
        dataSource.set(.init(title: R.string.localizable.settingsCellPassword(),
                             value: .switchView(UserDefaultsSingleton.shared.isPasswordEnabled, .password)),
                       forSection: .security)
        dataSource.set(.init(title: R.string.localizable.settingsCellChangePassword(),
                             value: .accessory),
                       forSection: .security)
        dataSource.set(.init(title: biometricType.isFaceId ? R.string.localizable.settingsCellFaceID() : R.string.localizable.settingsCellTouchID(),
                             value: .switchView(UserDefaultsSingleton.shared.isBiometricAuthEnabled, .biometric)),
                       forSection: .security)

        // general section
        if let localLanguage = Locale.current.languageCode {
            dataSource.set(.init(title: R.string.localizable.settingsCellLanguage(),
                                 value: .text(localLanguage)), forSection: .general)
        }

        dataSource.set(.init(title: R.string.localizable.settingsCellFeedback(),
                             value: .accessory), forSection: .general)

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            dataSource.set(.init(title: R.string.localizable.settingsCellVersion(),
                                 value: .text(version)), forSection: .general)
        }
    }

    private func configureNavBar() {

        setLargeTitle(R.string.localizable.settingsTitle())

    }

    private func configureTableView() {
        tableView.pinToSafeAreaTop(to: view, constant: .zero).pinAnchors(to: nil, anchors: .left, .bottom, .right)
    }

    override func configureLayout() {
        super.configureLayout()

        view.backgroundColor = ColorManager.homeScreenBg
        view.addSubview(tableView)
        configureTableView()
    }

    struct SectionModel {
        let type: Sections
        var cellModel: [CellModel]
    }

    struct CellModel {
        let title: String
        let value: ItemContainer

        enum ItemContainer {
            case text(String)
            case switchView(Bool, SwitchIdentifier)
            case accessory
            case none

            enum SwitchIdentifier {
                case password
                case biometric
            }

            init(_ str: String) {
                self = .text(str)
            }

            init(_ value: Bool, _ stateSwitch: SwitchIdentifier) {
                self = .switchView(value, stateSwitch)
            }

        }
    }
    enum Sections {
        case security
        case general

        var title: String {
            switch self {
            case .security:
                return R.string.localizable.settingsCellSecurity()

            case .general:
                return R.string.localizable.settingsCellGeneral()
            }
        }
    }
}


private extension Array where Element == SettingsViewController.SectionModel {
    mutating func set(_ value: SettingsViewController.CellModel?,
                      forSection type: SettingsViewController.Sections) {
        guard let value = value else { return }
        for index in self.indices {
            if self[index].type == type { self[index].cellModel.append(value) }
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[safe: section]?.cellModel.count ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionModel = dataSource[safe: indexPath.section] else
        { return SettingsTableViewBaseCell() }
        guard let cellModel = sectionModel.cellModel[safe: indexPath.item] else
        { return SettingsTableViewBaseCell() }
        let title = cellModel.title

        let position: SettingsTableViewBaseCell.CellPositioninSection =
            .init(itemCount: sectionModel.cellModel.count,
                  currentItem: indexPath.item)

        switch cellModel.value {

        case let .text(text):
            return textCell(tableView: tableView,
                            indexPath: indexPath,
                            title: title, value: text, position: position)

        case let .switchView(value, stateSwitch):
            return switchCell(tableView: tableView,
                              indexPath: indexPath,
                              title: title,
                              value: value,
                              state: stateSwitch,
                              position: position)

        case .accessory:
            return imageCell(tableView: tableView,
                             indexPath: indexPath,
                             title: title,
                             value: R.image.arrow(),
                             position: position)

        case .none:
            return defaultCell(tableView: tableView,
                               indexPath: indexPath,
                               title: title,
                               position: position)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingsTableViewHeader.identifier)
                as? SettingsTableViewHeader else { return SettingsTableViewHeader()}

        guard dataSource.indices.contains(section) else { return UIView()}
        header.configureSettingTitleHeader(titleForHead: dataSource[section].type.title)
        
        return header
    }

    private func defaultCell(tableView: UITableView,
                             indexPath: IndexPath,
                             title: String,
                             position: SettingsTableViewBaseCell.CellPositioninSection) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewBaseCell.identifier,
                                                 for: indexPath)
        guard let castedCell = cell as? SettingsTableViewBaseCell else { return cell }
        castedCell.setPosition(as: position).setTitle(title)

        return cell
    }

    private func switchCell(tableView: UITableView,
                            indexPath: IndexPath,
                            title: String,
                            value: Bool,
                            state: CellModel.ItemContainer.SwitchIdentifier,
                            position: SettingsTableViewBaseCell.CellPositioninSection) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewSwitchCell.identifier,
                                                 for: indexPath)
        guard let castedCell = cell as? SettingsTableViewSwitchCell else { return cell }
        castedCell.configure(value, id: state, delegate: self, title: title, position: position)


        return cell
    }

    private func textCell(tableView: UITableView,
                          indexPath: IndexPath,
                          title: String,
                          value: String,
                          position: SettingsTableViewBaseCell.CellPositioninSection) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewTextCell.identifier,
                                                 for: indexPath)
        guard let castedCell = cell as? SettingsTableViewTextCell else { return cell }
        castedCell.configure(value, title: title, position: position)

        return cell
    }

    private func imageCell(tableView: UITableView,
                          indexPath: IndexPath,
                          title: String,
                          value: UIImage?,
                          position: SettingsTableViewBaseCell.CellPositioninSection) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewImageCell.identifier,
                                                 for: indexPath)
        guard let castedCell = cell as? SettingsTableViewImageCell else { return cell }
        castedCell.configure(value, title: title, position: position)

        return cell
    }
}

extension SettingsViewController: SettingsTableViewSwitchCellDelegate {
    func switchValueDidChange(value: Bool, id: CellModel.ItemContainer.SwitchIdentifier) {
        switch id {
        case .biometric:
            UserDefaultsSingleton.shared.isBiometricAuthEnabled = value

        case .password:
            UserDefaultsSingleton.shared.isPasswordEnabled = value
        }
    }
}

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
