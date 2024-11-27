//
//  StatisticsServiceAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Swinject

final class StatisticsServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StatisticsServiceProtocol.self) { resolver in
            guard let repository = resolver.resolve(StatisticsRepositoryProtocol.self) else {
                fatalError("StatisticsRepository is not registered")
            }
            return StatisticsService(statisticsRepository: repository)
        }.inObjectScope(.container)
    }
}
