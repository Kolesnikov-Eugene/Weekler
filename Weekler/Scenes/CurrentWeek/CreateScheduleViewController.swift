//
//  CurrentWeekViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.04.2024.
//

import UIKit

class CreateScheduleViewController: UIViewController {
    weak var delegate: HomeViewControllerDelegate?
    
    private lazy var leftBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        
        button.image = UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysTemplate)
        button.style = .plain
        button.target = self
        button.action = #selector(didTapMenuButton)
//        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.tintColor = .black
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.background
        title = "Create your big plans"
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
}
