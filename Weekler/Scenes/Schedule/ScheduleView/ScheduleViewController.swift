//
//  ViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 21.03.2024.
//

import UIKit
import SnapKit
import JTAppleCalendar


final class ScheduleViewController: UIViewController {
    //MARK: - private properties
    private var startDate = ""
    private var endDate = ""
    private let reuseId = "calendarCell"
    //    private let daysCellReuseId = "daysCell"
    private let scheduleCellReuseId = "scheduleCell"
    private let collectionCellReuseId = "collectionCell"
    
    private lazy var backCalendarButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "chevron.backward")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        return button
    }()
    private lazy var forwardCalendarButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "chevron.forward")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapForwardButton), for: .touchUpInside)
        
        return button
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
        configuration.baseForegroundColor = .orange
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        //        self.calendarCollectionView.reloadData(withanchor: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarCollectionView.scrollToDate(Date()) {
            self.calendarCollectionView.selectDates([Date()])
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        scheduleTableView.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
        //TODO: - add dinamic content inset when table view will display the lsat cell
        scheduleTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
    }
    
    //MARK: - private methods
    private func setupUI() {
        self.view.backgroundColor = Colors.background
        configureNavBar()
        
        calendarCollectionView.register(WeekCalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: scheduleCellReuseId)
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        
        selectMainModeCollectionView.register(SelectMainModeCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellReuseId)
        selectMainModeCollectionView.dataSource = self
        selectMainModeCollectionView.delegate = self
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(calendarCollectionView)
        view.addSubview(selectMainModeCollectionView)
        view.addSubview(scheduleTableView)
        view.addSubview(addNewEventButton)
    }
    
    private func applyConstraints() {
        //calendar collection view constraints
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            //            $0.leading.equalToSuperview().offset(16)
            //            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(70)
        }
        
        //selectMainModeCollection constraints
        selectMainModeCollectionView.snp.makeConstraints {
            $0.top.equalTo(calendarCollectionView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(20)
        }
        
        //scheduleTableView Constraints
        scheduleTableView.snp.makeConstraints {
            //            $0.top.equalTo(calendarCollectionView.snp.bottom)
            //            $0.leading.equalTo(calendarCollectionView.snp.leading)
            //            $0.trailing.equalTo(calendarCollectionView.snp.trailing)
            $0.top.equalTo(selectMainModeCollectionView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        //addNewEventButton constraints
        addNewEventButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            //            $0.width.equalTo(60)
            //            $0.height.equalTo(60)
        }
    }
    
    private func configureNavBar() {
        startDate = formatter.string(from: Date())
        navigationItem.rightBarButtonItem = calendarSwitchRightBarButtonItem
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = false
            navigationItem.title = "\(startDate) - \(startDate)"
            navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        }
    }
    
    @objc private func didTapAddNewEventButton() {
        let createScheduleVC: CreateScheduleViewController = DIContainer.shared.resolve()
        
        if let sheet = createScheduleVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
//        createScheduleVC.modalPresentationStyle = .pageSheet
        createScheduleVC.hidesBottomBarWhenPushed = true
        
        navigationController?.present(createScheduleVC, animated: true)
//        navigationController?.pushViewController(createScheduleVC, animated: true)
    }
    
    @objc private func didTapBackButton() {
        print("BACK")
    }
    
    @objc private func didTapForwardButton() {
        print("FORWARD")
    }
    
    @objc private func calendarSwitchRightBarButtonItemTapped() {
        print("calendar")
    }
}

//MARK: - JTAppleCalendarViewDataSource
extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date(timeIntervalSince1970: 1577826000)
        let endDate = Date(timeIntervalSince1970: 4102434000)
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 1,
                                       generateInDates: .forFirstMonthOnly,
                                       generateOutDates: .off,
                                       firstDayOfWeek: .monday,
                                       hasStrictBoundaries: false)
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
        
        cell.changeSelectionState(isSelected: cellState.isSelected)
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

//MARK: - scheduleTableView data source
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = scheduleTableView.dequeueReusableCell(
            withIdentifier: scheduleCellReuseId,
            for: indexPath) as? ScheduleTableViewCell else {
            fatalError("Error when instanciating ScheduleTableViewCell")
        }
        
        cell.configureCell()
        
        return cell
    }
}

//MARK: - scheduleTableView delegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - CollectionView data source
extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = selectMainModeCollectionView.dequeueReusableCell(
            withReuseIdentifier: collectionCellReuseId,
            for: indexPath) as? SelectMainModeCollectionViewCell else {
            fatalError("Error while instanciating selectedMainStateCell")
        }
        
        cell.configureCell()
        
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
        CGSize(width: 100, height: 20)
    }
}
