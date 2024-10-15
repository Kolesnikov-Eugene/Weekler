//
//  CoreHapticsManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.10.2024.
//

import Foundation
import CoreHaptics

final class CoreHapticsManager {
    private let hapticEngine: CHHapticEngine
    
    init?() {
        let hapticsCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticsCapability.supportsHaptics else {
            return nil
        }
        
        do {
            hapticEngine = try CHHapticEngine()
        } catch {
            print("Haptics engine creation error \(error)")
            return nil
        }
        
        do {
            try hapticEngine.start()
        } catch {
            print(error.localizedDescription)
        }
        hapticEngine.isAutoShutdownEnabled = true
    }
}

extension CoreHapticsManager {
    func playTap() {
        do {
            let pattern = try tapPattern()
            try playHapticFromPattern(pattern)
//            hapticEngine.notifyWhenPlayersFinished { _ in
//                return .stopEngine
//            }
        } catch {
            fatalError("unable to play tap \(error)")
        }
    }
    
    func playAddTask() {
        do {
            let pattern = try completeTaskPatern()
            try playHapticFromPattern(pattern)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func tapPattern() throws -> CHHapticPattern {
        let tap = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            ],
            relativeTime: 0,
            duration: 0.1
        )
        return try CHHapticPattern(events: [tap], parameters: [])
    }
    
    private func completeTaskPatern() throws -> CHHapticPattern {
        let tapEvent = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            ],
            relativeTime: 0,
            duration: 0.1
        )
        let addEvent = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
            ],
            relativeTime: 0.4,
            duration: 0.2
        )
        return try CHHapticPattern(events: [tapEvent, addEvent], parameters: [])
    }
    
    private func playHapticFromPattern(_ pattern: CHHapticPattern) throws {
        try hapticEngine.start()
        let player = try hapticEngine.makePlayer(with: pattern)
        try player.start(atTime: CHHapticTimeImmediate)
    }
}
