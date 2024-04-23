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
    private lazy var daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isScrollEnabled = false
        collection.allowsSelection = false
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
        
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
    
    private func setupUI() {
        self.view.backgroundColor = Colors.background
        configureNavBar()
        
        calendarCollectionView.register(WeekCalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        
        daysCollectionView.register(DaysCollectionViewCell.self, forCellWithReuseIdentifier: daysCellReuseId)
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(calendarCollectionView)
        view.addSubview(daysCollectionView)
    }
    
    private func applyConstraints() {
        //calendar collection view constraints
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(daysCollectionView.snp.bottom)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(24)
//            $0.leading.equalTo(daysCollectionView.snp.leading)
//            $0.leading.equalTo(daysCollectionView.snp.trailing)
            $0.height.equalTo(40)
        }
        
        //daysOfWeekCollection constraints
        daysCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(15)
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

extension ScheduleViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        let startDate = formatter.date(from: "01 января 2020")!
//        let endDate = formatter.date(from: "01 января 2030")!
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
        
        let currentDate = cellState.text
        
        cell.configureCell(with: currentDate)
        
        cell.changeSelectionState(isSelected: cellState.isSelected)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? WeekCalendarCollectionViewCell else {
            assertionFailure("error in displaying calendar cell")
            return
        }
        
        let currentDate = cellState.text
        cell.configureCell(with: currentDate)
        
        cell.changeSelectionState(isSelected: cellState.isSelected)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? WeekCalendarCollectionViewCell else {
            assertionFailure("error in didSelect calendar cell")
            return
        }
        
        cell.changeSelectionState(isSelected: cellState.isSelected)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if let cell = cell as? WeekCalendarCollectionViewCell {
            cell.changeSelectionState(isSelected: cellState.isSelected)
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        if let cell = cell as? WeekCalendarCollectionViewCell {
            cell.changeSelectionState(isSelected: cellState.isSelected)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let start = visibleDates.monthDates[0].date
        let end = visibleDates.monthDates[6].date
        let a = formatter.string(from: start)
        print(a)
        
        startDate = formatter.string(from: start)
        endDate = formatter.string(from: end)
        navigationItem.title = "\(startDate) - \(endDate)"
    }
}

extension ScheduleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DaysOfWeek.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = daysCollectionView.dequeueReusableCell(
            withReuseIdentifier: daysCellReuseId, for: indexPath) as? DaysCollectionViewCell
        else {
            fatalError("error when creating days of week cell")
        }
        
        let day = DaysOfWeek.allCases[indexPath.row].rawValue
        cell.configureCell(with: day)
        
        return cell
    }
}

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
