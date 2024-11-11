//
//  CoreHapticsManagerAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 11.11.2024.
//

import Swinject

final class CoreHapticsManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CoreHapticsManagerProtocol?.self) { _ in
            CoreHapticsManager()
        }.inObjectScope(.container)
    }
}
