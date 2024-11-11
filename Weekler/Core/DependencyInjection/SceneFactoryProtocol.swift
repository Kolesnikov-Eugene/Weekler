//
//  TabBarFactoryProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Foundation

protocol SceneFactoryProtocol {
    var createScheduleSceneContainer: CreateScheduleSceneProtocol? { get }
    func makeScheduleViewController(coor: ScheduleFlowCoordinator) -> ScheduleViewController
    func makeConfigViewController() -> ConfigViewController
    func makeStatisticsView() -> StatisticsViewController
    func makeScheduleUseCase() -> ScheduleUseCaseProtocol
    func makeCoreHapticsManager() -> CoreHapticsManagerProtocol?
}
