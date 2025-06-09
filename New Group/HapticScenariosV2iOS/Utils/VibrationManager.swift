//
//  VibrationManager.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

import Foundation
import UIKit

class VibrationManager: ObservableObject {
    private let vibrations: [(id: Int, name: String, action: () -> Void)] = [
        (21, "impactLight", { UIImpactFeedbackGenerator(style: .light).impactOccurred() }),
        (22, "impactMedium", { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }),
        (23, "impactHeavy", { UIImpactFeedbackGenerator(style: .heavy).impactOccurred() }),
        (24, "loopImpactLight", {
            for _ in 0..<3 {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                Thread.sleep(forTimeInterval: 0.2)
            }
        }),
        (25, "loopImpactMedium", {
            for _ in 0..<3 {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                Thread.sleep(forTimeInterval: 0.2)
            }
        }),
        (26, "loopImpactHeavy", {
            for _ in 0..<3 {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                Thread.sleep(forTimeInterval: 0.2)
            }
        }),
        (27, "notificationSuccess", {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }),
        (28, "notificationWarning", {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }),
        (29, "notificationError", {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }),
        (30, "selection", {
            UISelectionFeedbackGenerator().selectionChanged()
        }),
        (31, "sequenceImpactLightMedium", {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            Thread.sleep(forTimeInterval: 0.2)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }),
        (32, "sequenceImpactHeavyRigid", {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            Thread.sleep(forTimeInterval: 0.2)
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }),
        (33, "sequenceNotificationSuccessError", {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            Thread.sleep(forTimeInterval: 0.3)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }),
        (34, "sequenceSelectionImpactLight", {
            UISelectionFeedbackGenerator().selectionChanged()
            Thread.sleep(forTimeInterval: 0.2)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }),
    ]

    private(set) var currentIndex = 0
    private(set) var currentVibrationId: Int = 21
    private(set) var currentVibrationName: String = "impactLight"

    func playNextVibration() {
        if currentIndex >= vibrations.count {
            currentIndex = 0
        }

        let vibration = vibrations[currentIndex]
        currentVibrationId = vibration.id
        currentVibrationName = vibration.name
        vibration.action()
        currentIndex += 1
    }

    func replayCurrentVibration() {
        if currentIndex > 0 {
            vibrations[currentIndex - 1].action()
        }
    }

    func reset() {
        currentIndex = 0
    }

    func isFinished() -> Bool {
        return currentIndex >= vibrations.count
    }
}
