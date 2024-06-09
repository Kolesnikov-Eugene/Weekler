//
//  ScheduleItemsTableViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 07.06.2024.
//

import UIKit
import SnapKit

final class ScheduleItemsTableViewCell: UITableViewCell {
    
    //Private properties
    private lazy var cellTypeImageView: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var forwardArrow: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "chevron.forward")
        view.tintColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var separatorString: UIView = {
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
    
    func configureCell(index: Int) {
        switch index {
        case 0:
            cellTypeImageView.image = UIImage(systemName: "calendar")
            cellTypeImageView.tintColor = .orange
            descriptionLabel.text = "Дата"
        case 1:
            cellTypeImageView.image = UIImage(systemName: "clock")
            cellTypeImageView.tintColor = .orange
            descriptionLabel.text = "Время"
        case 2:
            cellTypeImageView.image = UIImage(systemName: "bell")
            cellTypeImageView.tintColor = .orange
            descriptionLabel.text = "Уведомление"
        case 3:
            cellTypeImageView.image = UIImage(systemName: "repeat")
            cellTypeImageView.tintColor = .orange
            descriptionLabel.text = "Повтор"
        default:
            break
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = Colors.background
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(cellTypeImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(forwardArrow)
        contentView.addSubview(separatorString)
    }
    
    private func applyConstraints() {
        //cellTypeImageView constraints
        cellTypeImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
        
        //descriptionLabel constraints
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(cellTypeImageView.snp.trailing).offset(10)
            $0.centerY.equalTo(cellTypeImageView.snp.centerY)
            $0.height.equalTo(30)
        }
        
        //forwardArrow constraints
        forwardArrow.snp.makeConstraints {
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing)
            $0.centerY.equalTo(descriptionLabel.snp.centerY)
        }
        
        //separatorString constraints
        separatorString.snp.makeConstraints {
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(descriptionLabel.snp.leading)
            $0.trailing.equalTo(forwardArrow.snp.trailing)
            $0.height.equalTo(0.5)
        }
    }
}
