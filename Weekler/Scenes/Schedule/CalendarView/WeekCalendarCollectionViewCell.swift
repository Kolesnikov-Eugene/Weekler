//
//  WeekCalendarCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.04.2024.
//

import UIKit
import JTAppleCalendar

class WeekCalendarCollectionViewCell: JTAppleCell {
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var selectedStateView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.clipsToBounds = true
//        view.layer.borderWidth = 1
//        view.layer.cornerRadius = 20
        view.backgroundColor = .clear
        
        
        return view
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
        selectedStateView.layer.cornerRadius = CGRectGetHeight(selectedStateView.bounds) / 2.0
//        selectedStateView.layer.cornerRadius = 25
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
        contentView.addSubview(selectedStateView)
        contentView.addSubview(dateLabel)
    }
    
    private func applyConstraints() {
        //date label constraints
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        //selected state view constraints
        selectedStateView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.leading.equalToSuperview()
//            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
    }
    
    func configureCell(with currentDate: String) {
        dateLabel.text = currentDate
    }
    
    func changeSelectionState(isSelected: Bool) {
        selectedStateView.backgroundColor = isSelected ? .red : .clear
    }
}
