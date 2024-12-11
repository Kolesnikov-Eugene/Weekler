//
//  AppSettingsCollectionCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.12.2024.
//

import UIKit
import SnapKit

final class AppSettingsCollectionCell: UICollectionViewCell {
    
    // MARK: - private properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .left
        label.textColor = Colors.textColorMain
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = Colors.textColorMain
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    func animateCellSelection() {
        UIView.animate(withDuration: 0.1) {
                self.contentView.backgroundColor = .lightGray
            } completion: { _ in
                self.setBackgroundColor()
            }
    }
    
    func configureCell(
        with title: String,
        and configuration: AppSettingsCellConfiguration
    ) {
        titleLabel.text = title
        reconfigureView(with: configuration)
    }
    
    // MARK: - provate methods
    private func reconfigureView(with configuration: AppSettingsCellConfiguration) {
        separatorView.isHidden = configuration.isLast
        if configuration.roundedTopCorners {
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if configuration.roundedBottomCorners {
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            contentView.layer.maskedCorners = []
        }
    }
    
    private func setupView() {
        addSubviews()
        applyConstraints()
        setBackgroundColor()
        contentView.layer.cornerRadius = 12
    }
    
    private func setBackgroundColor() {
        contentView.backgroundColor = UIColor(resource: .settingsCell)
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(separatorView)
    }
    
    private func applyConstraints() {
        // titleLabel constraints
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        
        // chevron constraints
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        // separatorView constraints
        separatorView.snp.makeConstraints {
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(0.5)
        }
    }
}
