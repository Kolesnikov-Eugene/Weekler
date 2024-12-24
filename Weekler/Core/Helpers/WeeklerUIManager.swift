//
//  WeeklerUIManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 23.12.2024.
//

import UIKit
import RxSwift
import RxCocoa

private let backgroundColorKey = "backgroundColorKey"

final class WeeklerUIManager {
    
    var selectedColor: UIColor? {
        get { currentAppBackgroundColor }
    }
    
    private enum ColorString: String {
        
        case green = "green"
        case red = "red"
        case blue = "blue"
        case yeallow = "yellow"
        case purple = "purple"
        
        var value: UIColor {
            switch self {
            case .green: return Colors.green
            case .red: return Colors.red
            case .blue: return Colors.blue
            case .yeallow: return Colors.yellow
            case .purple: return Colors.purple
            }
        }
    }
    
    private let defaults = UserDefaults.standard
    
    static let shared = WeeklerUIManager()
    
    private init() {}
}

extension WeeklerUIManager {
    var currentAppBackgroundColor: UIColor? {
        get {
            let color = defaults.string(forKey: backgroundColorKey)
            if let color = color {
                let colorString = ColorString(rawValue: color)
                return colorString?.value
            }
            return Colors.viewBackground
        }
        set {
            let colorString = newValue?.colorString
            defaults.setValue(colorString, forKey: backgroundColorKey)
            NotificationCenter.default.post(name: .colorDidChange, object: nil)
        }
    }
}

extension Notification.Name {
    static let colorDidChange = Notification.Name("ColorDidChangeNotification")
}
