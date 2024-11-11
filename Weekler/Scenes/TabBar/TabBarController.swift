//
//  TabBarViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {

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

    private func setupView() {
        view.backgroundColor = Colors.viewBackground
        configureTabBar()
    }

    private func configureTabBar() {
        tabBar.tintColor = Colors.mainForeground
        tabBar.unselectedItemTintColor = .gray
//        let myColor = UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 1)
//        let appearance = tabBar.standardAppearance
//        appearance.shadowImage = nil
//        appearance.shadowColor = nil
//        appearance.backgroundEffect = nil
//        appearance.backgroundColor = UIColor(resource: .background)
//        appearance.stackedLayoutAppearance.normal.iconColor = .black
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: myColor,
//            ]

//        tabBar.standardAppearance = appearance
    }
}
