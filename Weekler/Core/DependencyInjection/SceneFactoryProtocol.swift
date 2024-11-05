//
//  TabBarFactoryProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Foundation

protocol SceneFactoryProtocol {
    func makeScheduleViewController() -> ScheduleViewController
    func makeTaskEditorViewController() -> TaskEditorViewController
    func makeConfigViewController() -> ConfigViewController
    func makeStatisticsView() -> StatisticsViewController
    func makeScheduleUseCase() -> ScheduleUseCaseProtocol
}
