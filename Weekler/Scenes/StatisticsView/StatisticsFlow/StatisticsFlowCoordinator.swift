//
//  StatisticsFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 11.11.2024.
//

import UIKit

final class StatisticsFlowCoordinator: Coordinator {
    
    // MARK: - private properties
    private var navigationController: UINavigationController?
    private let sceneFactoryDIContainer: SceneFactoryProtocol
    private let tabBar: UITabBarController
    
    // MARK: - lifecycle
    init(
        sceneFactoryDIContainer: SceneFactoryProtocol,
        tabBar: UITabBarController
    ) {
        self.sceneFactoryDIContainer = sceneFactoryDIContainer
        self.tabBar = tabBar
    }
    
    // MARK: - public methods
    func start() {
        let statisticsViewController = sceneFactoryDIContainer.makeStatisticsView()
        navigationController = UINavigationController(rootViewController: statisticsViewController)
        
        navigationController?.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.statistics,
            image: UIImage(systemName: "chart.bar.xaxis"),
            selectedImage: nil)
        
        guard let navigationController else { return }
        tabBar.viewControllers?.insert(navigationController, at: 1)
//        tabBar.viewControllers?.append(navigationController)
    }
}
