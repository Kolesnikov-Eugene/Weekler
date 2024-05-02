//
//  TabBarAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 26.04.2024.
//

import Swinject

final class TabBarAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(TabBarController.self) { _, factory in
            TabBarController(tabBarFactory: factory)
        }.inObjectScope(.container)
    }
}
