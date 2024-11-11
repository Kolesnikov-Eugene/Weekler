//
//  CoreHapticsManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.10.2024.
//

import Foundation
import CoreHaptics

protocol CoreHapticsManagerProtocol {
    func playTap()
    func playAddTask()
}

final class CoreHapticsManager {
    private let hapticEngine: CHHapticEngine
    private var doneAudio: CHHapticAudioResourceID?
    
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
        setUpResources()
        hapticEngine.resetHandler = { [weak self] in
            self?.handleEngineReset()
        }
    }
    
    private func setUpResources() {
        do {
            if let path = Bundle.main.url(forResource: "Done", withExtension: "caf") {
                doneAudio = try hapticEngine.registerAudioResource(path)
            }
        } catch {
            print("error \(error.localizedDescription)")
        }
    }
}

extension CoreHapticsManager: CoreHapticsManagerProtocol {
    func handleEngineReset() {
        do {
            try hapticEngine.start()
            setUpResources()
        } catch {
            print("Failed to restart the engine: \(error)")
        }
    }
    
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
        var events = [tapEvent, addEvent]
        if let audioResourceId = doneAudio {
            let audio = CHHapticEvent(
                audioResourceID: audioResourceId,
                parameters: [],
                relativeTime: 0
            )
            events.append(audio)
        }
        return try CHHapticPattern(events: events, parameters: [])
    }
    
    private func playHapticFromPattern(_ pattern: CHHapticPattern) throws {
        try hapticEngine.start()
        let player = try hapticEngine.makePlayer(with: pattern)
        try player.start(atTime: CHHapticTimeImmediate)
    }
}
