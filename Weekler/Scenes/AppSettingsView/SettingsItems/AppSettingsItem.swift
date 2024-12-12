//
//  AppSettingsItem.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.12.2024.
//

import Foundation

enum AppSettingsItem: Hashable, Equatable {
    case general(GeneralSettingsItem)
    case application(ApplicationSettingsItem)
}
