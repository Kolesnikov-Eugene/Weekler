//
//  ConfigViewFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 11.11.2024.
//

import UIKit

final class AppSettingsFlowCoordinator: Coordinator {
    private var navigationController: UINavigationController?
    private let tabBarController: UITabBarController
    private let sceneFactoryDIContainer: SceneFactoryProtocol
    
    init(
        tabBarController: UITabBarController,
        sceneFactoryDIContainer: SceneFactoryProtocol
    ) {
        self.tabBarController = tabBarController
        self.sceneFactoryDIContainer = sceneFactoryDIContainer
    }
    
    func start() {
        let configViewController = sceneFactoryDIContainer.makeConfigViewController()
        navigationController = UINavigationController(rootViewController: configViewController)
        guard let navigationController else { return }
        tabBarController.viewControllers?.insert(navigationController, at: 2)
    }
    
}
