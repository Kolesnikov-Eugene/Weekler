//
//  StatisticsDataSourceProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.11.2024.
//

import Foundation
import SwiftData

protocol StatisticsDataSourceProtocol {
    func fetchTaskItems<T: PersistentModel>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>
    ) async -> [T]
}
