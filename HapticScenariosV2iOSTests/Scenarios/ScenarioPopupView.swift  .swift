import SwiftUI

struct ScenarioPopupView: View {
    @State private var showPopup = false
    @EnvironmentObject var vibrationManager: VibrationManager
    @State private var navigateToSlider = false
    
    var onInteraction: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    if showPopup {
                        VStack {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showPopup = true
                    vibrationManager.playNextVibration()
                    onInteraction()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        navigateToSlider = true
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
    ScenarioPopupView()
}

