import SwiftUI

struct ScenarioPopupView: View {
    @State private var showPopup = false
    @EnvironmentObject var vibrationManager: VibrationManager
    @State private var navigateToSlider = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    if showPopup {
                        VStack(spacing: 16) {
                            Text("💬 Alerte")
                                .font(.title2)
                                .bold()

                            Button(action: {
                                showPopup = false
                                navigateToSlider = true
                            }) {
                                Text("Continuer")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color(red: 0.0, green: 0.776, blue: 1.0))
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule().stroke(Color.gray, lineWidth: 2)
                                    )
                                    .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 6)
                            }
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.85, height: 200)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                        .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                    }

                    Spacer()
                }
                .animation(.easeInOut(duration: 0.5), value: showPopup)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showPopup = true
                    vibrationManager.playNextVibration()
                }
            }
            // Navigation vers les sliders
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
    ScenarioPopupView()
}

