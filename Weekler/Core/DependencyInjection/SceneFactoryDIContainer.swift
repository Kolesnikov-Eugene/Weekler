//
//  SceneFactoryDIContainer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation

final class SceneFactoryDIContainer: SceneFactoryProtocol {
    private let container: DIContainer
    var createScheduleSceneContainer: CreateScheduleSceneProtocol?
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    func makeScheduleViewController(coor: ScheduleFlowCoordinator) -> ScheduleViewController {
        let hapticsManager = makeCoreHapticsManager()
        let scheduleViewModel: ScheduleViewModelProtocol = container.resolve(
            arguments: self as SceneFactoryProtocol, coor, hapticsManager
        )
        createScheduleSceneContainer = makeCreateScheduleSceneDIContainer(viewModel: scheduleViewModel as? CreateScheduleDelegate)
        let scheduleVC: ScheduleViewController = container.resolve(argument: scheduleViewModel)
        return scheduleVC
    }
    
    func makeConfigViewController() -> ConfigViewController {
        let configVC: ConfigViewController = container.resolve()
        return configVC
    }
    
    func makeStatisticsView() -> StatisticsViewController {
        let statisticsViewModel: StatisticsViewModelProtocol = container.resolve()
        let statisticsVC: StatisticsViewController = container.resolve(argument: statisticsViewModel)
        return statisticsVC
    }
    
    func makeCreateScheduleSceneDIContainer(viewModel: CreateScheduleDelegate?) -> CreateScheduleSceneProtocol {
        let createScheduleSceneContainer: CreateScheduleSceneProtocol = container.resolve(arguments: container, viewModel)
        return createScheduleSceneContainer
    }
    
    func makeScheduleUseCase() -> ScheduleUseCaseProtocol {
        let scheduleUseCase: ScheduleUseCaseProtocol = container.resolve()
        return scheduleUseCase
    }
    
    func makeCoreHapticsManager() -> CoreHapticsManagerProtocol? {
        let hapticsManager: CoreHapticsManagerProtocol? = container.resolve()
        return hapticsManager
    }
}
