//
//  TabBarAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 26.04.2024.
//

import Swinject

final class TabBarAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(TabBarController.self) { resolver in
            guard let tabBarFactory = resolver.resolve(TabBarFactory.self) else {
                fatalError("TabBarFactory could not be resolved")
            }
            return TabBarController(tabBarFactory: tabBarFactory)
        }.inObjectScope(.container)
    }
}
