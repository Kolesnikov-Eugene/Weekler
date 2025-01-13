//
//  StatisticsRepositoryAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Swinject

final class StatisticsRepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StatisticsRepositoryProtocol.self) { resolver in
            guard let dataSource = resolver.resolve(ScheduleDataSourceProtocol.self) as? StatisticsDataSourceProtocol else {
                fatalError("StatisitcsDataSourceProtocol is not registered")
            }
            return StatisticsRepository(dataSource: dataSource)
        }.inObjectScope(.container)
    }
}
