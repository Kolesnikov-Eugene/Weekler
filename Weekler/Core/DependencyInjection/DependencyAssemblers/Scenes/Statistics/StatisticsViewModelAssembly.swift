//
//  StatisticsViewModelAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.11.2024.
//

import Swinject

final class StatisticsViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StatisticsViewModelProtocol.self) { resolver, statisticsService in
            StatisticsViewModel(statisticsService: statisticsService)
        }.inObjectScope(.container)
    }
}
