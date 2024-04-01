//
//  SideMenuViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.04.2024.
//

import UIKit
import SnapKit

final class SideMenuViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
