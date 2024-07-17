//
//  ScheduleItem.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 27.06.2024.
//

import Foundation

enum ScheduleItems: String, CaseIterable {
    case date = "Дата"
    case time = "Время"
    case notification = "Уведомление"
    case isRepeated = "Повтор"
}
