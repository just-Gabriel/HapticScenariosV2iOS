import SwiftUI

struct ScenarioButtonView: View {
    @State private var isPressed = false
    @EnvironmentObject var vibrationManager: VibrationManager
    @State private var navigateToSlider = false
    
    var onInteraction: () -> Void

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Button(action: {
                    isPressed = true
                    vibrationManager.playNextVibration()
                    onInteraction()
                    navigateToSlider = true
                    
                }) {
                    Text("Bouton")
                        .font(.system(size: 20, weight: .medium)) // ➔ un peu plus gros (20)
                        .frame(minWidth: 240, minHeight: 60) // ➔ plus large et plus haut
                        .background(Color(red: 1/255, green: 154/255, blue: 175/255)) 
                        .foregroundColor(.white)
                        .cornerRadius(16) // ➔ Arrondi doux
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 40)


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
