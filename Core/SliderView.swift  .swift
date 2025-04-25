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
    @State private var slider6: Double = 0.5
    @State private var goToNextScenario = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // 💬 Titre
                Text("Évaluation de la vibration")
                    .foregroundColor(.blue)
                    .font(.title)
                    .bold()
                    .padding(.top)

                // 🧩 Identifiant vibration
                //Text("ID: \(vibrationId) – \(vibrationName)")
                  //  .font(.subheadline)
                    //.foregroundColor(.gray)

                // 📏 Espacement avant sliders
                Spacer().frame(height: 12)

                // 🎚️ Sliders
                Group {
                    SliderItem(leftLabel: "Courte", rightLabel: "Longue", value: $slider1)
                    SliderItem(leftLabel: "Succès", rightLabel: "Échec", value: $slider2)
                    SliderItem(leftLabel: "Surprenant", rightLabel: "Prévisible", value: $slider3)
                    SliderItem(leftLabel: "Naturel", rightLabel: "Artificiel", value: $slider4)
                    SliderItem(leftLabel: "Stressant", rightLabel: "Rassurant", value: $slider5)
                    
                }

                Spacer().frame(height: 16)

                // ✅ Bouton
                Button("Suivant") {
                    print("✅ Sliders validés pour vibration \(vibrationId) – \(vibrationName)")
                    print("📊 Valeurs : \(slider1), \(slider2), \(slider3), \(slider4), \(slider5), \(slider6)")
                    scenarioManager.goToNextScenario()
                    goToNextScenario = true
                }
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color(red: 0.0, green: 0.776, blue: 1.0))
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(Color.gray, lineWidth: 2)
                )
                .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 6)

                // 🔁 Navigation vers scénario suivant
                NavigationLink(
                    destination: scenarioManager.getCurrentScenarioView()
                        .navigationBarBackButtonHidden(true),
                    isActive: $goToNextScenario
                ) {
                    EmptyView()
                }
            }
            .padding()
            .onAppear {
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
        }
        .padding(.horizontal)
    }
}
