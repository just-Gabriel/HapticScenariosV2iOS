//
//  TestTermineView.swift  .swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

//
//  TestTermineView.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

import SwiftUI

struct TestTermineView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("🎉 Test terminé !")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 1/255, green: 154/255, blue: 175/255))
                .multilineTextAlignment(.center)
            
            Text("Merci pour votre participation.Vos réponses ont bien été enregistrées.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

