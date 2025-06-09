//
//  UserFormView.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 04/06/2025.
//
import SwiftUI
import Foundation


struct UserFormView: View {
    @EnvironmentObject var viewModel: ScenarioController
    @EnvironmentObject var vibrationManager: VibrationManager

    // Champs utilisateur
    @State private var age = "25"
    @State private var sexe = "Homme"
    @State private var mainDominante = "Droite"
    @State private var password = "gab Noel"
    @State private var paysResidence = "France"
    @State private var profession = "Développeur"
    @State private var isVibrationTelActive = false
    @State private var isVibrationClavierActive = false
    @State private var isCoqueTelActive = false
    @State private var niveauInformatique: Float = 2

    // Champs téléphone
    @State private var phoneBrand = "iOS"
    @State private var phoneModel = "iPhone 12"
    @State private var phoneVersion = "17"
    @State private var phoneModelNumber = "A2403"

    @State private var isButtonEnabled = true

    var onFormSubmit: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Formulaire utilisateur")
                    .font(.title2).bold()

                Group {
                    TextField("Âge", text: $age)
                    TextField("Genre", text: $sexe)
                    TextField("Nom du superviseur", text: $password)
                    TextField("Pays de résidence", text: $paysResidence)
                    TextField("Profession", text: $profession)
                }.textFieldStyle(.roundedBorder)

                Text("Main dominante").bold()
                Picker("Main dominante", selection: $mainDominante) {
                    Text("Droite").tag("Droite")
                    Text("Gauche").tag("Gauche")
                }
                .pickerStyle(.segmented)

                Toggle("Vibration téléphone activée", isOn: $isVibrationTelActive)
                Toggle("Vibration clavier activée", isOn: $isVibrationClavierActive)
                Toggle("Coque de téléphone", isOn: $isCoqueTelActive)

                VStack(alignment: .leading) {
                    Text("Niveau informatique : \(Int(niveauInformatique))").bold()
                    Slider(value: $niveauInformatique, in: 0...5, step: 1)
                }

                Divider()

                Text("Téléphone personnel").font(.title3).bold()
                Group {
                    TextField("Système d’exploitation", text: $phoneBrand)
                    TextField("Modèle", text: $phoneModel)
                    TextField("Version logicielle", text: $phoneVersion)
                    TextField("Numéro de modèle", text: $phoneModelNumber)
                }.textFieldStyle(.roundedBorder)

                Button("Continuer") {
                    isButtonEnabled = false
                    submitForm()
                }
                .disabled(!isButtonEnabled)
                .padding(.top, 24)
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }

    private func submitForm() {
        let user = User(
            age: Int(age) ?? 0,
            sexe: sexe,
            mainDominante: mainDominante,
            password: password,
            paysResidence: paysResidence,
            profession: profession,
            vibrationTelActive: isVibrationTelActive,
            vibrationClavierActive: isVibrationClavierActive,
            coqueTel: isCoqueTelActive,
            niveauInformatique: Int(niveauInformatique)
        )

        let telephone = Telephone(
            marque: phoneBrand,
            modele: phoneModel,
            versionLogiciel: phoneVersion,
            numeroModele: phoneModelNumber
        )

        APIService.shared.createUser(user)
            .flatMap { savedUser in
                viewModel.user = savedUser
                return APIService.shared.createTelephone(telephone)
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ Échec formulaire : \(error.localizedDescription)")
                    isButtonEnabled = true
                }
            }, receiveValue: { savedPhone in
                viewModel.telephone = savedPhone
                viewModel.reset()
                viewModel.initialize(vibrationManager: vibrationManager)
                onFormSubmit()
            })
            .store(in: &viewModel.cancellables)
    }
}

