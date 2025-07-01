import Foundation
import Combine

class ScenarioViewModel: ObservableObject {
    
    private var vibrationManager: VibrationManager?
    
    @Published var currentIndex = 0
    @Published var allTests: [ScenarioVibration] = []
    
    @Published var user: User?
    @Published var telephone: Telephone?
    
    var cancellables = Set<AnyCancellable>()
    
    /// Injection du VibrationManager depuis l’extérieur
    func setVibrationManager(_ manager: VibrationManager) {
        self.vibrationManager = manager
        print("🧩 VibrationManager injecté")
    }

    /// Initialise la phase de test
    func initializeAllTests() {
        currentIndex = 0
        allTests = []

        let trainingTests = generateTrainingTests()
        let realTests = generateRealTests()

        allTests = trainingTests + realTests

        print("🧪 Tests initialisés : \(trainingTests.count) training + \(realTests.count) réels = \(allTests.count) total")
        print("🧾 Contenu complet de allTests ↓↓↓")

        for (index, test) in allTests.enumerated() {
            print("🔢[\(index)] VibrationId: \(test.vibrationId), Scenario: \(test.scenario), Training: \(test.isTraining)")
        }
    }

    /// Génère les 14 tests d'entraînement
    private func generateTrainingTests() -> [ScenarioVibration] {
        guard let vibrationIds = vibrationManager?.getAllVibrationIds().shuffled() else {
            print("❌ VibrationManager non initialisé pour training")
            return []
        }

        let scenarios = (
            Array(repeating: ScenarioType.button, count: 5) +
            Array(repeating: ScenarioType.popup, count: 4) +
            Array(repeating: ScenarioType.dragAndDrop, count: 5)
        ).shuffled()

        let result = zip(vibrationIds, scenarios).map {
            ScenarioVibration(vibrationId: $0.0, scenario: $0.1, isTraining: true)
        }

        print("✅ Training tests générés : \(result.count)")
        return result
    }

    /// Génère les 84 tests réels
    private func generateRealTests() -> [ScenarioVibration] {
        guard let vibrationIds = vibrationManager?.getAllVibrationIds() else {
            print("❌ VibrationManager non initialisé pour réels")
            return []
        }

        var tests: [ScenarioVibration] = []

        for scenario in ScenarioType.allCases {
            let list = (vibrationIds + vibrationIds).shuffled()
            tests += list.map {
                ScenarioVibration(vibrationId: $0, scenario: scenario, isTraining: false)
            }
        }

        print("✅ Real tests générés : \(tests.count)")
        return tests.shuffled()
    }

    /// Joue la vibration du test courant
    func playCurrentTestVibration() {
        guard let manager = vibrationManager else {
            print("❌ VibrationManager non disponible")
            return
        }

        guard let test = getCurrentTest() else {
            print("❌ Aucun test courant trouvé pour vibration")
            return
        }

        print("🔊 [\(currentIndex)/\(allTests.count)] Play vibration → ID: \(test.vibrationId), Scenario: \(test.scenario), Training: \(test.isTraining)")
        manager.playVibration(withId: test.vibrationId)
    }

    /// Renvoie le test actuel
    func getCurrentTest() -> ScenarioVibration? {
        guard currentIndex < allTests.count else {
            print("⚠️ currentIndex \(currentIndex) dépasse allTests.count \(allTests.count)")
            return nil
        }

        let test = allTests[currentIndex]
        /*print("📥 getCurrentTest → index: \(currentIndex), vibrationId: \(test.vibrationId), scenario: \(test.scenario), training: \(test.isTraining)")*/
        return test
    }

    /// Passe au test suivant
    func nextTest() {
        currentIndex += 1
        print("⏭️ Passage au test suivant → index: \(currentIndex)")
    }

    /// Vérifie si tous les tests sont terminés
    func isFinished() -> Bool {
        let finished = currentIndex >= allTests.count
        print("✅ isFinished ? \(finished) (\(currentIndex)/\(allTests.count))")
        return finished
    }

    /// Reset
    func reset() {
        currentIndex = 0
        print("🔄 Reset de la progression → index remis à 0")
    }

    /// Nombre de tests restants
    func getRemainingCount() -> Int {
        let remaining = allTests.count - currentIndex
        print("📊 Tests restants : \(remaining)")
        return remaining
    }

    
}
