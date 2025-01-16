//
//  Transformer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 16.01.2025.
//

import Foundation
import SwiftData

@objc(ArrayStringTransformer)
class ArrayStringTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else { return nil }
        return try? JSONEncoder().encode(array)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? JSONDecoder().decode([String].self, from: data)
    }
}
