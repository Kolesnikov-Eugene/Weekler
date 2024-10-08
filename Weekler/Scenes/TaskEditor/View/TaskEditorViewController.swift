//
//  TaskEditorViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

class TaskEditorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.viewBackground
        
//        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.title = L10n.Localizable.Tab.edit
    }
}
