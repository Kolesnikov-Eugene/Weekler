//
//  StatisticsView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.11.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class StatisticsView: UIView {
    enum StatisticsControl {
        case week
        case month
        case year
    }
    // MARK: - Output
//    var statisticsControl: Driver<StatisticsControl>
    
    private let segmentedControlTitlesArray = ["Неделя", "Месяц", "Год"]
    private lazy var statisticsIntervalSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentedControlTitlesArray)
        control.selectedSegmentIndex = 0
        control.tintColor = Colors.mainForeground
        control.selectedSegmentTintColor = Colors.mainForeground
        control.translatesAutoresizingMaskIntoConstraints = false
//        control.addTarget(self, action: #selector(didChangeControlValue), for: .valueChanged)
        return control
    }()
    private lazy var statisticsChartView = { view in
        view.backgroundColor = .systemIndigo
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }(UIView(frame: .zero))
    private let viewModel: StatisticsViewModelProtocol
    private let bag = DisposeBag()
    
    init(frame: CGRect, viewModel: StatisticsViewModelProtocol) {
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
        statisticsChartView.layer.cornerRadius = CGRectGetHeight(statisticsChartView.bounds) / 2
    }
    
    private func setupUI() {
        backgroundColor = Colors.viewBackground
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        addSubview(statisticsIntervalSegmentedControl)
        addSubview(statisticsChartView)
    }
    
    private func applyConstraints() {
        // statisticsSegmentedControlViewConstraints
        statisticsIntervalSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
            $0.centerX.equalToSuperview()
        }
        
        // statisticsChartView constraints
        statisticsChartView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
    }
    
    private func bindToViewModel() {
        statisticsIntervalSegmentedControl.rx.selectedSegmentIndex
            .bind(to: viewModel.selectedInterval)
            .disposed(by: bag)
    }
    
    @objc private func didChangeControlValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Week")
        case 1:
            print("Month")
        case 2:
            print("Year")
        default:
            break
        }
    }
}
