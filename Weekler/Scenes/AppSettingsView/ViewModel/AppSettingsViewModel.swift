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
                case .main: return true
                case .appearance: return false
                }
            }
        }
    }
    var appearanceSettingsItems: [AppSettingsItem] {
        get {
            settingsItems.filter {
                switch $0 {
                case .appearance: return true
                case .main: return false
                }
            }
        }
    }
    
    // MARK: - private properties
    private let settingsItems: [AppSettingsItem] = [
        .main(MainSettingsItem(title: "Sounds")),
        .main(MainSettingsItem(title: "Settings")),
        .main(MainSettingsItem(title: "Notifications")),
        .appearance(AppearanceSettingsItem(title: "Appearance")),
        .appearance(AppearanceSettingsItem(title: "Theme")),
    ]
    private var mainSectionItemsCount: Int {
        get { mainSettingsItems.count }
    }
    private var appearanceSectionItemsCount: Int {
        get { appearanceSettingsItems.count }
    }
//    private let settingsFlowCoordinator: AppSettingsFlowCoordinator
    
    // MARK: - lifecycle
    init
    (
//        settingsFlowCoordinator: AppSettingsFlowCoordinator
    ) {
//        self.settingsFlowCoordinator = settingsFlowCoordinator
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
}
