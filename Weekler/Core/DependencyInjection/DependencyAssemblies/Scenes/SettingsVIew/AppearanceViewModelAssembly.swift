//
//  AppearanceViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.01.2025.
//

import Swinject

final class AppearanceViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppearanceViewModelProtocol.self) {
            _ in AppearanceViewModel()
        }.inObjectScope(.container)
    }
}
