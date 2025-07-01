import SwiftUI

struct SliderView: View {
    let vibrationId: Int

    @EnvironmentObject var scenarioManager: ScenarioViewModel
    @EnvironmentObject var vibrationManager: VibrationManager

    @State private var slider1 = 2
    @State private var slider2 = 2
    @State private var slider3 = 2
    @State private var slider4 = 2
    @State private var slider5 = 2

    @State private var goToNextScenario = false
    @State private var isButtonEnabled = true
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Évaluation de la vibration")
                    .foregroundColor(Color(red: 1/255, green: 154/255, blue: 175/255))
                    .font(.title2).bold()
                    .padding(.top)

                Text(
                    TestProgressController.shared.isTrainingPhase() ?
                        "Tests d'entraînement restants : \(TestProgressController.shared.remaining())" :
                        "Tests restants : \(TestProgressController.shared.remaining())"
                )
                .font(.title3)
                .foregroundColor(Color(red: 1/255, green: 154/255, blue: 175/255))

                ThreeStateToggle(leftLabel: "Lent", rightLabel: "Rapide", value: $slider1)
                ThreeStateToggle(leftLabel: "Échec", rightLabel: "Succès", value: $slider2)
                ThreeStateToggle(leftLabel: "Peu", rightLabel: "Beaucoup", value: $slider3)
                ThreeStateToggle(leftLabel: "Diminution", rightLabel: "Augmentation", value: $slider4)
                ThreeStateToggle(leftLabel: "Doux", rightLabel: "Tranchant", value: $slider5)

                Spacer()

                Button(action: {
                    guard isButtonEnabled else { return }
                    isButtonEnabled = false
                    isLoading = true

                    guard let test = scenarioManager.getCurrentTest() else {
                        print("❌ Aucun test trouvé")
                        return
                    }

                    print("📊 Sliders : \(slider1), \(slider2), \(slider3), \(slider4), \(slider5)")

                    if test.isTraining {
                        print("🧪 Entraînement → pas d'envoi en base")
                        TestProgressController.shared.increment(isTrainingTest: true)
                        if scenarioManager.isFinished() {
                            print("✅ Entraînement terminé")
                            goToNextScenario = true
                        } else {
                            scenarioManager.nextTest()
                            goToNextScenario = true
                        }
                    } else {
                        guard let user = scenarioManager.user,
                              let telephone = scenarioManager.telephone else {
                            print("❌ Données manquantes pour POST")
                            return
                        }

                        let experience = EmotionalExperience(
                            user: "/api/users/\(user.id!)",
                            telephone: "/api/telephones/\(telephone.id!)",
                            slider1: slider1,
                            slider2: slider2,
                            slider3: slider3,
                            slider4: slider4,
                            slider5: slider5,
                            scenario: test.scenario.rawValue,
                            vibrationId: test.vibrationId,
                            mobile: 1
                        )

                        APIService.shared.postEmotionalExperience(experience)
                            .sink(receiveCompletion: { completion in
                                switch completion {
                                case .failure(let error):
                                    print("❌ POST failed: \(error.localizedDescription)")
                                    isButtonEnabled = true
                                    isLoading = false
                                case .finished:
                                    break
                                }
                            }, receiveValue: { _ in
                                print("✅ POST réussi")
                                TestProgressController.shared.increment(isTrainingTest: false)
                                if scenarioManager.isFinished() {
                                    print("✅ Tous les tests terminés")
                                    goToNextScenario = true
                                } else {
                                    scenarioManager.nextTest()
                                    goToNextScenario = true
                                }
                            })
                            .store(in: &scenarioManager.cancellables)
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 220, height: 56)
                    } else {
                        Text("Suivant")
                            .font(.system(size: 18, weight: .medium))
                            .frame(width: 220, height: 56)
                    }
                }
                .background(Color(red: 1/255, green: 154/255, blue: 175/255))
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(radius: 4)
                .disabled(!isButtonEnabled)
                .padding(.bottom, 32)
            }
            .padding()
            .navigationDestination(isPresented: $goToNextScenario) {
                if scenarioManager.isFinished() {
                    TestTermineView()
                } else {
                    scenarioManager.getCurrentTest()?.scenarioView {
                        // Ne rien mettre ici : le nextTest est déjà géré avant navigation
                    }
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}




// Composant ThreeStateToggle 



struct ThreeStateToggle: View {
    let leftLabel: String
    let rightLabel: String
    @Binding var value: Int

    var body: some View {
        VStack(spacing: 8) {
            // HStack fixe avec 3 cercles bien positionnés
            HStack {
                // Cercle gauche
                Circle()
                    .fill(value == 1 ? Color(red: 1/255, green: 154/255, blue: 175/255) : Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .onTapGesture {
                        value = 1
                    }

                Spacer()

                // Cercle du milieu
                Circle()
                    .fill(value == 2 ? Color(red: 1/255, green: 154/255, blue: 175/255) : Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .onTapGesture {
                        value = 2
                    }

                Spacer()

                // Cercle droite
                Circle()
                    .fill(value == 3 ? Color(red: 1/255, green: 154/255, blue: 175/255) : Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .onTapGesture {
                        value = 3
                    }
            }
            .frame(height: 40)
            .padding(.horizontal, 16)
            .background(Color(.lightGray))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            // Texte sous les cercles
            HStack {
                Text(leftLabel)
                Spacer()
                Text("Sans avis")
                Spacer()
                Text(rightLabel)
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
    }
}




