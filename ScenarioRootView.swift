//
//  ScenarioRootView.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

import Foundation
import SwiftUI

struct ScenarioRootView: View {
    @EnvironmentObject var scenarioManager: ScenarioController

    var body: some View {
        NavigationStack {
            scenarioManager.getCurrentScenarioView()
        }
    }
}
