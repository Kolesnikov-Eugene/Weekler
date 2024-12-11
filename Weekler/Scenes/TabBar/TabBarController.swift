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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.selectedIndex = 0
    }

    // MARK: - private methods
    private func setupView() {
        view.backgroundColor = Colors.viewBackground
        configureTabBar()
    }

    private func configureTabBar() {
        tabBar.tintColor = Colors.mainForeground
        tabBar.unselectedItemTintColor = .gray
    }
}
