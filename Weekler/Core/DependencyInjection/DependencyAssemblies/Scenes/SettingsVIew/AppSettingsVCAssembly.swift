//
//  ConfigViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Swinject

final class AppSettingsVCAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(AppSettingsViewController.self) { _ in
            guard let viewModel = container.resolve(AppSettingsViewModelProtocol.self) else {
                fatalError("AppSettingsViewModel not registered")
            }
            return AppSettingsViewController(viewModel: viewModel)
        }.inObjectScope(.container)
    }
}
