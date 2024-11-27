//
//  WeeklerAppCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.11.2024.
//

import UIKit

protocol Coordinator {
    func start()
}

final class WeeklerAppCoordinator: Coordinator {
    private let window: UIWindow
    private let weeklerAppDI: WeeklerAppDIContainer
    private var childCoordinators: [Coordinator?] = []
    private let sceneFactoryDIContainer: SceneFactoryProtocol
    private let tabBarController: UITabBarController
    
    init(
        window: UIWindow,
        weeklerAppDI: WeeklerAppDIContainer
    ) {
        self.window = window
        self.weeklerAppDI = weeklerAppDI
        sceneFactoryDIContainer = weeklerAppDI.makeSceneFactoryDIContainer()
        tabBarController = weeklerAppDI.makeTabBarController()
    }
    
    func start() {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        startFlows()
    }
    
    private func startFlows() {
        // MARK: Schedule Flow
        let scheduleFlowCoordinator = ScheduleFlowCoordinator(
            tabbar: tabBarController,
            container: sceneFactoryDIContainer
        )
        childCoordinators.append(scheduleFlowCoordinator)
        
        // MARK: Statistics Flow
        let statisticsFlowCoordinator = StatisticsFlowCoordinator(
            sceneFactoryDIContainer: sceneFactoryDIContainer,
            tabBar: tabBarController
        )
        childCoordinators.append(statisticsFlowCoordinator)
        
        // MARK: Config Flow
        let configFlowCoordinator = ConfigFlowCoordinator(
            tabBarController: tabBarController,
            sceneFactoryDIContainer: sceneFactoryDIContainer
        )
        childCoordinators.append(configFlowCoordinator)
        
        childCoordinators.forEach { $0?.start() }
    }
}
