//
//  DataModels.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 04/06/2025.
//
import Foundation

// MARK: - User

struct User: Codable, Identifiable {
    var id: Int? = nil
    var age: Int
    var sexe: String
    var mainDominante: String
    var password: String?
    var paysResidence: String
    var profession: String
    var vibrationTelActive: Bool
    var vibrationClavierActive: Bool
    var coqueTel: Bool
    var niveauInformatique: Int
}

// MARK: - Telephone

struct Telephone: Codable, Identifiable {
    var id: Int? = nil
    var marque: String
    var modele: String
    var versionLogiciel: String
    var numeroModele: String
}

struct EmotionalExperience: Codable {
    let user: String
    let telephone: String
    let slider1: Int
    let slider2: Int
    let slider3: Int
    let slider4: Int
    let slider5: Int
    let scenario: String
    let vibrationId: Int
    let mobile: Int
}

