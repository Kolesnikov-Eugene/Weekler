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
    private var scheduleFlowCoordinator: ScheduleViewFlowCoordinator?
    
    init(window: UIWindow, weeklerAppDI: WeeklerAppDIContainer) {
        self.window = window
        self.weeklerAppDI = weeklerAppDI
//        self.scheduleFlowCoordinator = ScheduleViewFlowCoordinator(dependencies: weeklerAppDI.makeSceneFactoryDIContainer())
    }
    
    func start() {
        let tabBarController = weeklerAppDI.makeTabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        scheduleFlowCoordinator = ScheduleViewFlowCoordinator(tabbar: tabBarController, dependencies: weeklerAppDI.makeSceneFactoryDIContainer())
        scheduleFlowCoordinator?.start()
    }
}
