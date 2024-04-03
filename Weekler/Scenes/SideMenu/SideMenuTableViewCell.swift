//
//  SideMenuTableViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.04.2024.
//

import UIKit
import SnapKit


final class SideMenuTableViewCell: UITableViewCell {
    private lazy var menuIconImageView: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor(resource: .sideMenuText)
        
        return view
    }()
    private lazy var menuItemText: UILabel = {
        let label = UILabel()

        label.textColor = UIColor(resource: .sideMenuText)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = Colors.grayBackground
        
        contentView.addSubview(menuItemText)
        contentView.addSubview(menuIconImageView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            menuIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            menuIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            menuIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            menuItemText.topAnchor.constraint(equalTo: menuIconImageView.topAnchor),
            menuItemText.leadingAnchor.constraint(equalTo: menuIconImageView.trailingAnchor, constant: 20),
            menuItemText.centerYAnchor.constraint(equalTo: menuIconImageView.centerYAnchor)
        ])
    }
    
    func configureCell(menuText: String, imageDescription: String) {
        menuItemText.text = menuText
        
        let cellImage = UIImage(systemName: imageDescription)?.withRenderingMode(.alwaysTemplate)
        menuIconImageView.image = cellImage
    }
}
