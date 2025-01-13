//
//  ThemeCollectionViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 17.12.2024.
//

import UIKit
import SnapKit

final class ThemeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var themeBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var collectionPatternView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var buttonPatternView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    private lazy var checkmarkImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "checkmark")
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.isHidden = true
//        return imageView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideCheckmark),
            name: .colorDidChange,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonPatternView.layer.cornerRadius = buttonPatternView.frame.height / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        themeBackgroundView.layer.borderWidth = 0
    }
    
    func selectCell() {
        switchBorderState()
    }
    
    func deselectCell() {
        switchBorderState()
//        themeBackgroundView.layer.borderWidth = 0
    }
    
    @objc
    func hideCheckmark() {
        if WeeklerUIManager.shared.selectedColor == Colors.viewBackground {
            isSelected = false
            switchBorderState()
        }
    }
    
    func configure(with color: UIColor) {
        themeBackgroundView.backgroundColor = color
        isSelected = color == WeeklerUIManager.shared.selectedColor
        switchBorderState()
    }
    
    private func setupView() {
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        addSubview(themeBackgroundView)
//        addSubview(checkmarkImageView)
//        addSubview(checkmarkView)
        addSubview(collectionPatternView)
        addSubview(buttonPatternView)
    }
    
    private func applyConstraints() {
        // themeBackgroundView constraints
        themeBackgroundView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview().inset(10)
        }
        
        // collectionPatternView constraints
        collectionPatternView.snp.makeConstraints {
            $0.trailing.leading.top.equalTo(themeBackgroundView).inset(20)
            $0.bottom.equalTo(themeBackgroundView).inset(40)
        }
        
        // buttonPatternView constraitns
        buttonPatternView.snp.makeConstraints{
            $0.bottom.trailing.equalTo(themeBackgroundView).inset(10)
            $0.width.height.equalTo(20)
        }
        
        // checkmarkImageView constraitns
//        checkmarkImageView.snp.makeConstraints {
//            $0.trailing.top.equalTo(themeBackgroundView)
//            $0.width.height.equalTo(16)
//        }
//        checkmarkView.snp.makeConstraints {
//            $0.trailing.top.equalTo(themeBackgroundView)
//            $0.width.height.equalTo(18)
//        }
    }
    
    private func switchBorderState() {
        themeBackgroundView.layer.borderWidth = isSelected ? 2 : 0
//        checkmarkImageView.isHidden = !isSelected
//        checkmarkView.isHidden = color != WeeklerUIManager.shared.selectedColor
    }
}

//final class CheckmarkView: UIView {
//    
//    private lazy var checkmarkImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "checkmark")
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
////        imageView.isHidden = true
//        imageView.backgroundColor = WeeklerUIManager.shared.selectedColor
//        return imageView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupView() {
//        backgroundColor = .white
//        addSubview(checkmarkImageView)
//        
//        checkmarkImageView.snp.makeConstraints {
//            $0.top.bottom.trailing.leading.equalToSuperview().inset(1)
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.layer.cornerRadius = bounds.height / 2
//        checkmarkImageView.layer.cornerRadius = checkmarkImageView.bounds.height / 2
//    }
//}
