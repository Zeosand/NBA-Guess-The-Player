//
//  ContentView.swift
//  NBA Guess The Player
//
//  Created by Student on 5/4/26.
//

import SwiftUI

struct ContentView: View {
    @State var network = NetworkClient()

    var body: some View {
        NavigationStack {
            List(network.games) { game in
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("\(game.home_team.full_name) vs \(game.visitor_team.full_name)")
                        .font(.headline)
                    
                    Text("\(game.home_team_score) - \(game.visitor_team_score)")
                        .font(.subheadline)
                    
                    Text(game.date)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("NBA Games")
            .task {
                await network.getGames()
            }
        }
    }
}
