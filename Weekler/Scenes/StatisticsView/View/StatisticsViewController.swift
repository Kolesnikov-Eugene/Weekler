//
//  StatisticsViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.background
        
//        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.title = L10n.Localizable.Tab.statistics
    }
}
