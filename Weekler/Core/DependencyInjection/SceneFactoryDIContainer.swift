//
//  SceneFactoryDIContainer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation

final class SceneFactoryDIContainer: SceneFactoryProtocol {
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func makeScheduleViewController() -> ScheduleViewController {
        let scheduleUseCase: ScheduleUseCaseProtocol = container.resolve()
        let scheduleViewModel: ScheduleViewModelProtocol = container.resolve(argument: scheduleUseCase)
        let createScheduleSceneContainer = makeCreateScheduleSceneDIContainer(viewModel: scheduleViewModel as? CreateScheduleDelegate)
        let scheduleVC: ScheduleViewController = container.resolve(arguments: scheduleViewModel, createScheduleSceneContainer)
        return scheduleVC
    }
    
    func makeTaskEditorViewController() -> TaskEditorViewController {
        let taskEditorVC: TaskEditorViewController = container.resolve()
        return taskEditorVC
    }
    
    func makeConfigViewController() -> ConfigViewController {
        let configVC: ConfigViewController = container.resolve()
        return configVC
    }
    
    func makeStatisticsView() -> StatisticsViewController {
        let statisticsVC: StatisticsViewController = container.resolve()
        return statisticsVC
    }
    
    func makeCreateScheduleSceneDIContainer(viewModel: CreateScheduleDelegate?) -> CreateScheduleSceneProtocol {
        let createScheduleSceneContainer: CreateScheduleSceneProtocol = container.resolve(arguments: container, viewModel)
        return createScheduleSceneContainer
    }
}
