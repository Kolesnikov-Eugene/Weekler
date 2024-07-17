//
//  Goal.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.07.2024.
//

import Foundation

struct Goal: Hashable {
    let id: UUID
    let date: Date
    let description: String
}
