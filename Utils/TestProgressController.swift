//
//  TestProgressController.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 11/06/2025.
//
//  TestProgressController.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 11/06/2025.
//
import Foundation
import SwiftUI


class TestProgressController: ObservableObject {
    static let shared = TestProgressController()
    
    @Published private(set) var completedTraining = 0
    @Published private(set) var completedReal = 0
    
    //let totalTraining = 14
    let totalTraining = 10
    let totalReal = 84

    private(set) var isTraining = true

    func reset() {
        completedTraining = 0
        completedReal = 0
        isTraining = true
    }

    func increment(isTrainingTest: Bool) {
        if isTrainingTest {
            completedTraining += 1
            if completedTraining >= totalTraining {
                isTraining = false
            }
        } else {
            completedReal += 1
        }
    }

    func remaining() -> Int {
        return isTraining ? (totalTraining - completedTraining) : (totalReal - completedReal)
    }

    func isTrainingPhase() -> Bool {
        return isTraining
    }

    func isTrainingFinished() -> Bool {
        return completedTraining >= totalTraining
    }

    func isRealFinished() -> Bool {
        return completedReal >= totalReal
    }
}


