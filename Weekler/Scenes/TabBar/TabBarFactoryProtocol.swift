//
//  TabBarFactoryProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Foundation

protocol TabBarFactoryProtocol {
    func createScheduleViewController() -> ScheduleViewController
    func createTaskEditorViewController() -> TaskEditorViewController
    func createConfigViewController() -> ConfigViewController
    func createStatisticsView() -> StatisticsViewController
}
