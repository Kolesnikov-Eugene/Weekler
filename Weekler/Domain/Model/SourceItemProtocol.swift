//
//  SourceItemProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.08.2024.
//

import Foundation

protocol SourceItemProtocol {
    var id: UUID { get }
    var dates: [Date] { get }
}
