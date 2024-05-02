//
//  TabBarfactoryAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Swinject

final class TabBarFactoryAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(TabBarFactory.self) { _ in
            TabBarFactory()
        }
    }
}
