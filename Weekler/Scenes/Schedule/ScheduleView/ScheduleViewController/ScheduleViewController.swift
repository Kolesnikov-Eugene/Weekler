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
    private let collectionCellReuseId = "collectionCell"
    private var mainMode: ScheduleMode = .task
    private var calendarCollectionHeight = Constants.weekModeCalendarHeight
    private var calendarCollectionViewRowsNumber = Constants.weekModeCalendarRowNumber
    
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
    private let scheduleMainView: ScheduleMainView
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
    private var viewModel: ScheduleViewViewModelProtocol
    private var bag = DisposeBag()
    private var hapticManager: CoreHapticsManager?
    
    init(viewModel: ScheduleViewViewModelProtocol) {
        self.viewModel = viewModel
        self.hapticManager = CoreHapticsManager()
        scheduleMainView = ScheduleMainView(frame: .zero, viewModel: viewModel, hapticManager: hapticManager)
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
    }
    
    //MARK: - private methods
    private func setupUI() {
        self.view.backgroundColor = Colors.viewBackground
        configureNavBar()
        
        calendarCollectionView.register(WeekCalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        
        selectMainModeCollectionView.register(SelectMainModeCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellReuseId)
        selectMainModeCollectionView.dataSource = self
        selectMainModeCollectionView.delegate = self
        
        addSubviews()
        applyConstraints()
    }
    
    private func bind() {
        viewModel.setCreateViewNeedsToBePresented
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { [weak self] _ in
                self?.hapticManager?.playTap()
                self?.presentCreateView(with: .create)
            })
            .disposed(by: bag)
        
        viewModel.presentCreateViewEditingAtIndex
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { [weak self] index in
                guard let self = self,
                      let index = index else { return }
                self.presentCreateView(with: .edit, and: index)
            })
            .disposed(by: bag)
    }
    
    private func addSubviews() {
        for weekDay in 0...6 {
            let label = createLabel(for: weekDay)
            weekDaysStackView.addArrangedSubview(label)
        }
        let subviews = [
            weekDaysStackView,
            calendarCollectionView,
            selectMainModeCollectionView,
            scheduleMainView
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
        
        // scheduleMainView constraints
        scheduleMainView.snp.makeConstraints {
            $0.top.equalTo(selectMainModeCollectionView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
    
    private func presentCreateView(with mode: CreateMode, and index: Int? = nil) {
        let createScheduleVC = makeCreateView(at: index, for: mode)
        
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
        if calendarCollectionViewRowsNumber == Constants.weekModeCalendarRowNumber {
            self.calendarCollectionView.snp.updateConstraints {
                $0.height.equalTo(self.calendarCollectionHeight)
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.calendarCollectionView.reloadData(withanchor: self.viewModel.selectedDate)
            }
        } else {
            self.calendarCollectionView.snp.updateConstraints {
                $0.height.equalTo(self.calendarCollectionHeight)
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
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
    
    // TODO: Create Coordinator
    private func makeCreateView(at index: Int? = nil, for mode: CreateMode) -> CreateScheduleViewController {
        var task: ScheduleTask? = nil
        if let index = index {
            task = viewModel.task(at: index)
            
        }
        let createDelegate = viewModel as? CreateScheduleDelegate
        let createViewModel: CreateScheduleViewModelProtocol = DIContainer.shared.resolve(arguments: createDelegate, task)
        let createScheduleVC: CreateScheduleViewController = DIContainer.shared.resolve(arguments: createViewModel, mode)
        return createScheduleVC
    }
    
    @objc private func calendarSwitchRightBarButtonItemTapped() {
        calendarCollectionViewRowsNumber = calendarCollectionViewRowsNumber == Constants.weekModeCalendarRowNumber ?
        Constants.monthModeCalendarRowNumber : Constants.weekModeCalendarRowNumber
        
        calendarCollectionHeight = calendarCollectionHeight == Constants.weekModeCalendarHeight ?
        Constants.monthModeCalendarHeight : Constants.weekModeCalendarHeight
        
        animateCalendartransiotion()
    }
}

//MARK: - JTAppleCalendarViewDataSource
extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = Date(timeIntervalSince1970: 1577826000)
        let endDate = Date(timeIntervalSince1970: 4102434000)
        
        if calendarCollectionViewRowsNumber == Constants.monthModeCalendarRowNumber {
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
    
    // TODO: change interval dispay to current month
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
