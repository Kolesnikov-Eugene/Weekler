//
//  SelectTaskModeView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 29.10.2024.
//

import UIKit
import SnapKit

final class SelectTaskModeView: UIView {
    private let collectionCellReuseId = "collectionCell"
    private lazy var selectMainModeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = true
        collection.allowsMultipleSelection = false
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    private var viewModel: ScheduleViewViewModelProtocol
    
    init(frame: CGRect, viewModel: ScheduleViewViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Colors.viewBackground
        selectMainModeCollectionView.register(SelectMainModeCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellReuseId)
        selectMainModeCollectionView.dataSource = self
        selectMainModeCollectionView.delegate = self
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        addSubview(selectMainModeCollectionView)
    }
    
    private func applyConstraints() {
        //selectMainModeCollection constraints
        selectMainModeCollectionView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
            $0.height.equalTo(25)
        }
    }
}

//MARK: - CollectionView data source
extension SelectTaskModeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ScheduleMode.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: collectionCellReuseId,
            for: indexPath) as? SelectMainModeCollectionViewCell else {
            fatalError("Error while instanciating selectedMainStateCell")
        }
        
        if indexPath.row == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        let mode = ScheduleMode.allCases[indexPath.row].rawValue
        cell.configureCell(mode)
        
        return cell
    }
}

//MARK: - CollectionView delegate
extension SelectTaskModeView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let item = ScheduleMode.allCases[indexPath.row].rawValue
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)
        ])
        return itemSize
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) -> Void {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectMainModeCollectionViewCell {
            cell.reconfigureState()
        }
        let mainMode = ScheduleMode.allCases[indexPath.row]
        viewModel.reconfigureMode(mainMode)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) -> Void {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectMainModeCollectionViewCell {
            cell.reconfigureState()
        }
    }
}
