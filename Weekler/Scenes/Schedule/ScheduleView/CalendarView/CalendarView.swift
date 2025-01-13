//
//  CalendarView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 29.10.2024.
//

import UIKit
import SnapKit
import JTAppleCalendar

final class CalendarView: UIView {
    
    // MARK: - UI
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
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }()
    
    // MARK: - private properties
    private let reuseId = "calendarCell"
    private var calendarCollectionHeight = Constants.weekModeCalendarHeight
    private var calendarCollectionViewRowsNumber = Constants.weekModeCalendarRowNumber
    private let weekDaysLabelHeight = Constants.weekDaysLabelHeight
    private var viewModel: CalendarViewModelProtocol
    private var isInitialLayout = false
    
    // MARK: - lifecycle
    init(
        frame: CGRect,
        viewModel: CalendarViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("view")
        if !isInitialLayout {
            let calendarHeight = CGRectGetHeight(CGRect(origin: .zero, size: calendarCollectionView.bounds.size))
            viewModel.setCalendarViewWith(calendarHeight + weekDaysLabelHeight)
            isInitialLayout = true
        }
    }
    
    // MARK: - private properties
    private func setupUI() {
//        backgroundColor = Colors.viewBackground
        backgroundColor = .clear
        calendarCollectionView.register(WeekCalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        addSubviews()
        applyConstraints()
        selectCurrentDateToCalendar()
    }
    
    private func addSubviews() {
        for weekDay in 0...6 {
            let label = createLabel(for: weekDay)
            weekDaysStackView.addArrangedSubview(label)
        }
        addSubview(weekDaysStackView)
        addSubview(calendarCollectionView)
    }
    
    private func applyConstraints() {
        weekDaysStackView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.leading.equalTo(snp.leading)
            $0.trailing.equalTo(snp.trailing)
            $0.height.equalTo(weekDaysLabelHeight)
        }
        
        //calendar collection view constraints
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekDaysStackView.snp.bottom)
            $0.leading.equalTo(weekDaysStackView.snp.leading)
            $0.trailing.equalTo(weekDaysStackView.snp.trailing)
            $0.height.equalTo(calendarCollectionHeight)
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
    
    private func animateCalendarTransition() {
        if calendarCollectionViewRowsNumber == Constants.weekModeCalendarRowNumber {
            self.calendarCollectionView.snp.updateConstraints {
                $0.height.equalTo(self.calendarCollectionHeight)
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
                self.viewModel.setCalendarViewWith(self.calendarCollectionHeight + self.weekDaysLabelHeight)
                self.layoutIfNeeded()
            } completion: { _ in
                self.calendarCollectionView.reloadData(withanchor: self.viewModel.selectedDate)
            }
        } else {
            self.calendarCollectionView.snp.updateConstraints {
                $0.height.equalTo(self.calendarCollectionHeight)
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.viewModel.setCalendarViewWith(self.calendarCollectionHeight + self.weekDaysLabelHeight)
                self.layoutIfNeeded()
                self.calendarCollectionView.reloadData(withanchor: self.viewModel.selectedDate)
            }
        }
    }
    
    private func selectCurrentDateToCalendar() {
        calendarCollectionView.scrollToDate(viewModel.selectedDate, animateScroll: false) {
            self.calendarCollectionView.selectDates([self.viewModel.selectedDate])
        }
    }
    
    @objc
    func calendarSwitchRightBarButtonItemTapped() {
        calendarCollectionViewRowsNumber = calendarCollectionViewRowsNumber == Constants.weekModeCalendarRowNumber ?
        Constants.monthModeCalendarRowNumber : Constants.weekModeCalendarRowNumber
        
        calendarCollectionHeight = calendarCollectionHeight == Constants.weekModeCalendarHeight ?
        Constants.monthModeCalendarHeight : Constants.weekModeCalendarHeight
        
        animateCalendarTransition()
    }
}


//MARK: - JTAppleCalendarViewDataSource
extension CalendarView: JTAppleCalendarViewDataSource {
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
extension CalendarView: JTAppleCalendarViewDelegate {
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
        let currentDate = cellState.text
        
        cell.configureCell(currentDate: currentDate, isCurrent: isCurrent)
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
        let currentDate = cellState.text
        
        cell.configureCell(currentDate: currentDate, isCurrent: isCurrent)
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
        //TODO: create method
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
    
    // TODO: figure out hpw to display dates in nav
    func calendar(
        _ calendar: JTAppleCalendarView,
        didScrollToDateSegmentWith visibleDates: DateSegmentInfo
    ) -> Void {
        let dates: [Date] = visibleDates.monthDates.map { $0.date }
        viewModel.updateNavTitle(with: dates)
    }
}
