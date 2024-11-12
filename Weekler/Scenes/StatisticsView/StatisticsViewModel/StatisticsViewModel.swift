//
//  StatisticsViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.11.2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol StatisticsViewModelProtocol: AnyObject {
    var selectedInterval: PublishRelay<Int> { get set }
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: - Input
    var selectedInterval: PublishRelay<Int> = .init()
    
    private let bag = DisposeBag()
    
    init() {
        selectedInterval
            .subscribe(onNext: { [weak self] interval in
                print(interval)
        })
            .disposed(by: bag)
    }
}
