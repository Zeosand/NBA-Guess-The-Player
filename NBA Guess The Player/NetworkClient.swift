//
//  NetworkClient.swift
//  NBA Guess The Player
//
//  Created by Student on 5/5/26.
//


import SwiftUI

@Observable
class NetworkClient {
    private let apiKey = "fe6fb9fc-d74a-4f5e-bc89-be6ef9997ab6"

    private(set) var currentPlayer: Player?
    private(set) var errorMessage: String?

    func fetchRandomPlayer() async {
        let urlStr = "https://api.balldontlie.io/v1/players?per_page=100"
        guard let url = URL(string: urlStr) else { return }

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(PlayerResponse.self, from: data)

            if let random = response.data.randomElement() {
                await MainActor.run {
                    self.currentPlayer = random
                }
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load player"
            }
        }
    }
}
