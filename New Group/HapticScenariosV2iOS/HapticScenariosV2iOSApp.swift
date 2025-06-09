//
//  HapticScenariosV2iOSApp.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 04/06/2025.
//

import SwiftUI

@main
struct HapticScenariosV2iOSApp: App {
    @StateObject var scenarioManager = ScenarioController() // 👈 c’est maintenant un ObservableObject
    @StateObject var vibrationManager = VibrationManager()

    var body: some Scene {
        WindowGroup {
            ScenarioRootView()
                .environmentObject(scenarioManager)
                .environmentObject(vibrationManager)
        }
    }
}
