//
//  ScheduleViewFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.11.2024.
//

import UIKit

final class ScheduleFlowCoordinator: Coordinator {
    private var navigationController: UINavigationController?
    private let sceneFactoryDIContainer: SceneFactoryProtocol
    private let tabBar: UITabBarController
    
    init(
        tabbar: UITabBarController,
        container: SceneFactoryProtocol
    ) {
        self.tabBar = tabbar
        self.sceneFactoryDIContainer = container
    }
    
    func start() {
        let scheduleViewController = sceneFactoryDIContainer.makeScheduleViewController(coor: self as ScheduleFlowCoordinator)
        navigationController = UINavigationController(rootViewController: scheduleViewController)
        guard let navigationController else { return }
        tabBar.setViewControllers([navigationController], animated: false)
    }
    
    func goToCreateScheduleView(for task: ScheduleTask?, with mode: CreateMode) {
        guard let factory = sceneFactoryDIContainer.createScheduleSceneContainer else {
            fatalError("Dependency createScheduleSceneContainer is nil")
        }
        let createScheduleVC = factory.makeCreateScheduleViewController(for: task, with: mode)
        createScheduleVC.hidesBottomBarWhenPushed = true
        navigationController?.present(createScheduleVC, animated: true)
    }
}
