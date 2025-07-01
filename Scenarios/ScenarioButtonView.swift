import SwiftUI

struct ScenarioButtonView: View {
    let onInteraction: () -> Void

    @State private var hasBeenClicked = false
    @State private var navigateToSlider = false

    @EnvironmentObject var vibrationManager: VibrationManager
    @EnvironmentObject var scenarioManager: ScenarioViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Button(action: {
                    // 🛑 Double-sécurité logicielle
                    guard !hasBeenClicked else {
                        print("⛔ Clic ignoré")
                        return
                    }

                    hasBeenClicked = true // 🔐 Lock logique

                    // ✅ Appelle l'action métier
                    onInteraction()

                    // 🔊 Vibration
                    scenarioManager.playCurrentTestVibration()

                    // ⏱️ Délai avant navigation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        navigateToSlider = true
                    }

                }) {
                    Text("Bouton")
                        .font(.system(size: 20, weight: .medium))
                        .frame(minWidth: 240, minHeight: 60)
                        .background(Color(red: 1/255, green: 154/255, blue: 175/255))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 40)
                .disabled(hasBeenClicked)

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToSlider) {
                SliderView(vibrationId: vibrationManager.currentVibrationId)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    ScenarioButtonView(onInteraction: {})
        .environmentObject(VibrationManager())
        .environmentObject(ScenarioViewModel())
}
