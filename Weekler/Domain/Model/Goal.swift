//
//  Goal.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.07.2024.
//

import Foundation

struct Goal: Hashable, SourceItemProtocol {
    let id: UUID
    let dates: [Date]
    let description: String
}
