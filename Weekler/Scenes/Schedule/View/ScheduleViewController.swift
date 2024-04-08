//
//  ViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 21.03.2024.
//

import UIKit


final class ScheduleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.background
        
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = false
            navigationItem.title = "Current week"
            navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        }
    }
}
