//
//  ScheduleRepositoryAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 05.11.2024.
//

import Swinject

final class ScheduleRepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ScheduleRepositoryProtocol.self) { resolver in
            guard let dataSource = resolver.resolve(ScheduleDataSourceProtocol.self) else {
                fatalError("ScheduleDataSourceProtocol is not registered")
            }
            return ScheduleRepository(dataSource: dataSource)
        }.inObjectScope(.container)
    }
}
