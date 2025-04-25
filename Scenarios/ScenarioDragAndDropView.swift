import SwiftUI

struct ScenarioDragAndDropView: View {
    @State private var offset = CGSize.zero
    @State private var dropZoneFrame: CGRect = .zero
    @State private var iconFrame: CGRect = .zero
    @EnvironmentObject var vibrationManager: VibrationManager

    @State private var navigateToSlider = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                GeometryReader { geo in
                    ZStack {
                        VStack {
                            Spacer()

                            // 🎯 Zone de dépôt bien centrée
                            VStack {
                                Image(systemName: "icloud.and.arrow.up")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(.gray)
                                Text("Déposez ici")
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 200, height: 200)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 2))
                            .background(
                                GeometryReader { geoDrop in
                                    Color.clear.onAppear {
                                        dropZoneFrame = geoDrop.frame(in: .global)
                                        print("📦 Drop zone frame: \(dropZoneFrame)")
                                    }
                                }
                            )

                            Spacer()
                        }

                        // 📄 Fichier draggable en haut à gauche (au-dessus)
                        VStack {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.teal)
                                        .frame(width: 100, height: 100)
                                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 2))
                                        .shadow(radius: 4)

                                    Image(systemName: "doc.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                }
                                .offset(offset)
                                .background(
                                    GeometryReader { geoIcon in
                                        Color.clear.onAppear {
                                            iconFrame = geoIcon.frame(in: .global)
                                            print("📄 Initial icon frame: \(iconFrame)")
                                        }
                                    }
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            offset = value.translation
                                            let iconCenter = CGPoint(
                                                x: iconFrame.midX + value.translation.width,
                                                y: iconFrame.midY + value.translation.height
                                            )
                                            print("🟡 Dragging - Icon center: \(iconCenter)")
                                        }
                                        .onEnded { value in
                                            let iconCenter = CGPoint(
                                                x: iconFrame.midX + value.translation.width,
                                                y: iconFrame.midY + value.translation.height
                                            )

                                            print("🔵 Drag ended - Final icon center: \(iconCenter)")
                                            print("📦 Drop zone frame: \(dropZoneFrame)")

                                            if dropZoneFrame.contains(iconCenter) {
                                                print("✅ Drop is inside the zone!")
                                                vibrationManager.playNextVibration()
                                                navigateToSlider = true
                                            } else {
                                                print("❌ Drop missed! Resetting position.")
                                                offset = .zero
                                            }
                                        }
                                )

                                Spacer()
                            }
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.leading, 20)
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
}
