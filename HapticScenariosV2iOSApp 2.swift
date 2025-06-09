//
//  HapticScenariosV2iOSApp.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 24/04/2025.
//

import SwiftUI

@main
struct HapticScenariosV2iOSApp: App {
    @StateObject var vibrationManager = VibrationManager()
    @StateObject var viewModel = ScenarioViewModel()
    
    enum AppStep {
        case form
        case training
        case realTest
    }
    
    @State private var currentStep: AppStep = .form
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                switch currentStep {
                case .form:
                    UserFormView {
                        currentStep = .training
                    }
                    .environmentObject(vibrationManager)
                    .environmentObject(viewModel)
                case .training:
                    TrainingView {
                        currentStep = .realTest
                    }
                    .environmentObject(vibrationManager)
                    .environmentObject(viewModel)
                    
                
                case .realTest:
                    RealTestView()
                        .environmentObject(vibrationManager)
                        .environmentObject(viewModel)

                    
                }
            }
        }
    }
}






