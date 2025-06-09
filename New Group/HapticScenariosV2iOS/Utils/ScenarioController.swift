import Foundation
import SwiftUI

enum ScenarioType: CaseIterable {
    case button
    case popup
    case dragAndDrop
}

// ✅ Devient ObservableObject pour qu’on puisse le partager
class ScenarioController: ObservableObject {
    @Published var currentScenario: ScenarioType = .button

    func goToNextScenario() {
        currentScenario = ScenarioType.allCases.randomElement()!
    }

    func getCurrentScenarioView() -> some View {
        switch currentScenario {
        case .button:
            return AnyView(ScenarioButtonView())
        case .popup:
            return AnyView(ScenarioPopupView())
        case .dragAndDrop:
            return AnyView(ScenarioDragAndDropView())
        }
    }
}
