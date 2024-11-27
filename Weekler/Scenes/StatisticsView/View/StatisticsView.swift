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
    
    // MARK: private properties
    private let segmentedControlTitlesArray = ["Неделя", "Месяц", "Год"]
    private lazy var statisticsIntervalSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentedControlTitlesArray)
        control.selectedSegmentIndex = 0
        control.tintColor = Colors.mainForeground
        control.selectedSegmentTintColor = Colors.mainForeground
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    private var chartView = ChartView(frame: .zero)
    private let viewModel: StatisticsViewModelProtocol
    private let bag = DisposeBag()
    
    init(
        frame: CGRect,
        viewModel: StatisticsViewModelProtocol
    ) {
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
    }
    
    // MARK: private methods
    private func setupUI() {
        backgroundColor = Colors.viewBackground
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        addSubview(statisticsIntervalSegmentedControl)
        addSubview(chartView)
    }
    
    private func applyConstraints() {
        // statisticsSegmentedControlViewConstraints
        statisticsIntervalSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
            $0.centerX.equalToSuperview()
        }
        
        // chartView constraints
        chartView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(250)
            $0.height.equalTo(250)
        }
    }
    
    private func bindToViewModel() {
        statisticsIntervalSegmentedControl.rx.selectedSegmentIndex
            .bind(to: viewModel.selectedInterval)
            .disposed(by: bag)
        
        viewModel.shouldAnimateStatistics
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] progress in
                self?.chartView.progress = progress
            })
            .disposed(by: bag)
    }
}
