//
//  ThemeSection.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 24.12.2024.
//

import Foundation

enum ThemeSection: Int, Hashable, CaseIterable {
    case darkMode
    case theme
    
    var columnCount: Int {
        switch self {
        case .darkMode: return 1
        case .theme: return 3
        }
    }
}
