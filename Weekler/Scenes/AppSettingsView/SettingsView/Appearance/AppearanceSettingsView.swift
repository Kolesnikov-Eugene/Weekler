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
    
    // MARK: - private properties
    private let themeCollectionViewController: ThemeCollectionViewController!
    private let confirmButton: ConfirmButton!
    private let viewModel: AppearanceViewModelProtocol
    private let bag = DisposeBag()
    
    // MARK: - lifecycle
    init(
        viewModel: AppearanceViewModelProtocol,
        frame: CGRect
    ) {
        self.viewModel = viewModel
        self.themeCollectionViewController = ThemeCollectionViewController(viewModel: viewModel)
        self.confirmButton = ConfirmButton(
            text: "Apply",
            titleColor: Colors.textColorMain,
            frame: .zero
        )
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    private func setupView() {
        backgroundColor = Colors.viewBackground
        addSubviews()
        applyConstraints()
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didTapConfirmButton()
            })
            .disposed(by: bag)
        
        //        let confirmButtonTapped = UIAction { [weak self] _ in
        //            self?.viewModel.didTapConfirmButton()
        //        }
        //        confirmButton.addAction(confirmButtonTapped, for: .primaryActionTriggered)
    }
    
    private func addSubviews() {
        if let collectionView = themeCollectionViewController.view {
            addSubview(collectionView)
        }
        addSubview(confirmButton)
    }
    
    private func applyConstraints() {
        // collectionView constraints
        if let collectionView = themeCollectionViewController.view {
            collectionView.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top)
                $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
                $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
        }
        
        // confirmButton constraints
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(20)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(20)
            $0.height.equalTo(50)
        }
    }
}
