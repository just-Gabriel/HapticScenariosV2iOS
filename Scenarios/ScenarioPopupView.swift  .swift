import SwiftUI

struct ScenarioPopupView: View {
    let onInteraction: () -> Void

    @State private var showPopup = false
    @State private var navigateToSlider = false
    @State private var hasAppeared = false // ✅ Bloque le double appel
    @State private var hasVibrated = false // ✅ Bloque la double vibration

    @EnvironmentObject var vibrationManager: VibrationManager
    @EnvironmentObject var scenarioManager: ScenarioViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    if showPopup {
                        HStack(alignment: .center, spacing: 12) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.purple)
                                .frame(width: 20, height: 20)

                            VStack(alignment: .leading, spacing: 8) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(width: 150, height: 10)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 200, height: 10)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .frame(maxWidth: 320)
                        .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                                removal: .opacity))
                        .onAppear {
                            // ✅ Appelé UNE SEULE FOIS au moment de l’apparition du popup
                            if !hasVibrated {
                                hasVibrated = true
                                print("🔊 [POPUP] Vibration ID: \(vibrationManager.currentVibrationId)")
                                scenarioManager.playCurrentTestVibration()
                                onInteraction()
                            }
                        }
                    }

                    Spacer()
                }
                .animation(.easeInOut(duration: 0.5), value: showPopup)
            }
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true

                print("🪄 ScenarioPopupView lancé")

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showPopup = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        navigateToSlider = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToSlider) {
                SliderView(vibrationId: vibrationManager.currentVibrationId)
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        print("➡️ Navigation vers SliderView avec ID: \(vibrationManager.currentVibrationId)")
                    }
            }
        }
    }
}

#Preview {
    ScenarioPopupView(onInteraction: {})
        .environmentObject(VibrationManager())
        .environmentObject(ScenarioViewModel())
}
