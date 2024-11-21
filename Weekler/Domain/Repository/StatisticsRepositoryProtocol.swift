//
//  StatisticsRepositoryProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Foundation

protocol StatisticsRepositoryProtocol {
    func fetchStatistics(for currentWeek: [String]) async -> [ScheduleTask]
}
