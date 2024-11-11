//
//  StatisticsFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 11.11.2024.
//

import UIKit

final class StatisticsFlowCoordinator: Coordinator {
    private var navigationController: UINavigationController?
    private let sceneFactoryDIContainer: SceneFactoryProtocol
    private let tabBar: UITabBarController
    
    init(sceneFactoryDIContainer: SceneFactoryProtocol, tabBar: UITabBarController) {
        self.sceneFactoryDIContainer = sceneFactoryDIContainer
        self.tabBar = tabBar
    }
    
    func start() {
        let statisticsViewController = sceneFactoryDIContainer.makeStatisticsView()
        navigationController = UINavigationController(rootViewController: statisticsViewController)
        guard let navigationController else { return }
        tabBar.viewControllers?.insert(navigationController, at: 1)
    }
}
