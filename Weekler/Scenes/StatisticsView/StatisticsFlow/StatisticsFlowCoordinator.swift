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
        guard let navigationController else { return }
        tabBar.viewControllers?.insert(navigationController, at: 1)
    }
}
