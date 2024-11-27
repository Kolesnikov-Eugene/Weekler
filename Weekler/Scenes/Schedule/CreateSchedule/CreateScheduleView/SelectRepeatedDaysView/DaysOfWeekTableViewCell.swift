//
//  DaysOfWeekTableViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.07.2024.
//

import UIKit
import SnapKit

final class DayOfWeekTableViewCell: UITableViewCell {
    // MARK: - private properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.textColorMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var selectedDayButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "square")?.withRenderingMode(.alwaysTemplate)
        configuration.baseForegroundColor = Colors.textColorMain
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 17.0, *) {
            button.isSymbolAnimationEnabled = true
        }
        
        button.addTarget(self, action: #selector(didTapSelectedDayButton), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    func configureCell(with title: String) {
        titleLabel.text = title
    }
    
    private func setupUI() {
        contentView.backgroundColor = Colors.viewBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectedDayButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).inset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        selectedDayButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).inset(20)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
    @objc private func didTapSelectedDayButton() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        let image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = Colors.mainForeground
        UIView.animate(withDuration: 0.1) {

            self.selectedDayButton.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.center.equalTo(self.selectedDayButton.snp.center)
            }
        }
//        var configuration = UIButton.Configuration.plain()
//        configuration.image = UIImage(systemName: "checkmark.square")?.withRenderingMode(.alwaysTemplate)
//        configuration.baseForegroundColor = .black
//        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
//
//        let btn = UIButton(configuration: configuration)

//        self.selectedDayButton.configuration = configuration
    }
}
