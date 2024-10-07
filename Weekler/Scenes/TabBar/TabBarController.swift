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
        view.backgroundColor = Colors.viewBackground
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
        
        configureNavController(controller: scheduleNavigationController)

        return scheduleNavigationController
    }
    
    private func setupTaskEditorViewController() -> UINavigationController {
        let taskEditorViewController = TaskEditorViewController()

        taskEditorViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.edit,
            image: UIImage(systemName: "square.and.pencil"),
            selectedImage: nil)

        let taskEditorNavigationController = UINavigationController(rootViewController: taskEditorViewController)
        
        configureNavController(controller: taskEditorNavigationController)

        return taskEditorNavigationController
    }
    
    private func setupStatisticsViewController() -> UINavigationController {
        let statisticsViewController = StatisticsViewController()

        statisticsViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.statistics,
            image: UIImage(systemName: "chart.bar.xaxis"),
            selectedImage: nil)

        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        
        configureNavController(controller: statisticsNavigationController)

        return statisticsNavigationController
    }
    
    private func setupConfigViewController() -> UINavigationController {
        let configViewController = ConfigViewController()

        configViewController.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.config,
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil)

        let configNavigationController = UINavigationController(rootViewController: configViewController)
        
        configureNavController(controller: configNavigationController)

        return configNavigationController
    }
    
    private func configureNavController(controller: UINavigationController) {
        controller.navigationBar.setBackgroundImage(UIImage(), for: .default)
        controller.navigationBar.shadowImage = UIImage()
        controller.navigationBar.isTranslucent = true
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
