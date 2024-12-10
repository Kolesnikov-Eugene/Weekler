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
    
    private(set) var settingsItems: [AppSettingsItem] = [
        .main(MainSettingsItem(title: "Sounds")),
        .main(MainSettingsItem(title: "Settings")),
        .main(MainSettingsItem(title: "Notifications")),
        .appearance(AppearanceSettingsItem(title: "Appearance")),
        .appearance(AppearanceSettingsItem(title: "Theme")),
    ]
    private var mainSectionItemsCount: Int {
        get {
            settingsItems.filter {
                switch $0 {
                case .main: return true
                case .appearance: return false
                }
            }.count
        }
    }
    private var appearanceSectionItemsCount: Int {
        get {
            settingsItems.filter {
                switch $0 {
                case .main: return false
                case .appearance: return true
                }
            }.count
        }
    }
//    private let settingsFlowCoordinator: AppSettingsFlowCoordinator
    
    init
    (
//        settingsFlowCoordinator: AppSettingsFlowCoordinator
    ) {
//        self.settingsFlowCoordinator = settingsFlowCoordinator
    }
    
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
