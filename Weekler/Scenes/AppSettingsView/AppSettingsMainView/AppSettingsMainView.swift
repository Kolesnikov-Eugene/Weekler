//
//  AppSettingsMainView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.12.2024.
//

import UIKit
import SnapKit

final class AppSettingsMainView: UIView {
    private var profileView: ProfileView!
    private var appSettingsCollectionVC: AppSettingsCollectionViewController!

    init(
        viewModel: AppSettingsViewModelProtocol,
        frame: CGRect
    ) {
        profileView = ProfileView(frame: .zero)
        appSettingsCollectionVC = AppSettingsCollectionViewController(viewModel: viewModel)
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(profileView)
        addSubview(appSettingsCollectionVC.collectionView)
    }
    
    private func setupConstraints() {
        // profile constraints
        profileView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        // settings collection view constraints
        appSettingsCollectionVC.collectionView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.top.equalTo(profileView.snp.bottom)
        }
    }
}
