//
//  WeekCalendarCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.04.2024.
//

import UIKit
import JTAppleCalendar

class WeekCalendarCollectionViewCell: JTAppleCell {
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var currentDayView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        view.isHidden = true
        view.backgroundColor = Colors.calendarCurrentDateBackground
        
        return view
    }()
    private lazy var selectedStateView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.clipsToBounds = true
        view.backgroundColor = .clear
        
        return view
    }()
    private lazy var dateStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        currentDayView.layer.cornerRadius = CGRectGetHeight(currentDayView.bounds) / 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = ""
        dateLabel.textColor = .black
        selectedStateView.backgroundColor = .clear
        currentDayView.isHidden = true
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(currentDayView)
        contentView.addSubview(selectedStateView)
        contentView.addSubview(dateStackView)
        dateStackView.addArrangedSubview(dayLabel)
        dateStackView.addArrangedSubview(dateLabel)
    }
    
    private func applyConstraints() {
        //dateStackViewConstraints
        dateStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        //selectedStateView constraints
        selectedStateView.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.centerX.equalTo(dateLabel.snp.centerX)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
        
        currentDayView.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.centerX.equalTo(dateLabel.snp.centerX)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
    }
    
    func configureCell(currentDate: String, day: String, isCurrent: Bool) {
        dayLabel.text = day
        dateLabel.text = currentDate
        currentDayView.isHidden = !isCurrent
    }
    
    func changeSelectionState(isSelected: Bool) {
        selectedStateView.backgroundColor = isSelected ? Colors.dateSelectedBackground : .clear
    }
}
