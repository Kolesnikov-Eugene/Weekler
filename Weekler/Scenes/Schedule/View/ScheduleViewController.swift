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
    private let daysCellReuseId = "daysCell"
    
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
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter
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
    
    //MARK: - private methods
    private func setupUI() {
        self.view.backgroundColor = Colors.background
        configureNavBar()
        
        calendarCollectionView.register(WeekCalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(calendarCollectionView)
    }
    
    private func applyConstraints() {
        //calendar collection view constraints
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(70)
        }
    }
    
    private func configureNavBar() {
        startDate = formatter.string(from: Date())
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = false
            navigationItem.title = "\(startDate) - \(startDate)"
            navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        }
    }
    
    @objc private func didTapBackButton() {
        print("BACK")
    }
    
    @objc private func didTapForwardButton() {
        print("FORWARD")
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
        indexPath: IndexPath) -> JTAppleCell
    {
        guard let cell = calendar.dequeueReusableJTAppleCell(
            withReuseIdentifier: reuseId,
            for: indexPath) as? WeekCalendarCollectionViewCell
        else {
            fatalError("error while instantiating JTApple cell")
        }
        
        let isCurrent = formatter.string(from: date) == formatter.string(from: Date())
        let day = DaysOfWeek.allCases[indexPath.row].rawValue
        let currentDate = cellState.text
        
        cell.configureCell(currentDate: currentDate, day: day, isCurrent: isCurrent)
        cell.changeSelectionState(isSelected: cellState.isSelected)
        
        return cell
    }
    
    func calendar(
        _ calendar: JTAppleCalendarView,
        willDisplay cell: JTAppleCell,
        forItemAt date: Date, cellState: CellState,
        indexPath: IndexPath)
    {
        guard let cell = cell as? WeekCalendarCollectionViewCell else {
            assertionFailure("error in displaying calendar cell")
            return
        }
        
        let isCurrent = formatter.string(from: date) == formatter.string(from: Date())
        let day = DaysOfWeek.allCases[indexPath.row].rawValue
        let currentDate = cellState.text
        
        cell.configureCell(currentDate: currentDate, day: day, isCurrent: isCurrent)
        cell.changeSelectionState(isSelected: cellState.isSelected)
    }
    
    func calendar(
        _ calendar: JTAppleCalendarView,
        didSelectDate date: Date,
        cell: JTAppleCell?,
        cellState: CellState)
    {
        guard let cell = cell as? WeekCalendarCollectionViewCell else {
            assertionFailure("error in didSelect calendar cell")
            return
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
        cellState: CellState)
    {
        if let cell = cell as? WeekCalendarCollectionViewCell {
            cell.changeSelectionState(isSelected: cellState.isSelected)
        }
    }
    
    func calendar(
        _ calendar: JTAppleCalendarView,
        didScrollToDateSegmentWith visibleDates: DateSegmentInfo)
    {
        let start = visibleDates.monthDates[0].date
        let end = visibleDates.monthDates[6].date
        let a = formatter.string(from: start)
        print(a)
        
        startDate = formatter.string(from: start)
        endDate = formatter.string(from: end)
        navigationItem.title = "\(startDate) - \(endDate)"
    }
}
