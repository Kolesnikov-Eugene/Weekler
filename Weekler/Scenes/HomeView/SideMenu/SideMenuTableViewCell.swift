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
        
        return view
    }()
    private lazy var menuItemText: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
    }
}
