//
//  DaysCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 23.04.2024.
//

import UIKit
import SnapKit

class DaysCollectionViewCell: UICollectionViewCell {
    private let dayOfWeekLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with day: String) {
        dayOfWeekLabel.text = day
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(dayOfWeekLabel)
        
        dayOfWeekLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
