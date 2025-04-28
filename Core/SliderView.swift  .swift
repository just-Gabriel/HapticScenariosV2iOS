import SwiftUI
import Foundation

struct SliderView: View {
    let vibrationId: Int
    let vibrationName: String

    @EnvironmentObject var scenarioManager: ScenarioController

    @State private var slider1: Double = 0.5
    @State private var slider2: Double = 0.5
    @State private var slider3: Double = 0.5
    @State private var slider4: Double = 0.5
    @State private var slider5: Double = 0.5
    @State private var goToNextScenario = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // 💬 Titre
                Text("Évaluation de la vibration")
                    .foregroundColor(Color(red: 1/255, green: 154/255, blue: 175/255))
                    .font(.title)
                    .bold()
                    .padding(.top)

                Spacer().frame(height: 12)

                // 🎚️ Sliders
                Group {
                    SliderItem(leftLabel: "Lent", rightLabel: "Rapide", value: $slider1)
                    SliderItem(leftLabel: "Succès", rightLabel: "Échec", value: $slider2)
                    SliderItem(leftLabel: "Beaucoup", rightLabel: "Peu", value: $slider3)
                    SliderItem(leftLabel: "Diminution", rightLabel: "Augmentation", value: $slider4)
                    SliderItem(leftLabel: "Stressant", rightLabel: "Rassurant", value: $slider5)
                }

                Spacer().frame(height: 16)

                // ✅ Bouton
                Button(action: {
                    print("✅ Sliders validés pour vibration \(vibrationId) – \(vibrationName)")
                    print("📊 Valeurs : \(slider1), \(slider2), \(slider3), \(slider4), \(slider5)")
                    scenarioManager.goToNextScenario()
                    goToNextScenario = true
                }) {
                    Text("Suivant")
                        .font(.system(size: 20, weight: .medium))
                        .frame(minWidth: 240, minHeight: 60)
                        .background(Color(red: 1/255, green: 154/255, blue: 175/255)) // ✅ Couleur exacte 019AAF
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.top, 20)

            }
            .padding()
            .navigationDestination(isPresented: $goToNextScenario) {
                scenarioManager.getCurrentScenarioView()
                    .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                // Remise au centre
                slider1 = 0.5
                slider2 = 0.5
                slider3 = 0.5
                slider4 = 0.5
                slider5 = 0.5
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SliderItem: View {
    let leftLabel: String
    let rightLabel: String
    @Binding var value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(leftLabel)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
                Text(rightLabel)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
            Slider(value: $value)
                .accentColor(Color(red: 1/255, green: 154/255, blue: 175/255)) // ✅ Couleur turquoise

        }
        .padding(.horizontal)
    }
}
