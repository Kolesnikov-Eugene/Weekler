//
//  AppearenceView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 17.12.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class AppearanceSettingsView: UIView {
    
    private let themeCollectionViewController: ThemeCollectionViewController!
    
    override init(frame: CGRect) {
        self.themeCollectionViewController = ThemeCollectionViewController()
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = Colors.viewBackground
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        if let collectionView = themeCollectionViewController.view {
            addSubview(collectionView)
        }
    }
    
    private func applyConstraints() {
        if let collectionView = themeCollectionViewController.view {
            collectionView.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top)
                $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
                $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
        }
    }
}
