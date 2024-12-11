//
//  AppSettingsViewModelAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.12.2024.
//

import Swinject

final class AppSettingsViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppSettingsViewModelProtocol.self) { _ in AppSettingsViewModel() }
            .inObjectScope(.container)
    }
}
