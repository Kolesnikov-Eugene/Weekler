//
//  ScheduleMainView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 28.10.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ScheduleMainView: UIView {
    
    // MARK: - private properties
    private let scheduleCellReuseId = "scheduleCell"
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var addNewEventButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        configuration.baseForegroundColor = Colors.mainForeground
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 40)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(viewModel, action: #selector(ScheduleViewModel.didTapAddNewEventButton), for: .touchUpInside)
        
        return button
    }()
    private lazy var emptyStateImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .clock)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var tableDataSource: UITableViewDiffableDataSource<UITableView.Section, SourceItem>!
    private var viewModel: ScheduleMainViewModelProtocol
    private var bag = DisposeBag()
    
    // MARK: - lifecycle
    init(
        frame: CGRect,
        viewModel: ScheduleMainViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupUI()
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scheduleTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        emptyStateImageView.layer.cornerRadius = CGRectGetWidth(CGRect(origin: CGPoint.zero, size: emptyStateImageView.bounds.size)) / 2
    }
    
    // MARK: - private methods
    private func setupUI() {
        backgroundColor = Colors.viewBackground
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: scheduleCellReuseId)
        scheduleTableView.delegate = self
        setupTableViewDataSource()
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        let views = [
            scheduleTableView,
            addNewEventButton,
            emptyStateImageView
        ]
        views.forEach { addSubview($0) }
    }
    
    private func applyConstraints() {
        //scheduleTableView Constraints
        scheduleTableView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
            $0.bottom.equalTo(snp.bottom)
        }
        
        //addNewEventButton constraints
        addNewEventButton.snp.makeConstraints {
            $0.bottom.equalTo(snp.bottom).inset(16)
            $0.trailing.equalTo(snp.trailing).inset(16)
        }
        
        //emptyStateImageView constraints
        emptyStateImageView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
            $0.width.equalTo(250)
            $0.height.equalTo(250)
        }
    }
    
    private func bindToViewModel() {
        viewModel.dataList
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.updateSnapshot(animated: true)
            })
            .disposed(by: bag)
        
        viewModel.emptyStateIsActive
            .drive(emptyStateImageView.rx.isHidden)
            .disposed(by: bag)
    }
    
    private func setupTableViewDataSource() {
        tableDataSource = UITableViewDiffableDataSource<UITableView.Section, SourceItem>(
            tableView: scheduleTableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let cell = tableView
                    .dequeueReusableCell(
                        withIdentifier: self.scheduleCellReuseId
                    ) as? ScheduleTableViewCell else {
                    fatalError()
                }
                switch itemIdentifier {
                case .goal(let goal):
                    cell.configureCell(text: goal.description)
                case .priority(let priority):
                    cell.configureCell(text: priority.description)
                case .task(let task):
                    cell.configureCell(with: task)
                    cell.onTaskCompleted = { [weak self] in
                        self?.viewModel.completeTask(with: task.id)
                    }
                    cell.onTaskButtonTapped = { [weak self] in
                        self?.viewModel.playAddTask()
                    }
                case .completedTask(let completedTask):
                    cell.configureCompletedTaskCell(with: completedTask)
                    cell.onTaskCompleted = { [weak self] in
                        self?.viewModel.unCompleteTask(with: completedTask.id)
                    }
                }
                return cell
        })
        updateSnapshot(animated: false)
    }
    
    private func updateSnapshot(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<UITableView.Section, SourceItem>()
        snapshot.deleteAllItems()
        snapshot.appendSections([.task])
        snapshot.appendItems(viewModel.data)
        tableDataSource.apply(snapshot, animatingDifferences: animated)
    }
}

//MARK: - scheduleTableView delegate
extension ScheduleMainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить") { [weak self] contextualAction, view, boolValue in
                guard let self = self else { return }
                self.viewModel.deleteTask(at: indexPath.row)
            }
        let config = UIImage.SymbolConfiguration(pointSize: 14)
        deleteAction.image = UIImage(systemName: "trash")?.applyingSymbolConfiguration(config)
        let editAction = UIContextualAction(
            style: .normal,
            title: "") { [weak self] contextualAction, view, boolValue  in
                guard let self = self else { return }
                tableView.isEditing = false
                self.viewModel.prepareCreateView(at: indexPath.row)
            }
        
        configure(editAction)
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return swipeActions
    }
    
    private func configure(_ action: UIContextualAction) {
        action.image = UIImage(systemName: "pencil")
        action.backgroundColor = .lightGray
    }
}
