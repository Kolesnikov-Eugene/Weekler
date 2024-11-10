//
//  ScheduleViewFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.11.2024.
//

import UIKit

final class ScheduleViewFlowCoordinator: Coordinator {
    var navigationController: UINavigationController?
    let dependencies: SceneFactoryProtocol
    private let tabBar: UITabBarController
    
    init(tabbar: UITabBarController, dependencies: SceneFactoryProtocol) {
//        self.navigationController = navigationController
        self.tabBar = tabbar
        self.dependencies = dependencies
    }
    
    func start() {
        let scheduleViewController = dependencies.makeScheduleViewController(coor: self as ScheduleViewFlowCoordinator)
        navigationController = UINavigationController(rootViewController: scheduleViewController)
        guard let navigationController else { return }
        tabBar.viewControllers?.insert(navigationController, at: 0)
        
    }
    
    func goToCreateScheduleView(for task: ScheduleTask?, with mode: CreateMode) {
        guard let factory = dependencies.createScheduleSceneContainer else {
            fatalError("Dependency createScheduleSceneContainer is nil")
        }
        
        let createScheduleVC = factory.makeCreateScheduleViewController(for: task, with: mode)
        
        if let sheet = createScheduleVC.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        createScheduleVC.hidesBottomBarWhenPushed = true
        navigationController?.present(createScheduleVC, animated: true)
    }
}

//protocol ScheduleCoordinator {
//    func goToCreateScheduleView(for task: ScheduleTask?, with mode: CreateMode)
//}
