//
//  AppSettingsViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.12.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class AppSettingsViewModel: AppSettingsViewModelProtocol {
    
    // MARK: - public properties
    var mainSettingsItems: [AppSettingsItem] {
        get {
            settingsItems.filter {
                switch $0 {
                case .general: return true
                case .application: return false
                }
            }
        }
    }
    var appearanceSettingsItems: [AppSettingsItem] {
        get {
            settingsItems.filter {
                switch $0 {
                case .application: return true
                case .general: return false
                }
            }
        }
    }
    
    // MARK: - private properties
    private let settingsItems: [AppSettingsItem] = [
        .general(GeneralSettingsItem(title: "General")),
        .general(GeneralSettingsItem(title: "Appearence")),
        .general(GeneralSettingsItem(title: "Notifications")),
        .general(GeneralSettingsItem(title: "Date and time")),
        .application(ApplicationSettingsItem(title: "Help")),
        .application(ApplicationSettingsItem(title: "About")),
    ]
    private var mainSectionItemsCount: Int {
        get { mainSettingsItems.count }
    }
    private var appearanceSectionItemsCount: Int {
        get { appearanceSettingsItems.count }
    }
    private let settingsFlowCoordinator: SettingsFlowCoordinator
    
    // MARK: - lifecycle
    init(
        settingsFlowCoordinator: SettingsFlowCoordinator
    ) {
        self.settingsFlowCoordinator = settingsFlowCoordinator
    }
    
    // MARK: - public methods
    func makeCellConfiguration(for indexPath: IndexPath) -> AppSettingsCellConfiguration {
        if indexPath.row == 0 {
            return AppSettingsCellConfiguration(
                isLast: false,
                roundedTopCorners: true,
                roundedBottomCorners: false
            )
        } else if (indexPath.section == 0 && indexPath.row == mainSectionItemsCount - 1) ||
                    (indexPath.section == 1 && indexPath.row == appearanceSectionItemsCount - 1) {
            return AppSettingsCellConfiguration(
                isLast: true,
                roundedTopCorners: false,
                roundedBottomCorners: true
            )
        }
        return AppSettingsCellConfiguration(
            isLast: false,
            roundedTopCorners: false,
            roundedBottomCorners: false
        )
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        var scene = SettingsItem.about
        switch indexPath.section {
        case 0: scene = SettingsItem.allCases[indexPath.row]
        case 1: scene = SettingsItem.allCases[indexPath.row + mainSectionItemsCount]
        default: break
        }
        settingsFlowCoordinator.navigate(to: scene)
    }
}
