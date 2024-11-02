//
//  CreateSceneDIContainer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.11.2024.
//

import Foundation

final class CreateSceneDIContainer: CreateScheduleSceneProtocol {
    private let container: DIContainer
    private let createScheduleDelegate: CreateScheduleDelegate?
    
    init(container: DIContainer, createScheduleDelegate: CreateScheduleDelegate?) {
        self.container = container
        self.createScheduleDelegate = createScheduleDelegate
    }
    
    func makeCreateScheduleViewController(for task: ScheduleTask?, with mode: CreateMode) -> CreateScheduleViewController {
        let createViewModel: CreateScheduleViewModelProtocol = DIContainer.shared.resolve(arguments: createScheduleDelegate, task)
        let createScheduleVC: CreateScheduleViewController = DIContainer.shared.resolve(arguments: createViewModel, mode)
        return createScheduleVC
    }
}

protocol CreateScheduleSceneProtocol {
    func makeCreateScheduleViewController(for task: ScheduleTask?, with mode: CreateMode) -> CreateScheduleViewController
}
