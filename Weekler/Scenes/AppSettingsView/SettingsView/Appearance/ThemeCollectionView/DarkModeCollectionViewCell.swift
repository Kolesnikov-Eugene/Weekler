//
//  DarkModeCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 17.12.2024.
//

import UIKit
import SnapKit

final class DarkModeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = Colors.textColorMain
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.tintColor = Colors.mainForeground
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = Colors.viewBackground // Change
        addSubviews()
        applyConstrtaitns()
    }
    
    private func addSubviews() {
        addSubview(textLabel)
        addSubview(switchControl)
    }
    
    private func applyConstrtaitns() {
        // textLabel constraints
        textLabel.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
        
        // switch constraints
        switchControl.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
}
