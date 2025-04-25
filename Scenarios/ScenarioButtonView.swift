import SwiftUI

struct ScenarioButtonView: View {
    @State private var isPressed = false
    @EnvironmentObject var vibrationManager: VibrationManager
    @State private var navigateToSlider = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Button(action: {
                    isPressed = true
                    vibrationManager.playNextVibration()
                    navigateToSlider = true
                }) {
                    Text("Press")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 220, height: 60)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0, green: 0.78, blue: 1), Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.gray, lineWidth: 2))
                        .scaleEffect(isPressed ? 1.03 : 1)
                        .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 6)
                        .animation(.easeInOut(duration: 0.15), value: isPressed)
                }

                Spacer()
            }
            .padding()
            .onChange(of: isPressed) {
                if isPressed {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        isPressed = false
                    }
                }
            }
            // 👇 Navigation vers SliderView avec la vibration actuelle
            .navigationDestination(isPresented: $navigateToSlider) {
                SliderView(
                    vibrationId: vibrationManager.currentVibrationId,
                    vibrationName: vibrationManager.currentVibrationName
                )
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    ScenarioButtonView()
}

