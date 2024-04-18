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
//    private let reuseId = "calendarCell"
    private let reuseId = "dateCell"
    
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
//    private lazy var calendarCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        
//        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collection.backgroundColor = .clear
//        collection.isScrollEnabled = true
//        collection.allowsSelection = true
//        collection.allowsMultipleSelection = false
//        collection.translatesAutoresizingMaskIntoConstraints = false
//        
//        return collection
//    }()
    private lazy var calendarCollectionView: JTAppleCalendarView = {
        let collection = JTAppleCalendarView()
        
        collection.backgroundColor = .clear
        collection.scrollDirection = .horizontal
        collection.scrollingMode = .stopAtEachCalendarFrame
        collection.showsHorizontalScrollIndicator = false
//        collection.scrollToDate(Date())
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
    
    private func setupUI() {
        self.view.backgroundColor = Colors.background
        
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = false
            navigationItem.title = "Current week"
            navBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        }
        
        calendarCollectionView.register(WeekCalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        calendarCollectionView.ibCalendarDelegate = self
        calendarCollectionView.ibCalendarDataSource = self
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
//        view.addSubview(backCalendarButton)
//        view.addSubview(forwardCalendarButton)
        view.addSubview(calendarCollectionView)
    }
    
    private func applyConstraints() {
        //back calendar button constraints
//        backCalendarButton.snp.makeConstraints {
//            $0.leading.equalToSuperview().offset(16)
//            $0.centerY.equalTo(calendarCollectionView.snp.centerY)
//            $0.width.equalTo(20)
//        }
        
        //forward calendar bitton constraints
//        forwardCalendarButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().inset(16)
//            $0.centerY.equalTo(calendarCollectionView.snp.centerY)
//            $0.width.equalTo(20)
//        }
//        
        //calendar collection view constraints
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2020 01 02")!

        let endDate = formatter.date(from: "2025 01 02")!
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       numberOfRows: 1,
                                       generateInDates: .forFirstMonthOnly,
                                       generateOutDates: .off,
                                       firstDayOfWeek: .monday,
                                       hasStrictBoundaries: false)
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 6
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = calendarCollectionView.dequeueReusableCell(
//            withReuseIdentifier: reuseId,
//            for: indexPath) as? CalendarCollectionViewCell else 
//        {
//            assertionFailure("error while creating calendar cell")
//            return UICollectionViewCell()
//        }
//        
//        cell.configureCell()
//        
//        return cell
//    }
}

extension ScheduleViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! WeekCalendarCollectionViewCell
        cell.dateLabel.text = cellState.text
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let date = formatter.string(from: cellState.date)
        
        if cellState.isSelected {
            print("true")
            cell.dateLabel.textColor = .red
        }
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! WeekCalendarCollectionViewCell
        cell.dateLabel.text = cellState.text
        
        if cellState.isSelected {
            print("true")
            cell.dateLabel.textColor = .red
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let date = formatter.string(from: cellState.date)
        if let cell = cell as? WeekCalendarCollectionViewCell {
            cell.dateLabel.textColor = .red
        }
    }
}

extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//       return CGSize(width: 35, height: 60)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
