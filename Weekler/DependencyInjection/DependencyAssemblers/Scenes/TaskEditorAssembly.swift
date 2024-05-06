//
//  TaskEditorAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Swinject

final class TaskEditorAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(TaskEditorViewController.self) { _ in
            TaskEditorViewController()
        }.inObjectScope(.container)
    }
}
