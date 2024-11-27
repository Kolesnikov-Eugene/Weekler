//
//  StatisticsViewModelProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 27.11.2024.
//

import Foundation
import RxCocoa

protocol StatisticsViewModelProtocol: AnyObject {
    var shouldAnimateStatistics: PublishRelay<CGFloat> { get set }
    var selectedInterval: PublishRelay<Int> { get set }
    func viewDidAppear()
    func viewWillAppear()
}
