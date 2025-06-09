//
//  ScenarioViewModel.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 04/06/2025.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Enum définissant les types de scénarios disponibles
enum ScenarioType: String, CaseIterable {
    case button
    case popup
    case dragAndDrop
}



// MARK: - Modèle représentant un test unique (scénario + vibration)
struct ScenarioVibration: Identifiable {
    let id = UUID()
    let scenario: ScenarioType         // Type d’UI (bouton, popup, drag)
    let vibrationId: Int               // Identifiant de vibration
    let vibrationName: String          // Nom lisible de la vibration
}



// MARK: - ViewModel central de gestion des tests (hors entraînement)
class ScenarioViewModel: ObservableObject {
    
    // Données utilisateur récupérées via le formulaire
    @Published var user: User?
    @Published var telephone: Telephone?
    
    // Liste des tests à venir et compteur de progression
    @Published var remainingTests: [ScenarioVibration] = []
    @Published var completedCount: Int = 0

    // Pour gérer les abonnements Combine (ex. appels API)
    var cancellables = Set<AnyCancellable>()

    // Réinitialise complètement le ViewModel (utile en relancement)
    func reset() {
        remainingTests = []
        completedCount = 0
    }

    /// Initialise la phase de test réel avec 3 scénarios × 14 vibrations × 2 (répartis équitablement)
    func initialize(vibrationManager: VibrationManager) {
        let scenarios: [ScenarioType] = [.button, .popup, .dragAndDrop]
        let allVibrations = vibrationManager.getAllVibrations()
        guard allVibrations.count == 14 else {
            print("⚠️ Attention : \(allVibrations.count) vibrations détectées au lieu de 14.")
            return
        }
 

        var generatedTests: [ScenarioVibration] = []

        for scenario in scenarios {
            for _ in 0..<2 { // Chaque vibration est jouée deux fois par scénario
                for vibration in allVibrations {
                    let test = ScenarioVibration(
                        scenario: scenario,
                        vibrationId: vibration.id,
                        vibrationName: vibration.name
                    )
                    generatedTests.append(test)
                }
            }
        }

        // Mélange final de tous les tests avant lancement
        generatedTests.shuffle()

        self.remainingTests = generatedTests
        self.completedCount = 0
    }

    /// Renvoie le nombre de tests restants à jouer
    func getRemainingCount() -> Int {
        return remainingTests.count
    }

    /// Supprime et renvoie le prochain test à jouer
    func popNextTest() -> ScenarioVibration? {
        guard !remainingTests.isEmpty else { return nil }
        completedCount += 1
        return remainingTests.removeFirst()
    }
}

// MARK: - Extension pour afficher dynamiquement la bonne UI selon le scénario
extension ScenarioVibration {
    func scenarioView(onInteraction: @escaping () -> Void) -> some View {
        switch scenario {
        case .button:
            return AnyView(ScenarioButtonView(onInteraction: onInteraction))
        case .popup:
            return AnyView(ScenarioPopupView(onInteraction: onInteraction))
        case .dragAndDrop:
            return AnyView(ScenarioDragAndDropView(onInteraction: onInteraction))
        }
    }
}

