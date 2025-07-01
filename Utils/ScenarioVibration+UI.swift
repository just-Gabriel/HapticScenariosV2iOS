//
//  ScenarioVibration+UI.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 09/06/2025.
//

import SwiftUI

// MARK: - Extension de ScenarioVibration pour lier les données à l'affichage
extension ScenarioVibration {
    /// Génère dynamiquement la bonne vue utilisateur en fonction du type de scénario.
    ///
    /// - Parameter onInteraction: Closure appelée quand l’utilisateur interagit (clic, drag, etc.)
    /// - Returns: Une vue SwiftUI correspondant au scénario (bouton, popup ou drag&drop)
    ///
    /// 📌 Ce mécanisme permet d’écrire simplement :
    ///     `test.scenarioView { ... }`
    ///     sans avoir à faire de `switch` ailleurs dans l’app.
    func scenarioView(onInteraction: @escaping () -> Void) -> some View {
        switch scenario {
        case .button:
            return AnyView(
                ScenarioButtonView(
                    onInteraction: onInteraction
                )
            )

        case .popup:
            return AnyView(
                ScenarioPopupView(
                    onInteraction: onInteraction
                )
            )

        case .dragAndDrop:
            return AnyView(
                ScenarioDragAndDropView(
                    onInteraction: onInteraction
                )
            )
        }
    }
}
