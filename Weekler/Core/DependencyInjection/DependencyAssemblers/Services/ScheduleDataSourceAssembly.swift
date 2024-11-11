//
//  ScheduleDataSourceAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 06.11.2024.
//

import Swinject

final class ScheduleDataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ScheduleDataSourceProtocol.self) { _ in
            ScheduleDataSource()
        }.inObjectScope(.container)
    }
}
