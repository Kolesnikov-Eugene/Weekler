//
//  UIColor+Extension.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 24.12.2024.
//

import UIKit

extension UIColor {
    var colorString: String {
        switch self {
        case .green: return "green"
        case .red: return "red"
        case .blue: return "blue"
        case .yellow: return "yellow"
        case .purple: return "purple"
        default: return ""
        }
    }
}
