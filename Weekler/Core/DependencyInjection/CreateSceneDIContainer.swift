//
//  CreateSceneDIContainer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.11.2024.
//

import Foundation

final class CreateSceneDIContainer: CreateScheduleSceneProtocol {
    
    // MARK: - private properties
    private let container: DIContainer
    private let createScheduleDelegate: CreateScheduleDelegate?
    
    // MARK: - lifecycle
    init(
        container: DIContainer,
        createScheduleDelegate: CreateScheduleDelegate?
    ) {
        self.container = container
        self.createScheduleDelegate = createScheduleDelegate
    }
    
    // MARK: - public methods
    func makeCreateScheduleViewController(
        for task: ScheduleTask?,
        with mode: CreateMode,
        coordinator: CreateScheduleFlowCoordinator?
    ) -> CreateScheduleViewController {
        let createViewModel: CreateScheduleViewModelProtocol = DIContainer.shared.resolve(arguments: createScheduleDelegate, task)
        let createScheduleVC: CreateScheduleViewController = DIContainer.shared.resolve(arguments: createViewModel, mode, coordinator)
        return createScheduleVC
    }
}

protocol CreateScheduleSceneProtocol {
    func makeCreateScheduleViewController(
        for task: ScheduleTask?,
        with mode: CreateMode,
        coordinator: CreateScheduleFlowCoordinator?
    ) -> CreateScheduleViewController
}
