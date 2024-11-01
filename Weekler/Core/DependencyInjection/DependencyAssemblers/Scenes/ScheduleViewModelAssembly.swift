//
//  ScheduleViewModelAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.07.2024.
//

import Swinject

final class ScheduleViewModelAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ScheduleViewModelProtocol.self) { resolver, scheduleDataManager in
            ScheduleViewModel(scheduleDataManager: scheduleDataManager)
        }.inObjectScope(.container)
    }
}
