//
//  ScheduleTableViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 21.01.2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ScheduleTableViewController: UITableViewController {
    
    // MARK: - private properties
    private let scheduleCellReuseId = "scheduleCell"
    private var tableDataSource: UITableViewDiffableDataSource<UITableView.Section, SourceItem>!
    private var viewModel: ScheduleMainViewModelProtocol
    private var bag = DisposeBag()

    // MARK: - lifecycle
    init(
        viewModel: ScheduleMainViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: scheduleCellReuseId)
        configureTableView()
        setupTableViewDataSource()
        
        viewModel.dataList
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.updateSnapshot(animated: true)
            })
            .disposed(by: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Table view data source
    private func setupTableViewDataSource() {
        tableDataSource = UITableViewDiffableDataSource<UITableView.Section, SourceItem>(
            tableView: tableView,
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
                    cell.configureCell(with: task, and: self.viewModel.selectedDate)
                    cell.onTaskCompleted = { [weak self] in
                        self?.viewModel.completeTask(with: task.id)
                    }
                    cell.onTaskButtonTapped = { [weak self] in
                        self?.viewModel.playAddTask()
                    }
                case .completedTask(let completedTask):
                    cell.configureCompletedTaskCell(with: completedTask, and: self.viewModel.selectedDate)
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

    // MARK: - UITableView delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(
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
