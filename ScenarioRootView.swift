//
//  ScenarioRootView.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

import Foundation
import SwiftUI

struct ScenarioRootView: View {
    @EnvironmentObject var scenarioManager: ScenarioViewModel
    @EnvironmentObject var vibrationManager: VibrationManager

    @State private var isReady = false

    var body: some View {
        NavigationStack {
            if !isReady {
                UserFormView(onFormSubmit: { user, phone in
                    print("🚀 Formulaire terminé, ready à true")
                    scenarioManager.user = user
                    scenarioManager.telephone = phone
                    withAnimation {
                        isReady = true
                    }
                })
            } else if let current = scenarioManager.getCurrentTest() {
                current.scenarioView {
                    //scenarioManager.nextTest()
                }
            } else {
                Text("🎉 Tests terminés, merci !")
            }
        }
    }
}


