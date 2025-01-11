//
//  ThemeCollectionViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 17.12.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ThemeCollectionViewController: UICollectionViewController {
    
    private enum ThemeReuseIdentifiers {
        static let darkModeIdentifier = "darkModeIdentifier"
        static let themeIdentifier = "themeIdentifier"
        static let backgroundViewId = "backgroundViewId"
    }
    private var dataSource: UICollectionViewDiffableDataSource<ThemeSection, ThemeCellType>!
    private let viewModel: AppearanceViewModelProtocol
    private var bag = DisposeBag()
    
    // MARK: - Lifecycle
    init(
        viewModel: AppearanceViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: ThemeCollectionViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.register(
            ThemeCollectionViewCell.self,
            forCellWithReuseIdentifier: ThemeReuseIdentifiers.themeIdentifier
        )
        self.collectionView.register(
            DarkModeCollectionViewCell.self,
            forCellWithReuseIdentifier: ThemeReuseIdentifiers.darkModeIdentifier
        )
        if let layout = self.collectionViewLayout as? UICollectionViewCompositionalLayout {
            layout.register(RoundedBackgroundView.self, forDecorationViewOfKind: ThemeReuseIdentifiers.backgroundViewId)
        }
        configureCollectionView()
        configureDataSource()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateBackgroundColor),
            name: .colorDidChange,
            object: nil
        )
        
        viewModel.viewNeedsUpdate
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                if let cell = self?.collectionView
                    .cellForItem(at: IndexPath(row: 0, section: 0)) as? DarkModeCollectionViewCell {
                    cell.update()
                }
                self?.updateSnapshot()
            })
            .disposed(by: bag)
//        NotificationCenter.default.addObserver(forName: .colorDidChange, object: nil, queue: .main) { [weak self] notification in
//            if let color = notification.object as? UIColor {
//                self?.collectionView.backgroundColor = color
//            }
//        }
    }
    
    // MARK: - Layout
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = ThemeSection(rawValue: sectionIndex) else { return nil }
            let columnsCount = sectionKind.columnCount
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let width = columnsCount == 1 ?
            NSCollectionLayoutDimension.fractionalWidth(1.0) :
            NSCollectionLayoutDimension.fractionalWidth(1.0 / CGFloat(columnsCount))
            
            let groupHeight = columnsCount == 1 ?
            NSCollectionLayoutDimension.absolute(44) :
            NSCollectionLayoutDimension.absolute(150)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: width,
                heightDimension: groupHeight)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: columnsCount
            )
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnsCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsetsReference = .readableContent
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 20,
                leading: 10,
                bottom: 20,
                trailing: 10
            )
            
            let decorationItem = NSCollectionLayoutDecorationItem
                .background(elementKind: ThemeReuseIdentifiers.backgroundViewId)
            decorationItem.contentInsets = NSDirectionalEdgeInsets(
                top: 10,
                leading: 10,
                bottom: 10,
                trailing: 10
            )
            section.decorationItems = [decorationItem]
            return section
        }
        return layout
    }
    
    private func configureCollectionView() {
//        collectionView.backgroundColor = Colors.viewBackground
        collectionView.backgroundColor = WeeklerUIManager.shared.selectedColor
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ThemeSection, ThemeCellType>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .darkMode(let darkModeItem):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThemeReuseIdentifiers.darkModeIdentifier,
                        for: indexPath) as? DarkModeCollectionViewCell else { fatalError() }
                    cell.configure(with: darkModeItem.title)
                    
                    cell.switchControl.rx
                        .isOn
                        .skip(1)
                        .filter { $0 == true }
                        .subscribe(onNext: { [weak self] isOn in
                            guard let self = self else { return }
                            self.viewModel.enableDarkMode()
                        })
                        .disposed(by: self.bag)
                    return cell
                case .theme(let themeItem):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ThemeReuseIdentifiers.themeIdentifier,
                        for: indexPath) as? ThemeCollectionViewCell else { fatalError() }
                    cell.configure(with: themeItem.color)
                    return cell
                }
        })
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ThemeSection, ThemeCellType>()
        snapshot.appendSections([.darkMode, .theme])
        snapshot.appendItems(viewModel.darkModeItems, toSection: .darkMode)
        snapshot.appendItems(viewModel.themeItems, toSection: .theme)
        dataSource.apply(snapshot)
    }
    
    @objc
    private func updateBackgroundColor() {
        collectionView.backgroundColor = WeeklerUIManager.shared.selectedColor
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ThemeCollectionViewCell {
            viewModel.changeAppAppearence(for: cell, at: indexPath)
        }
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ThemeCollectionViewCell else { return }
        cell.deselectCell()
    }
}
