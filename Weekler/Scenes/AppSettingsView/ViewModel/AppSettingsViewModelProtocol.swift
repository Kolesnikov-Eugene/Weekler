//
//  AppSettingsViewModelProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.12.2024.
//

import Foundation

protocol AppSettingsViewModelProtocol: AnyObject {
    var mainSettingsItems: [AppSettingsItem] { get }
    var appearanceSettingsItems: [AppSettingsItem] { get }
    func makeCellConfiguration(for indexPath: IndexPath) -> AppSettingsCellConfiguration
}
