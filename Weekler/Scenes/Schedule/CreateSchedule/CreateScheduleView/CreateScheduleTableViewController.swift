//
//  CreateScheduleTableViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.01.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateScheduleTableViewController: UITableViewController {

    // MARK: - private properties
    private let scheduleItemTableViewReuseId = "ScheduleItem"
    private let viewModel: CreateScheduleViewModelProtocol
    private var bag = DisposeBag()
    
    // MARK: - Lifecycle
    init(viewModel: CreateScheduleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ScheduleItemsTableViewCell.self, forCellReuseIdentifier: scheduleItemTableViewReuseId)
        
        tableView.allowsSelection = true
        tableView.backgroundColor = Colors.viewBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ScheduleItems.allCases.count
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: scheduleItemTableViewReuseId,
            for: indexPath) as? ScheduleItemsTableViewCell else {
            fatalError("Error while instanciating ScheduleItemsTableViewCell")
        }
        cell.configureCell(index: indexPath.row)
        cell.onDatePickerChangedValue = { [weak self] date in
            guard let self = self else { return }
            self.viewModel.set(date)
        }
        cell.onSwitchChangedValue = { [weak self] notification in
            guard let self = self else { return }
            self.viewModel.set(notification)
        }
        bindViewModelEditState(to: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ScheduleItemsTableViewCell,
              cell.cellType == .isRepeated else { return }
        let vc = SelectRepeatedDaysViewController(viewModel: viewModel) // FIXME: move presentation logic to coordinator
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    private func bindViewModelEditState(to cell: ScheduleItemsTableViewCell) {
        viewModel.datePickerValue
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { date in
                cell.set(date)
            })
            .disposed(by: bag)
        
        viewModel.notificationSwitchValue
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { notification in
                cell.set(notification)
            })
            .disposed(by: bag)
    }
}
