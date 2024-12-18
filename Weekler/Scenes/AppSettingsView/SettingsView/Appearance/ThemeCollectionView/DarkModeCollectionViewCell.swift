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
        label.text = "System theme"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.onTintColor = Colors.mainForeground
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
    
    func configure(with text: String) {
        textLabel.text = text
    }
    
    private func setupView() {
//        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = 8
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
            $0.centerY.equalTo(textLabel.snp.centerY)
//            $0.height.equalTo(20)
        }
    }
}
