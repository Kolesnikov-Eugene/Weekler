//
//  ScheduleViewFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.11.2024.
//

import UIKit

final class ScheduleFlowCoordinator: Coordinator {
    
    // MARK: - private properties
    private var navigationController: UINavigationController?
    private let sceneFactoryDIContainer: SceneFactoryProtocol
    private let tabBar: UITabBarController
    private var childCoordinators: [Coordinator] = []
    
    // MARK: - lifecycle
    init(
        tabbar: UITabBarController,
        container: SceneFactoryProtocol
    ) {
        self.tabBar = tabbar
        self.sceneFactoryDIContainer = container
    }
    
    // MARK: - public methods
    func start() {
        let scheduleViewController = sceneFactoryDIContainer.makeScheduleViewController(coor: self as ScheduleFlowCoordinator)
        navigationController = UINavigationController(rootViewController: scheduleViewController)
        
        let image = UIImage(systemName: "list.bullet.clipboard")
        navigationController?.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.schedule,
            image: image,
            selectedImage: nil)
        
        guard let navigationController else { return }
        tabBar.setViewControllers([navigationController], animated: false)
    }
    
    func navigateToCreateScheduleView(for task: ScheduleTask?, with mode: CreateMode) {
        guard let factory = sceneFactoryDIContainer.createScheduleSceneContainer else {
            fatalError("Dependency createScheduleSceneContainer is nil")
        }
//        let createScheduleVC = factory.makeCreateScheduleViewController(for: task, with: mode)
//        let createScheduleNavController = UINavigationController(rootViewController: createScheduleVC)
//        createScheduleVC.hidesBottomBarWhenPushed = true
//        navigationController?.present(createScheduleNavController, animated: true)
        
        // Create coordinator impl
        let createScheduleCoordinator = CreateScheduleFlowCoordinator(
            parentCoordinator: self,
            dependencies: factory,
            navigationController: navigationController,
            task: task,
            mode: mode
        )
        createScheduleCoordinator.parentCoordinator = self
        createScheduleCoordinator.start()
        
        // TODO: manage coordinator lifecycle
        childCoordinators.append(createScheduleCoordinator)
    }
    
    func dismissCreateSchedule() {
        childCoordinators.removeAll()
    }
}
