//
//  AppSettingsCollectionViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.12.2024.
//

import UIKit

private let reuseIdentifier = "Cell"

final class AppSettingsCollectionViewController: UICollectionViewController {
    private let viewModel: AppSettingsViewModelProtocol
    private var dataSource: UICollectionViewDiffableDataSource<SettingsSection, AppSettingsItem>!
    
    init(
        viewModel: AppSettingsViewModelProtocol
    ) {
        self.viewModel = viewModel
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(AppSettingsCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configureCollectionView()
        configureDataSource()
    }
    
    private func configureCollectionView() {
        // Uncomment the following line to preserve selection between presentations
//        self.clearsSelectionOnViewWillAppear = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: reuseIdentifier,
                        for: indexPath
                    ) as? AppSettingsCollectionCell else { fatalError("Could not dequeue cell") }
                let configuration = self.viewModel.makeCellConfiguration(for: indexPath)
                switch itemIdentifier {
                case .main(let mainItem):
                    let title = mainItem.title
                    cell.configureCell(with: title, and: configuration)
                case .appearance(let appearanceItem):
                    let title = appearanceItem.title
                    cell.configureCell(with: title, and: configuration)
                }
                return cell
        })
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SettingsSection, AppSettingsItem>()
        snapshot.appendSections([.main, .appearance])
        for item in viewModel.settingsItems {
            switch item {
            case .main(_):
                snapshot.appendItems([item], toSection: .main)
            case .appearance(_):
                snapshot.appendItems([item], toSection: .appearance)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // collectionView delegate
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) -> Void {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AppSettingsCollectionCell else { return }
        cell.animateCellSelection()
    }
}
