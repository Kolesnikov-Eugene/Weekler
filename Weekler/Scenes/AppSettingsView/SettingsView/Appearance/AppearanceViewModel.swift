//
//  AppearanceViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 17.12.2024.
//

import Foundation

protocol AppearanceViewModelProtocol: AnyObject {
    var darkModeItems: [ThemeCellType] { get }
    var themeItems: [ThemeCellType] { get }
    func changeAppAppearence(for cell: ThemeCollectionViewCell, at indexPath: IndexPath)
    func enableDarkMode()
}

final class AppearanceViewModel: AppearanceViewModelProtocol {
    
    // MARK: - public properties
    var darkModeItems: [ThemeCellType] {
        get {
            data.filter {
                if case .darkMode = $0 { return true }
                return false
            }
        }
    }
    var themeItems: [ThemeCellType] {
        get {
            data.filter {
                if case .theme = $0 { return true }
                return false
            }
        }
    }
    
    // MARK: - private properties
    private let data: [ThemeCellType] = [
        .darkMode(DarkModeItem(title: "System theme")),
        .theme(ThemeItem(title: "1", color: .red)),
        .theme(ThemeItem(title: "2", color: .blue)),
        .theme(ThemeItem(title: "3", color: .green)),
        .theme(ThemeItem(title: "4", color: .yellow)),
        .theme(ThemeItem(title: "5", color: .purple)),
    ]
    
    // MARK: - Lifecycle
    init() {}
    
    // MARK: - public properties
    func changeAppAppearence(
        for cell: ThemeCollectionViewCell,
        at indexPath: IndexPath
    ) {
        cell.selectCell()
        let color = data[indexPath.row + 1]
        switch color {
        case .theme(let pickedColor):
            WeeklerUIManager.shared.currentAppBackgroundColor = pickedColor.color
        default: break
        }
    }
    
    func enableDarkMode() {
        WeeklerUIManager.shared.currentAppBackgroundColor = Colors.viewBackground
    }
}
