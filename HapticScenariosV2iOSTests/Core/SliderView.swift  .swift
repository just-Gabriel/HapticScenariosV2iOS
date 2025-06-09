//
//  SliderView.swift
//  HapticScenariosV2iOS
//

import Foundation
import SwiftUI
import Combine

struct SliderView: View {
    let test: ScenarioVibration
    let isTraining: Bool
    var onValidation: () -> Void

    @EnvironmentObject var viewModel: ScenarioViewModel
    @EnvironmentObject var vibrationManager: VibrationManager

    @State private var lentRapide = 2
    @State private var echecSucces = 2
    @State private var peuBeaucoup = 2
    @State private var diminutionAugmentation = 2
    @State private var douxTranchant = 2

    @State private var isSending = false
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack(spacing: 24) {
            Text("Évaluation de la vibration")
                .font(.title)
                .foregroundColor(Color(red: 1/255, green: 154/255, blue: 175/255))

            Text("Vibration : \(test.vibrationName)")
                .font(.headline)

            if isTraining {
                Text("(Phase d'entraînement - pas de sauvegarde)")
                    .foregroundColor(.gray)
            }

            VStack(spacing: 16) {
                ThreeStateToggle(labelLeft: "Lent", labelRight: "Rapide", value: $lentRapide)
                ThreeStateToggle(labelLeft: "Échec", labelRight: "Succès", value: $echecSucces)
                ThreeStateToggle(labelLeft: "Peu", labelRight: "Beaucoup", value: $peuBeaucoup)
                ThreeStateToggle(labelLeft: "Diminution", labelRight: "Augmentation", value: $diminutionAugmentation)
                ThreeStateToggle(labelLeft: "Doux", labelRight: "Tranchant", value: $douxTranchant)
            }

            Spacer()

            Button(action: validate) {
                if isSending {
                    ProgressView()
                } else {
                    Text("Suivant")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 1/255, green: 154/255, blue: 175/255))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .disabled(isSending)
        }
        .onAppear {
            lentRapide = 2
            echecSucces = 2
            peuBeaucoup = 2
            diminutionAugmentation = 2
            douxTranchant = 2
            isSending = false
        }
        .padding()
    }

    func validate() {
        if isTraining {
            print("✨ Test d'entraînement ignoré pour la BDD")
            onValidation()
            return
        }

        guard let user = viewModel.user,
              let phone = viewModel.telephone,
              let userId = user.id,
              let phoneId = phone.id else {
            print("❌ Erreur: user ou téléphone manquant ou id nil")
            return
        }

        isSending = true

        let experience = EmotionalExperience(
            user: "/api/users/\(userId)",
            telephone: "/api/telephones/\(phoneId)",
            slider1: lentRapide,
            slider2: echecSucces,
            slider3: peuBeaucoup,
            slider4: diminutionAugmentation,
            slider5: douxTranchant,
            scenario: test.scenario.rawValue,
            vibrationId: test.vibrationId,
            mobile: 1
        )

        APIService.shared.postEmotionalExperience(experience)
            .sink(receiveCompletion: { completion in
                isSending = false
                if case .failure(let error) = completion {
                    print("❌ Erreur POST : \(error)")
                }
            }, receiveValue: { _ in
                onValidation()
            })
            .store(in: &cancellables)
    }
}


struct ThreeStateToggle: View {
    let labelLeft: String
    let labelRight: String
    @Binding var value: Int

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                ForEach(1...3, id: \.self) { index in
                    Circle()
                        .fill(value == index ? Color(red: 1/255, green: 154/255, blue: 175/255) : .gray.opacity(0.3))
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            value = index
                        }
                }
            }
            HStack {
                Text(labelLeft).font(.caption).foregroundColor(.gray)
                Spacer()
                Text("Sans avis").font(.caption).foregroundColor(.gray)
                Spacer()
                Text(labelRight).font(.caption).foregroundColor(.gray)
            }
        }
        .padding(.horizontal)
    }
}
