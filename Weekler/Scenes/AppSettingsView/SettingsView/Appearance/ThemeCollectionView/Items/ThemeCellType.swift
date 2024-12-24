//
//  ThemeCellType.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 24.12.2024.
//

import UIKit

enum ThemeCellType: Hashable, Equatable {
    case darkMode(DarkModeItem)
    case theme(ThemeItem)
}

struct DarkModeItem: Hashable {
    let title: String
}

struct ThemeItem: Hashable {
    let title: String
    let color: UIColor
}
