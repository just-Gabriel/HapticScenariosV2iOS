//
//  ScenarioVibration+UI.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 05/06/2025.
//
// ScenarioVibration+UI.swift

import SwiftUI

extension ScenarioVibration {
    /// Affiche la vue liée au scénario, avec un callback sur interaction utilisateur
    func trainingScenarioView(onInteraction: @escaping () -> Void) -> some View {
        switch scenario {
        case .button:
            return AnyView(ScenarioButtonView())
        case .popup:
            return AnyView(ScenarioPopupView())
        case .dragAndDrop:
            return AnyView(ScenarioDragAndDropView())

        }
    }
}
extension TrainingVibration {
    /// Affiche la vue liée au scénario d'entraînement
    func trainingScenarioView(onInteraction: @escaping () -> Void) -> some View {
        switch scenario {
        case .button:
            return AnyView(ScenarioButtonView())
        case .popup:
            return AnyView(ScenarioPopupView())
        case .dragAndDrop:
            return AnyView(ScenarioDragAndDropView())
        }
    }
}


