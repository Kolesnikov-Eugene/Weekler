//
//  SceneFactoryDIContainer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation

final class SceneFactoryDIContainer: SceneFactoryProtocol {
    
    // MARK: - public properties
    var createScheduleSceneContainer: CreateScheduleSceneProtocol?
    
    // MARK: - private properties
    private let container: DIContainer
    
    // MARK: - lifecycle
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    // MARK: - public methods
    func makeScheduleViewController(coor: ScheduleFlowCoordinator) -> ScheduleViewController {
        let hapticsManager = makeCoreHapticsManager()
        let scheduleViewModel: ScheduleViewModelProtocol = container.resolve(
            arguments: self as SceneFactoryProtocol, coor, hapticsManager
        )
        createScheduleSceneContainer = makeCreateScheduleSceneDIContainer(viewModel: scheduleViewModel as? CreateScheduleDelegate)
        let scheduleVC: ScheduleViewController = container.resolve(argument: scheduleViewModel)
        return scheduleVC
    }
    
    func makeConfigViewController() -> AppSettingsViewController {
        let configVC: AppSettingsViewController = container.resolve()
        return configVC
    }
    
    func makeStatisticsView() -> StatisticsViewController {
        let statisticsService: StatisticsServiceProtocol = container.resolve()
        let statisticsViewModel: StatisticsViewModelProtocol = container.resolve(argument: statisticsService)
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
