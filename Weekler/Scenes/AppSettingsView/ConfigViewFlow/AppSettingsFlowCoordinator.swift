//
//  ConfigViewFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 11.11.2024.
//

import UIKit

enum SettingsItem: CaseIterable {
    case general
    case appearance
    case notification
    case date
    case help
    case about
}

protocol SettingsFlowCoordinator {
    func start()
    func navigate(to screen: SettingsItem)
}

final class AppSettingsFlowCoordinator: Coordinator {
    
    // TODO: - change navController to router
    // MARK: - private properties
    private var navigationController: UINavigationController?
    private let tabBarController: UITabBarController
    private let sceneFactoryDIContainer: SceneFactoryProtocol
    
    // MARK: - lifecycle
    init(
        tabBarController: UITabBarController,
        sceneFactoryDIContainer: SceneFactoryProtocol
    ) {
        self.tabBarController = tabBarController
        self.sceneFactoryDIContainer = sceneFactoryDIContainer
    }
    
    // MARK: - public methods
    func start() {
        // TODO: - inject coordinator into viewModel
        let configViewController = sceneFactoryDIContainer.makeConfigViewController(coordinator: self as SettingsFlowCoordinator)
        navigationController = UINavigationController(rootViewController: configViewController)
        
        navigationController?.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.config,  // FIXME: rename tab title
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil)
        
        guard let navigationController else { return }
        tabBarController.viewControllers?.insert(navigationController, at: 2)
//        tabBarController.viewControllers?.append(navigationController)
    }
}

extension AppSettingsFlowCoordinator: SettingsFlowCoordinator {
    func navigate(to screen: SettingsItem) {
        let viewController = sceneFactoryDIContainer.makeSettingsScreen(screen)
        viewController.hidesBottomBarWhenPushed = true
        if let navigationController = tabBarController.selectedViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
