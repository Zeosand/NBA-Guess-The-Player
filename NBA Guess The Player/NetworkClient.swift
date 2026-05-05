//
//  NetworkClient.swift
//  NBA Guess The Player
//
//  Created by Student on 5/5/26.
//

import SwiftUI

@Observable
class NetworkClient {
    private(set) var games: [Game] = []
    private var page = 1
    
    private let apiKey = "fe6fb9fc-d74a-4f5e-bc89-be6ef9997ab6"

    func getGames() async {
        let urlStr = "https://api.balldontlie.io/nba/v1/games?page=\(page)"
        
        guard let url = URL(string: urlStr) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(GameResponse.self, from: data)
            games.append(contentsOf: response.data)
            
            page += 1
        } catch {
            print(error)
        }
    }
}
