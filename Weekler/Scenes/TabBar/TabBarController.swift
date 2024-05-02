//
//  TabBarViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private let tabBarFactory: TabBarFactory

    init(tabBarFactory: TabBarFactory) {
        self.tabBarFactory = tabBarFactory
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = Colors.background

        configureTabBar()

        let scheduleViewController = setupScheduleViewController()
        let taskEditorViewController = setupTaskEditorViewController()
        let statisticsViewController = setupStatisticsViewController()
        let configViewController = setupConfigViewController()

        viewControllers = [
            scheduleViewController,
            taskEditorViewController,
            statisticsViewController,
            configViewController
        ]
    }

    private func setupScheduleViewController() -> UINavigationController {
        let scheduleViewController = tabBarFactory.createScheduleViewController()
        
        let image = UIImage(systemName: "list.bullet.clipboard")

        scheduleViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.schedule,
            image: image,
            selectedImage: nil)

        let scheduleNavigationController = UINavigationController(rootViewController: scheduleViewController)

        scheduleNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        scheduleNavigationController.navigationBar.shadowImage = UIImage()
        scheduleNavigationController.navigationBar.isTranslucent = true

        return scheduleNavigationController
    }
    
    private func setupTaskEditorViewController() -> UINavigationController {
        let taskEditorViewController = TaskEditorViewController()

        taskEditorViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.edit,
            image: UIImage(systemName: "square.and.pencil"),
            selectedImage: nil)

        let taskEditorNavigationController = UINavigationController(rootViewController: taskEditorViewController)

        taskEditorNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        taskEditorNavigationController.navigationBar.shadowImage = UIImage()
        taskEditorNavigationController.navigationBar.isTranslucent = true

        return taskEditorNavigationController
    }
    
    private func setupStatisticsViewController() -> UINavigationController {
        let statisticsViewController = StatisticsViewController()

        statisticsViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.statistics,
            image: UIImage(systemName: "chart.bar.xaxis"),
            selectedImage: nil)

        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)

        statisticsNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        statisticsNavigationController.navigationBar.shadowImage = UIImage()
        statisticsNavigationController.navigationBar.isTranslucent = true

        return statisticsNavigationController
    }
    
    private func setupConfigViewController() -> UINavigationController {
        let configViewController = ConfigViewController()

        configViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.config,
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil)

        let configNavigationController = UINavigationController(rootViewController: configViewController)

        configNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        configNavigationController.navigationBar.shadowImage = UIImage()
        configNavigationController.navigationBar.isTranslucent = true

        return configNavigationController
    }

    private func configureTabBar() {
//        tabBar.tintColor = .blue
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
