import SwiftUI

struct ScenarioDragAndDropView: View {
    var onInteraction: () -> Void

    @State private var currentPosition: CGPoint = .zero
    @State private var dragOffset: CGSize = .zero
    @State private var navigateToSlider = false
    @State private var hasDropped = false // ✅ sécurité contre double validation

    @EnvironmentObject var vibrationManager: VibrationManager
    @EnvironmentObject var scenarioManager: ScenarioViewModel

    let dropZoneSize: CGFloat = 200

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let screenCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)

                ZStack {
                    Color(.systemBackground).ignoresSafeArea()

                    // 🎯 Zone de dépôt
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(UIColor.systemGray5))
                        .frame(width: dropZoneSize, height: dropZoneSize)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 2))
                        .position(screenCenter)

                    // 📄 Fichier draggable
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.teal)
                        .frame(width: 100, height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
                        .position(x: currentPosition.x + dragOffset.width,
                                  y: currentPosition.y + dragOffset.height)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { _ in
                                    guard !hasDropped else { return } // ✅ blocage logique
                                    
                                    let fileCenter = CGPoint(
                                        x: currentPosition.x + dragOffset.width,
                                        y: currentPosition.y + dragOffset.height
                                    )

                                    if isInsideDropZone(center: fileCenter, dropCenter: screenCenter) {
                                        print("✅ Déposé dans la zone centrale !")
                                        hasDropped = true // ✅ ne peut être validé qu'une fois
                                        onInteraction()
                                        scenarioManager.playCurrentTestVibration()

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            navigateToSlider = true
                                        }
                                    } else {
                                        print("❌ Hors zone, reset position")
                                        dragOffset = .zero
                                    }
                                }
                        )
                        .onAppear {
                            initializePosition(screenSize: geo.size)
                        }
                }
            }
            .navigationDestination(isPresented: $navigateToSlider) {
                SliderView(vibrationId: vibrationManager.currentVibrationId)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }

    /// 🧠 Vérifie si le point est dans un carré centré
    private func isInsideDropZone(center: CGPoint, dropCenter: CGPoint) -> Bool {
        let half = dropZoneSize / 2
        let rect = CGRect(x: dropCenter.x - half, y: dropCenter.y - half,
                          width: dropZoneSize, height: dropZoneSize)
        return rect.contains(center)
    }

    /// 🎯 Positionne le carré bleu dans un coin
    private func initializePosition(screenSize: CGSize) {
        dragOffset = .zero
        let corners = [
            CGPoint(x: 80, y: 100),
            CGPoint(x: screenSize.width - 80, y: 100),
            CGPoint(x: 80, y: screenSize.height - 100),
            CGPoint(x: screenSize.width - 80, y: screenSize.height - 100)
        ]
        currentPosition = corners.randomElement() ?? CGPoint(x: 80, y: 100)
    }
}
