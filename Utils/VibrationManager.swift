//
//  VibrationManager.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

//
//  VibrationManager.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

import Foundation
import UIKit

class VibrationManager: ObservableObject {
    
    private func delayed(_ delay: TimeInterval, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: action)
    }

    private func loopedImpact(style: UIImpactFeedbackGenerator.FeedbackStyle, count: Int, interval: TimeInterval) {
        for i in 0..<count {
            delayed(Double(i) * interval) {
                UIImpactFeedbackGenerator(style: style).impactOccurred()
            }
        }
    }

    lazy var vibrations: [(id: Int, name: String, action: () -> Void)] = [
        (21, "impactLight", {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }),
        (22, "impactMedium", {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }),
        (23, "impactHeavy", {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }),
        (24, "loopImpactLight", {
            self.loopedImpact(style: .light, count: 3, interval: 0.2)
        }),
        (25, "loopImpactMedium", {
            self.loopedImpact(style: .medium, count: 3, interval: 0.2)
        }),
        (26, "loopImpactHeavy", {
            self.loopedImpact(style: .heavy, count: 3, interval: 0.2)
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
            self.delayed(0.2) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }),
        (32, "sequenceImpactHeavyRigid", {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            self.delayed(0.2) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        }),
        (33, "sequenceNotificationSuccessError", {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.delayed(0.3) {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }),
        (34, "sequenceSelectionImpactLight", {
            UISelectionFeedbackGenerator().selectionChanged()
            self.delayed(0.2) {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }),
    ]



    private(set) var currentIndex = 0
    private(set) var currentVibrationId: Int = 21
    private(set) var currentVibrationName: String = "impactLight"

    // ✅ Méthode principale utilisée partout pour jouer une vibration précise par ID
    func playVibration(withId id: Int) {
        if let vibration = vibrations.first(where: { $0.id == id }) {
            vibration.action()
            print("🔊 Vibration jouée : \(vibration.id) – \(vibration.name) depuis \(#file) — \(#function)")
        } else {
            print("❌ Aucune vibration trouvée avec l’id \(id)")
        }
    }

    // ❌ Plus utilisée pour le moment — gardée mais commentée pour clarté
    /*
    func playNextVibration() {
        if currentIndex >= vibrations.count {
            currentIndex = 0
        }

        let vibration = vibrations[currentIndex]
        currentVibrationId = vibration.id
        vibration.action()
        currentIndex += 1
    }
    */

    // ❌ Pas utilisée non plus, mais gardée au cas où
    /*
    func replayCurrentVibration() {
        if currentIndex > 0 {
            vibrations[currentIndex - 1].action()
        }
    }
    */

    // ✅ Réinitialise l’index (utile si tu veux rejouer les tests)
    func reset() {
        currentIndex = 0
    }

    // ✅ Info sur l'état de la liste (peu utilisé mais sain)
    func isFinished() -> Bool {
        return currentIndex >= vibrations.count
    }

    // ✅ Sert à générer les IDs de tests dans ScenarioViewModel
    func getAllVibrationIds() -> [Int] {
        return vibrations.map { $0.id }
    }
}

