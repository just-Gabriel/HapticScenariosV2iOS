//
//  TrainingViewModel.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 05/06/2025.
//
// TrainingViewModel.swift
// HapticScenariosV2iOS
// Gère la phase d'entraînement uniquement (14 vibrations, non enregistrées)

import Foundation
import Combine

/// Modèle de données pour un test unique (vibration + scénario)
struct TrainingVibration: Identifiable {
    let id = UUID()
    let scenario: ScenarioType         // Type du scénario (bouton, popup, etc.)
    let vibrationId: Int              // Identifiant de la vibration iOS
    let vibrationName: String        // Nom humainement lisible de la vibration
}

/// ViewModel pour gérer la phase d'entraînement
class TrainingViewModel: ObservableObject {

    // Liste des tests à jouer durant le training
    @Published var trainingTests: [TrainingVibration] = []

    // Test actuellement affiché
    @Published var currentTest: TrainingVibration? = nil

    // Indique si tous les tests ont été faits
    @Published var trainingCompleted: Bool = false

    /// Initialise les tests d'entraînement : 14 vibrations réparties sur 3 scénarios
    func initializeTraining(vibrationManager: VibrationManager) {
        let allVibrations = vibrationManager.getAllVibrations()  // [(id, name)]
        let scenarios = ScenarioType.allCases.shuffled()         // [button, popup, dragAndDrop] dans un ordre aléatoire

        // ✅ Répartir les 14 vibrations entre les 3 scénarios (par ex. 5/5/4)
        var repartition = [5, 5, 4]                                 // total = 14
        var tempVibrations = allVibrations.shuffled().prefix(14)   // 14 vibrations mélangées

        var tests: [TrainingVibration] = []
        for (index, scenario) in scenarios.enumerated() {
            for _ in 0..<repartition[index] {
                if let vibration = tempVibrations.popFirst() {
                    tests.append(TrainingVibration(
                        scenario: scenario,
                        vibrationId: vibration.id,
                        vibrationName: vibration.name
                    ))
                }
            }
        }

        trainingTests = tests.shuffled() // Shuffle final pour l'ordre d'affichage
        trainingCompleted = false
        currentTest = nil
    }

    /// Charge le prochain test de la liste (ou termine le training)
    func loadNextTrainingTest() {
        if trainingTests.isEmpty {
            trainingCompleted = true
            currentTest = nil
        } else {
            currentTest = trainingTests.removeFirst()
        }
    }
}

