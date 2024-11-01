//
//  TabBarfactoryAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Swinject

final class SceneFactoryAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(SceneFactoryProtocol.self) { resolver, container in
            SceneFactoryDIContainer(container: container)
        }.inObjectScope(.container)
    }
}
