//
//  RealTestView.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 05/06/2025.
//
import SwiftUI

struct RealTestView: View {
    @EnvironmentObject var viewModel: ScenarioViewModel
    @EnvironmentObject var vibrationManager: VibrationManager

    @State private var currentTest: ScenarioVibration? = nil
    @State private var navigateToSlider = false
    @State private var testFinished = false

    var body: some View {
        VStack {
            if let test = currentTest {
                test.scenarioView {
                    vibrationManager.replayVibration(id: test.vibrationId)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        navigateToSlider = true
                    }
                }
            } else if testFinished {
                TestTermineView()
            } else {
                Text("Chargement du test...")
                    .onAppear {
                        loadNextTest()
                    }
            }
        }
        .navigationDestination(isPresented: $navigateToSlider) {
            if let test = currentTest {
                SliderView(
                    test: test,
                    isTraining: false,
                    onValidation: {
                        loadNextTest()
                    }
                )
                .environmentObject(viewModel)
            }
        }
    }

    private func loadNextTest() {
        if let next = viewModel.popNextTest() {
            currentTest = next
            navigateToSlider = false
        } else {
            testFinished = true
        }
    }
}

