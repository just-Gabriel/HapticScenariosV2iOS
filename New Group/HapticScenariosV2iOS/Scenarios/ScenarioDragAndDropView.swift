import SwiftUI

struct ScenarioDragAndDropView: View {
    @State private var currentPosition: CGPoint = .zero
    @State private var dragOffset: CGSize = .zero
    @State private var dropZoneFrame: CGRect = .zero
    @State private var fileFrame: CGRect = .zero
    @EnvironmentObject var vibrationManager: VibrationManager

    @State private var navigateToSlider = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                GeometryReader { geo in
                    ZStack {
                        // 🎯 Zone de dépôt
                        VStack {
                            Spacer()

                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(UIColor.systemGray5))
                                .frame(width: 200, height: 200)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 2))
                                .background(
                                    GeometryReader { dropGeo in
                                        Color.clear.onAppear {
                                            dropZoneFrame = dropGeo.frame(in: .global)
                                        }
                                    }
                                )

                            Spacer()
                        }

                        // 📄 Fichier draggable
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.teal)
                            .frame(width: 100, height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
                            .position(x: currentPosition.x + dragOffset.width, y: currentPosition.y + dragOffset.height)
                            .background(
                                GeometryReader { fileGeo in
                                    Color.clear.onChange(of: dragOffset) { _, _ in
                                        fileFrame = fileGeo.frame(in: .global)
                                    }
                                }
                            )

                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { _ in
                                        if dropZoneFrame.intersects(fileFrame) {
                                            print("✅ Déposé dans la zone !")
                                            vibrationManager.playNextVibration()
                                            navigateToSlider = true
                                        } else {
                                            print("❌ Pas dans la zone, retour...")
                                            dragOffset = .zero
                                        }
                                    }
                            )
                            .onAppear {
                                initializePosition(screenSize: geo.size)
                            }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
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

    private func initializePosition(screenSize: CGSize) {
        dragOffset = .zero
        let corners = [
            CGPoint(x: 80, y: 100), // haut gauche
            CGPoint(x: screenSize.width - 80, y: 100), // haut droite
            CGPoint(x: 80, y: screenSize.height - 100), // bas gauche
            CGPoint(x: screenSize.width - 80, y: screenSize.height - 100) // bas droite
        ]
        currentPosition = corners.randomElement() ?? CGPoint(x: 80, y: 100)
    }
}

