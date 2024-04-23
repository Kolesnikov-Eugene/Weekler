//
//  CalendarCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 16.04.2024.
//

import UIKit
import SnapKit

final class CalendarCollectionViewCell: UICollectionViewCell {
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.distribution = .fillEqually
        view.backgroundColor = UIColor(resource: .background)
        view.layer.cornerRadius = 12
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
        
        stackView.layer.cornerRadius = 12
        stackView.layer.shadowRadius = 2
        stackView.layer.shadowOpacity = 0.2
        stackView.layer.shadowOffset = CGSize.zero
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(dateLabel)
    }
    
    private func applyConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureCell() {
        dayLabel.text = "Mon"
        dateLabel.text = "14"
    }
}
