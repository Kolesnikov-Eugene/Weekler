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
    private lazy var themeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectCell() {
        checkmarkImageView.isHidden.toggle()
    }
    
    func deselectCell() {
        checkmarkImageView.isHidden.toggle()
    }
    
    func configure(with color: UIColor) {
        themeView.backgroundColor = color
    }
    
    private func setupView() {
        addSubview(themeView)
        addSubview(checkmarkImageView)
        
        themeView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview().inset(10)
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.trailing.top.equalTo(themeView)
            $0.width.height.equalTo(16)
        }
    }
}
