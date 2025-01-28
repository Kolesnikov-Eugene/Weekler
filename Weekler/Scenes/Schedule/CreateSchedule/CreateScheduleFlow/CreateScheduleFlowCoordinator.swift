//
//  CreateScheduleFlowCoordinator.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 27.01.2025.
//

import UIKit

final class CreateScheduleFlowCoordinator: Coordinator {
    
    // MARK: - public properties
    weak var parentCoordinator: ScheduleFlowCoordinator?
    
    // MARK: - private properties
    private var dependencies: CreateScheduleSceneProtocol
    private var navigationController: UINavigationController?
    private var task: ScheduleTask?
    private var mode: CreateMode
    
    init(
        parentCoordinator: ScheduleFlowCoordinator?,
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
        let createScheduleVC = dependencies.makeCreateScheduleViewController(
            for: task,
            with: mode,
            coordinator: self
        )
        let createScheduleNavController = UINavigationController(rootViewController: createScheduleVC)
        createScheduleVC.hidesBottomBarWhenPushed = true
        navigationController?.present(createScheduleNavController, animated: true)
    }
    
    func finish() {
        navigationController?.dismiss(animated: true)
        parentCoordinator?.dismissCreateSchedule()
//        parentCoordinator = nil
    }
}
