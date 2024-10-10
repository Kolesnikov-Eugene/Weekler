//
//  CoreHapticsManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.10.2024.
//

import Foundation
import CoreHaptics

final class CoreHapticsManager {
    let hapticEngine: CHHapticEngine
    
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
    }
}

extension CoreHapticsManager {
    func playTap() {
        do {
            let pattern = try tapPattern()
            try hapticEngine.start()
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            hapticEngine.notifyWhenPlayersFinished { _ in
                return .stopEngine
            }
        } catch {
            fatalError("unable to play tap \(error)")
        }
    }
    
    private func tapPattern() throws -> CHHapticPattern {
        let tap = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 2),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 2)
            ],
            relativeTime: 0,
            duration: 0.1
        )
        return try CHHapticPattern(events: [tap], parameters: [])
    }
}
