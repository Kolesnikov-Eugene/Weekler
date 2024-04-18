//
//  WeekCalendarCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.04.2024.
//

import UIKit
import JTAppleCalendar

class WeekCalendarCollectionViewCell: JTAppleCell {
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.textColor = .black
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(dateLabel)
    }
    
    private func applyConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    func configureCell() {
        
    }
}
