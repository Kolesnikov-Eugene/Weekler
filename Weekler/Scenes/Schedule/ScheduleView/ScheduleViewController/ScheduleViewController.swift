//
//  ViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 21.03.2024.
//

import UIKit
import SnapKit
import JTAppleCalendar
import RxSwift
import RxCocoa


final class ScheduleViewController: UIViewController {
    
    //MARK: - private properties
    private var startDate = ""
    private var endDate = ""
    private let reuseId = "calendarCell"
    private let scheduleCellReuseId = "scheduleCell"
    private let collectionCellReuseId = "collectionCell"
    private var mainMode: ScheduleMode = .task
    private var tableDataSource: UITableViewDiffableDataSource<UITableView.Section, SourceItem>!
    private var calendarCollectionHeight = Constants.calendarCollectionHeight
    private var calendarCollectionViewRowsNumber = Constants.calendarCollectionViewRowsNumber
    
    private lazy var weekDaysStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var calendarCollectionView: JTAppleCalendarView = {
        let collection = JTAppleCalendarView()
        collection.backgroundColor = .clear
        collection.scrollDirection = .horizontal
        collection.scrollingMode = .stopAtEachCalendarFrame
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
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
        button.addTarget(self, action: #selector(didTapAddNewEventButton), for: .touchUpInside)
        
        return button
    }()
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    private lazy var calendarSwitchRightBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem()
        
        let image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysTemplate)
        button.image = image
        button.tintColor = .gray
        button.style = .plain
        button.target = self
        button.action = #selector(calendarSwitchRightBarButtonItemTapped)
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        return button
    }()
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
    private lazy var emptyStateImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .clock)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.clipsToBounds = true
        return view
    }()
    private var viewModel: ScheduleViewViewModelProtocol
    private var bag = DisposeBag()
    private var hapticManager: CoreHapticsManager?
    
    init(viewModel: ScheduleViewViewModelProtocol) {
        self.viewModel = viewModel
        self.hapticManager = CoreHapticsManager()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        selectCurrentDateToCalendar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        scheduleTableView.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
        //TODO: - add dinamic content inset when table view will display the lsat cell
        scheduleTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        emptyStateImageView.layer.cornerRadius = CGRectGetWidth(CGRect(origin: CGPoint.zero, size: emptyStateImageView.bounds.size)) / 2
    }
    
    //MARK: - private methods
    private func setupUI() {
        self.view.backgroundColor = Colors.viewBackground
        configureNavBar()
        
        calendarCollectionView.register(WeekCalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: scheduleCellReuseId)
        scheduleTableView.delegate = self
        setupTableViewDataSource()
        
        selectMainModeCollectionView.register(SelectMainModeCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellReuseId)
        selectMainModeCollectionView.dataSource = self
        selectMainModeCollectionView.delegate = self
        
        addSubviews()
        applyConstraints()
    }
    
    private func bind() {
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
    
    // REFACTOR
    private func setupTableViewDataSource() {
        tableDataSource = UITableViewDiffableDataSource<UITableView.Section, SourceItem>(
            tableView: scheduleTableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: self.scheduleCellReuseId) as? ScheduleTableViewCell else { fatalError() }
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
                        self?.hapticManager?.playAddTask()
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
    
    private func addSubviews() {
        for weekDay in 0...6 {
            let label = createLabel(for: weekDay)
            weekDaysStackView.addArrangedSubview(label)
        }
        let subviews = [
            emptyStateImageView,
            weekDaysStackView,
            calendarCollectionView,
            selectMainModeCollectionView,
            scheduleTableView,
            addNewEventButton
        ]
        subviews.forEach { view.addSubview($0) }
    }
    
    private func applyConstraints() {
        //weekDays stackview constraints
        weekDaysStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(25)
        }
        
        //calendar collection view constraints
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekDaysStackView.snp.bottom)
            $0.leading.equalTo(weekDaysStackView.snp.leading)
            $0.trailing.equalTo(weekDaysStackView.snp.trailing)
            $0.height.equalTo(calendarCollectionHeight)
        }
//        calendarCollectionView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
//            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
//            $0.height.equalTo(70)
//        }
        
        //selectMainModeCollection constraints
        selectMainModeCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarCollectionView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(25)
        }
        
        //scheduleTableView Constraints
        scheduleTableView.snp.makeConstraints {
            $0.top.equalTo(selectMainModeCollectionView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        //addNewEventButton constraints
        addNewEventButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
        }
        
        // FIXME: Reconfigure constraints to adapt to calendar switch
        //emptyStateImageView constraints
        emptyStateImageView.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(250)
            $0.height.equalTo(250)
        }
    }
    
    private func configureNavBar() {
        startDate = formatter.string(from: Date())
        navigationItem.rightBarButtonItem = calendarSwitchRightBarButtonItem
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = false
            navigationItem.title = "\(startDate) - \(startDate)"
            navBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: Colors.textColorMain
            ]
        }
    }
    
    private func createLabel(for weekDay: Int) -> UILabel {
        let label = UILabel()
        label.text = WeekDayShortName.allCases[weekDay].rawValue
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = Colors.textColorMain
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    @objc private func didTapAddNewEventButton() {
        hapticManager?.playTap()
        
        let createDelegate = viewModel as? CreateScheduleDelegate
        let task: ScheduleTask? = nil
        let mode: CreateMode = .create
        let createViewModel: CreateScheduleViewModelProtocol = DIContainer.shared.resolve(arguments: createDelegate, task)
        let createScheduleVC: CreateScheduleViewController = DIContainer.shared.resolve(arguments: createViewModel, mode)
        
        if let sheet = createScheduleVC.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        createScheduleVC.hidesBottomBarWhenPushed = true
        navigationController?.present(createScheduleVC, animated: true)
    }
    
    private func animateCalendartransiotion() {
        if calendarCollectionViewRowsNumber == 1 {
            self.calendarCollectionView.snp.updateConstraints {
                $0.height.equalTo(self.calendarCollectionHeight)
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
                if !self.emptyStateImageView.isHidden {
                    self.emptyStateImageView.snp.removeConstraints()
                    self.emptyStateImageView.snp.remakeConstraints {
                        $0.centerX.equalTo(self.view.snp.centerX)
                        $0.centerY.equalTo(self.view.snp.centerY)
                        $0.width.equalTo(250)
                        $0.height.equalTo(250)
                    }
                }
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.calendarCollectionView.reloadData(withanchor: self.viewModel.selectedDate)
            }
        } else {
            self.calendarCollectionView.snp.updateConstraints {
                $0.height.equalTo(self.calendarCollectionHeight)
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                if !self.emptyStateImageView.isHidden {
                    self.emptyStateImageView.snp.removeConstraints()
                    self.emptyStateImageView.snp.remakeConstraints {
                        $0.centerX.equalTo(self.view.snp.centerX)
                        $0.top.equalTo(self.selectMainModeCollectionView.snp.bottom).offset(10)
                        $0.width.equalTo(250)
                        $0.height.equalTo(250)
                    }
                }
                self.view.layoutIfNeeded()
                self.calendarCollectionView.reloadData(withanchor: self.viewModel.selectedDate)
            }
        }
    }
    
    private func selectCurrentDateToCalendar() {
        calendarCollectionView.scrollToDate(viewModel.selectedDate, animateScroll: false) {
            self.calendarCollectionView.selectDates([self.viewModel.selectedDate])
        }
    }
    
    @objc private func calendarSwitchRightBarButtonItemTapped() {
        calendarCollectionViewRowsNumber = calendarCollectionViewRowsNumber == 1 ? 5 : 1
        calendarCollectionHeight = calendarCollectionHeight == 45 ? 200 : 45
        animateCalendartransiotion()
    }
}

//MARK: - JTAppleCalendarViewDataSource
extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date(timeIntervalSince1970: 1577826000)
        let endDate = Date(timeIntervalSince1970: 4102434000)
        
        if calendarCollectionViewRowsNumber == 5 {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: calendarCollectionViewRowsNumber)
        } else {
            return ConfigurationParameters(startDate: startDate,
                                           endDate: endDate,
                                           numberOfRows: calendarCollectionViewRowsNumber,
                                           generateInDates: .forFirstMonthOnly,
                                           generateOutDates: .off,
                                           firstDayOfWeek: .monday,
                                           hasStrictBoundaries: false)
        }
    }
}

//MARK: - JTAppleCalendarViewDelegate
extension ScheduleViewController: JTAppleCalendarViewDelegate {
    func calendar(
        _ calendar: JTAppleCalendarView,
        cellForItemAt date: Date,
        cellState: CellState,
        indexPath: IndexPath
    ) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(
            withReuseIdentifier: reuseId,
            for: indexPath) as? WeekCalendarCollectionViewCell
        else {
            fatalError("error while instantiating JTApple cell")
        }
        
        let isCurrent = formatter.string(from: date) == formatter.string(from: Date())
        let day = DaysOfWeek.getShortDayOfWeek(for: cellState.day)
        let currentDate = cellState.text
        
        cell.configureCell(currentDate: currentDate, day: day, isCurrent: isCurrent)
        cell.changeSelectionState(isSelected: cellState.isSelected)
        
        return cell
    }
    
    func calendar(
        _ calendar: JTAppleCalendarView,
        willDisplay cell: JTAppleCell,
        forItemAt date: Date, cellState: CellState,
        indexPath: IndexPath
    ) -> Void {
        guard let cell = cell as? WeekCalendarCollectionViewCell else {
            fatalError("error in displaying calendar cell")
        }
        
        let isCurrent = formatter.string(from: date) == formatter.string(from: Date())
        let day = DaysOfWeek.getShortDayOfWeek(for: cellState.day)
        let currentDate = cellState.text
        
        cell.configureCell(currentDate: currentDate, day: day, isCurrent: isCurrent)
        cell.changeSelectionState(isSelected: cellState.isSelected)
    }
    
    func calendar(
        _ calendar: JTAppleCalendarView,
        didSelectDate date: Date,
        cell: JTAppleCell?,
        cellState: CellState
    ) -> Void {
        guard let cell = cell as? WeekCalendarCollectionViewCell else {
            fatalError("Error in didSelect calendar cell")
        }
        print(formatter.string(from: date))
        let selectedDate = date
        cell.changeSelectionState(isSelected: cellState.isSelected)
        viewModel.currentDateChangesObserver.accept(selectedDate)
    }
    
    func calendar(
        _ calendar: JTAppleCalendarView,
        shouldDeselectDate date: Date,
        cell: JTAppleCell?,
        cellState: CellState
    ) -> Bool {
        if let cell = cell as? WeekCalendarCollectionViewCell {
            cell.changeSelectionState(isSelected: cellState.isSelected)
        }
        return true
    }
    
    func calendar(
        _ calendar: JTAppleCalendarView,
        didDeselectDate date: Date,
        cell: JTAppleCell?,
        cellState: CellState
    ) -> Void {
        if let cell = cell as? WeekCalendarCollectionViewCell {
            cell.changeSelectionState(isSelected: cellState.isSelected)
        }
    }
    
    func calendar(
        _ calendar: JTAppleCalendarView,
        didScrollToDateSegmentWith visibleDates: DateSegmentInfo
    ) -> Void {
        let start = visibleDates.monthDates[0].date
        let end = visibleDates.monthDates[6].date
        let a = formatter.string(from: start)
        print(a)
        
        startDate = formatter.string(from: start)
        endDate = formatter.string(from: end)
        navigationItem.title = "\(startDate) - \(endDate)"
    }
}

//MARK: - scheduleTableView delegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // TODO: - Implement swipe to edit action
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
        let editAction = UIContextualAction(
            style: .normal,
            title: "") { [weak self] contextualAction, view, boolValue  in
                guard let self = self else { return }
                tableView.isEditing = false
                let task: ScheduleTask? = viewModel.task(at: indexPath.row)
                let createDelegate = viewModel as? CreateScheduleDelegate
                let mode: CreateMode = .edit
                let createViewModel: CreateScheduleViewModelProtocol = DIContainer.shared.resolve(arguments: createDelegate, task)
                let createScheduleVC: CreateScheduleViewController = DIContainer.shared.resolve(arguments: createViewModel, mode)
                navigationController?.present(createScheduleVC, animated: true)
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

//MARK: - CollectionView data source
extension ScheduleViewController: UICollectionViewDataSource {
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
extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
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
        mainMode = ScheduleMode.allCases[indexPath.row]
        viewModel.reconfigureMode(mainMode)
//        updateSnapshot(animated: false)
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

