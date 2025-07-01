import SwiftUI
import Combine

struct UserFormView: View {
    var onFormSubmit: (User, Telephone) -> Void = { _, _ in }
    
    @EnvironmentObject var viewModel: ScenarioViewModel
    @EnvironmentObject var vibrationManager: VibrationManager

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

    @State private var phoneBrand = "iOS"
    @State private var phoneModel = "iPhone 12"
    @State private var phoneVersion = "17"
    @State private var phoneModelNumber = "A2403"

    @State private var isButtonEnabled = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Formulaire utilisateur")
                    .font(.title2).bold()
                    .padding(.bottom, 8)

                Group {
                    VStack(alignment: .leading) {
                        Text("Âge")
                        TextField("Âge", text: $age)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("Genre")
                        TextField("Genre", text: $sexe)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("Nom du superviseur")
                        TextField("Nom du superviseur", text: $password)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("Pays de résidence")
                        TextField("Pays de résidence", text: $paysResidence)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("Profession")
                        TextField("Profession", text: $profession)
                            .textFieldStyle(.roundedBorder)
                    }
                }

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

                Divider().padding(.vertical, 12)

                Text("Informations sur le téléphone personnel")
                    .font(.title3).bold()

                Group {
                    VStack(alignment: .leading) {
                        Text("Système d’exploitation du téléphone")
                        TextField("Système d’exploitation", text: $phoneBrand)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("Modèle téléphone")
                        TextField("Modèle", text: $phoneModel)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("Version logicielle")
                        TextField("Version", text: $phoneVersion)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("Numéro de modèle")
                        TextField("Numéro de modèle", text: $phoneModelNumber)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                Button(action: {
                    isButtonEnabled = false
                    submitForm()
                }) {
                    Text("Continuer")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 1/255, green: 154/255, blue: 175/255))
                        .cornerRadius(8)
                }
                .disabled(!isButtonEnabled)
                .padding(.top, 24)
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

        let phone = Telephone(
            marque: phoneBrand,
            modele: phoneModel,
            versionLogiciel: phoneVersion,
            numeroModele: phoneModelNumber
        )

        APIService.shared.createUser(user)
            .flatMap { savedUser -> AnyPublisher<Telephone, Error> in
                viewModel.user = savedUser
                return APIService.shared.createTelephone(phone)
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ Erreur : \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        isButtonEnabled = true
                    }
                }
            }, receiveValue: { savedPhone in
                viewModel.telephone = savedPhone
                viewModel.setVibrationManager(vibrationManager)
                viewModel.initializeAllTests()

                print("✅ Form POST réussi — début onFormSubmit()")
                onFormSubmit(viewModel.user!, savedPhone)
            })
            .store(in: &viewModel.cancellables)
    }
}
