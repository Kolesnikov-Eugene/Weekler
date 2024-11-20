//
//  StatisticsRepository.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Foundation

final class StatisticsRepository: StatisticsRepositoryProtocol {
    
    private let dataSource: StatisticsDataSourceProtocol
    
    init(
        dataSource: StatisticsDataSourceProtocol
    ) {
        self.dataSource = dataSource
    }
    
    func fetchStatistics() async {
        print("Fetching statistics in repository...")
        await dataSource.fetchStatistics()
    }
}
