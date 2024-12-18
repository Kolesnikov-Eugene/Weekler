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
//        view.backgroundColor = Colors.viewBackground
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.red.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        themeView.backgroundColor = color
    }
    
    private func setupView() {
//        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = 8
        addSubview(themeView)
        themeView.snp.makeConstraints {
            $0.trailing.leading.top.bottom.equalToSuperview().inset(10)
        }
    }
}
