//
//  HapticScenariosV2iOSApp.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

import SwiftUI

@main
struct HapticScenariosV2iOSApp: App {
    @StateObject var scenarioManager = ScenarioViewModel()
    @StateObject var vibrationManager = VibrationManager()

    var body: some Scene {
        WindowGroup {
            ScenarioRootView()
                .environmentObject(scenarioManager)
                .environmentObject(vibrationManager)
        }
    }
}




