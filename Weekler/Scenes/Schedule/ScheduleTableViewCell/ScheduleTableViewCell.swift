//
//  ScheduleTableViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import UIKit
import SnapKit

final class ScheduleTableViewCell: UITableViewCell {
    
    private lazy var checkmarkButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)
        configuration.baseForegroundColor = .orange
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(didTapCheckmarkButton), for: .touchUpInside)
        
        return button
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "12:00"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var scheduleDescriptionlabel: UILabel = {
        let label = UILabel()
        
        label.text = "Some task that should be fulfilled"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        mainView.layer.shadowRadius = 4
//        mainView.layer.shadowOpacity = 0.5
//        mainView.layer.shadowOffset = CGSize.zero
    }
    
    func configureCell() {
        
    }

    private func setupUI() {
        contentView.backgroundColor = Colors.background
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(scheduleDescriptionlabel)
        contentView.addSubview(separatorView)
    }
    
    private func applyConstraints() {
        //checkmarkButton
        checkmarkButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(separatorView.snp.leading)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        //timeLabel constraints
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(separatorView.snp.leading)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(40)
        }
        
        //schedule description constraints
        scheduleDescriptionlabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.trailing).offset(16)
            $0.top.equalTo(contentView.snp.top)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.trailing.equalTo(contentView.snp.trailing)
        }
        
        //separatorView constraints
        separatorView.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.leading.equalTo(contentView.snp.leading).inset(40)
            $0.height.equalTo(0.5)
        }
    }
    
    @objc private func didTapCheckmarkButton() {
        print("checkmark")
    }
}
