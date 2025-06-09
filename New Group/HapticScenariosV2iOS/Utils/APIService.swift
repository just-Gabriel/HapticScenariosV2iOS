//
//  APIService.swift
//  HapticScenariosV2iOS
//
//  Created by AFLOKKAT_1 USER on 04/06/2025.
//
import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = URL(string: "http://192.168.1.37:8000/api/")! // ← modifie ça si besoin

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()

    // MARK: - Create User
    func createUser(_ user: User) -> AnyPublisher<User, Error> {
        let url = baseURL.appendingPathComponent("users")
        return post(url: url, object: user)
    }

    // MARK: - Create Telephone
    func createTelephone(_ phone: Telephone) -> AnyPublisher<Telephone, Error> {
        let url = baseURL.appendingPathComponent("telephones")
        return post(url: url, object: phone)
    }

    // MARK: - Generic POST
    private func post<T: Codable>(url: URL, object: T) -> AnyPublisher<T, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try jsonEncoder.encode(object)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

