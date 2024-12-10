//
//  AppSettingsViewModelProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.12.2024.
//

import Foundation

protocol AppSettingsViewModelProtocol: AnyObject {
    var settingsItems: [AppSettingsItem] { get }
    func makeCellConfiguration(for indexPath: IndexPath) -> AppSettingsCellConfiguration
}
