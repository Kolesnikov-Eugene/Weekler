//
//  StatisticsServiceProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Foundation

protocol StatisticsServiceProtocol {
    func fetchCurrentWeekStatistics(for currentWeek: [String]) async -> [ScheduleTask]
}
