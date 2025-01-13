//
//  DarkModeCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 17.12.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DarkModeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = Colors.textColorMain
        label.textAlignment = .left
        label.text = "System theme"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = Colors.mainForeground
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deactivateSwitch),
            name: .colorDidChange,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    func update() {
        configureSwitchState()
    }
    
    func configure(with text: String) {
        textLabel.text = text
        configureSwitchState()
    }
    
    private func configureSwitchState() {
        switchControl.isOn = WeeklerUIManager.shared.selectedColor == Colors.viewBackground ? true : false
    }
    
    private func setupView() {
        addSubviews()
        applyConstrtaitns()
    }
    
    private func addSubviews() {
        addSubview(textLabel)
        addSubview(switchControl)
    }
    
    private func applyConstrtaitns() {
        // textLabel constraints
        textLabel.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview().inset(4)
        }
        
        // switch constraints
        switchControl.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(textLabel.snp.centerY)
        }
    }
    
    @objc
    private func deactivateSwitch() {
        if WeeklerUIManager.shared.selectedColor != Colors.viewBackground {
            switchControl.isOn = false
        }
    }
}
