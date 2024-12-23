//
//  Colors.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.04.2024.
//

import UIKit

struct Colors {
    static let background = UIColor(resource: .background)
    static let grayBackground = UIColor(resource: .sideMenuBack)
    static let dateSelectedBackground = UIColor(resource: .dateSelectedBack)
    static let calendarCurrentDateBackground = UIColor(resource: .calendarCurrentDate)
    static let mainForeground = UIColor(resource: .mainForeground)
    
    static var viewBackground = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .dark {
            return UIColor.systemBackground
        } else {
            return UIColor(resource: .background)
        }
    }
    static let textColorMain = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .dark {
            return .white
        } else {
            return .black
        }
    }
    static let createViewTextFieldBorder = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .dark {
            return .white
        } else {
            return .black
        }
    }
}
