//
//  CreateScheduleFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 27.01.2025.
//

import UIKit

final class CreateScheduleFlowCoordinator: Coordinator {
    
    private var dependencies: CreateScheduleSceneProtocol
    private var navigationController: UINavigationController?
    private var task: ScheduleTask?
    private var mode: CreateMode
    
    init(
        dependencies: CreateScheduleSceneProtocol,
        navigationController: UINavigationController?,
        task: ScheduleTask?,
        mode: CreateMode
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
        self.task = task
        self.mode = mode
    }
    
    deinit { print("------------------DEINIT--------------------------------") }
    
    func start() {
        let createScheduleVC = dependencies.makeCreateScheduleViewController(for: task, with: mode)
        let createScheduleNavController = UINavigationController(rootViewController: createScheduleVC)
        createScheduleVC.hidesBottomBarWhenPushed = true
        navigationController?.present(createScheduleNavController, animated: true)
    }
}
