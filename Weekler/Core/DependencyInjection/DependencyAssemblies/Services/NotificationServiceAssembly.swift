//
//  NotificationServiceAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 29.01.2025.
//

import Swinject

final class NotificationServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LocalNotificationServiceProtocol.self) { _ in
            NotificationService()
        }.inObjectScope(.container)
    }
}
