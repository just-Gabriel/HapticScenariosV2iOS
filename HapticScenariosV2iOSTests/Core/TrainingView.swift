//
//  TrainingView.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 05/06/2025.
//
//
//  TrainingView.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 05/06/2025.
//

import SwiftUI

struct TrainingView: View {
    var onTrainingComplete: () -> Void

    @EnvironmentObject var vibrationManager: VibrationManager
    @EnvironmentObject var trainingViewModel: TrainingViewModel

    @State private var navigateToSlider = false

    var body: some View {
        VStack {
            // Fin de l'entraînement
            if trainingViewModel.trainingCompleted {
                Text("✅ Phase d'entraînement terminée")
                    .font(.title2)
                    .padding()

                Button("Démarrer les vrais tests") {
                    onTrainingComplete()
                }
                .buttonStyle(.borderedProminent)
                .padding()

            // Test en cours
            } else if let test = trainingViewModel.currentTest {
                VStack(spacing: 24) {
                    Text("Entraînement : \(test.vibrationName)")
                        .font(.title3)

                    // Interaction scénario : vibration + navigation vers Slider
                    test.trainingScenarioView {
                        vibrationManager.replayVibration(id: test.vibrationId)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            navigateToSlider = true
                        }
                    }

                    Button("Suivant") {
                        trainingViewModel.loadNextTrainingTest()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()

                // Navigation vers SliderView
                .navigationDestination(isPresented: $navigateToSlider) {
                    SliderView(
                        test: ScenarioVibration(
                            scenario: test.scenario,
                            vibrationId: test.vibrationId,
                            vibrationName: test.vibrationName
                        ),
                        isTraining: true,
                        onValidation: {
                            trainingViewModel.loadNextTrainingTest()
                        }
                    )
                    .environmentObject(vibrationManager)
                }


            // Chargement initial
            } else {
                ProgressView("Préparation des tests…")
                    .onAppear {
                        trainingViewModel.initializeTraining(vibrationManager: vibrationManager)
                        trainingViewModel.loadNextTrainingTest()
                    }
            }
        }
        .navigationTitle("Phase d’entraînement")
    }
}


