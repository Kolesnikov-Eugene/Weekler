//
//  SelectMainModeCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 21.05.2024.
//

import UIKit
import SnapKit

final class SelectMainModeCollectionViewCell: UICollectionViewCell {
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = UIColor(resource: .calendarCurrentDate)
        label.textAlignment = .center
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.layer.masksToBounds = false
        textLabel.clipsToBounds = true
        textLabel.layer.cornerRadius = 5
    }
    
    //MARK: - public methods
    func configureCell() {
        textLabel.text = "some mode"
    }
    
    //MARK: - private methods
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(textLabel)
    }
    
    private func applyConstraints() {
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.top.equalTo(contentView.snp.top)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
}
