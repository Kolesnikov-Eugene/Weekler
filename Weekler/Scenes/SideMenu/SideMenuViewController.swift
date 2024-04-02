//
//  SideMenuViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.04.2024.
//

import UIKit
import SnapKit

final class SideMenuViewController: UIViewController {
    private let reuseIdentifier = "menuCell"
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
        applyConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.grayBackground
        tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier, for: indexPath) as? SideMenuTableViewCell else {
            return UITableViewCell()
        }
        
        let text = MenuOptions.allCases[indexPath.row].rawValue
        let imageDescription = "folder"
        cell.configureCell(menuText: text, imageDescription: imageDescription)
        
        return cell
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


