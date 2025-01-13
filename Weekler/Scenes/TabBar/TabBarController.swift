//
//  TabBarViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - private methods
    private func setupView() {
        updateBackgroundColor()
        configureTabBar()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBackgroundColor),
            name: .colorDidChange,
            object: nil
        )
    }

    private func configureTabBar() {
        tabBar.tintColor = Colors.mainForeground
        tabBar.unselectedItemTintColor = .gray
    }
    
    @objc
    private func updateBackgroundColor() {
        let color = WeeklerUIManager.shared.selectedColor
        view.backgroundColor = color
    }
}
