//
//  NotificationService.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 29.01.2025.
//

import Foundation
import UserNotifications

protocol LocalNotificationServiceProtocol {
    func addNotification(for task: ScheduleTask) async throws
    func changeNotification(for task: ScheduleTask) async throws
    func removeNotifications(with ids: [String])
}

final class NotificationService: LocalNotificationServiceProtocol {
    
    init() {}
    
    // MARK: - public methods
    func addNotification(for task: ScheduleTask) async throws {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        guard (settings.authorizationStatus == .authorized ||
               settings.authorizationStatus == .provisional),
              let date = task.dates.first else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "WEEKLER"
        content.body = task.description
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )
        try await center.add(request)
    }
    
    func removeNotifications(with ids: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    func changeNotification(for task: ScheduleTask) async throws {
        removeNotifications(with: [task.id.uuidString])
        try await addNotification(for: task)
    }
}
