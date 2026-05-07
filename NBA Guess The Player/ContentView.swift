//
//  ContentView.swift
//  NBA Guess The Player
//
//  Created by Student on 5/4/26.
//


import SwiftUI

struct ContentView: View {
    @State var network = NetworkClient()
    @State private var guess = ""
    @State private var result = ""
    @State private var revealHints = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                if let p = network.currentPlayer {
                    VStack(spacing: 8) {
                        Text("Guess the NBA Player")
                            .font(.largeTitle)
                            .bold()

                        if revealHints {
                            Text("Team: \(p.team.full_name)")
                            Text("Position: \(p.position.isEmpty ? "Unknown" : p.position)")
                            Text("Height: \(p.height_feet ?? 0)'\(p.height_inches ?? 0)\"")
                        } else {
                            Text("Hints Hidden")
                                .foregroundStyle(.gray)
                        }
                    }
                } else {
                    Text("Loading player...")
                }

                TextField("Enter player name", text: $guess)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Submit Guess") {
                    checkGuess()
                }
                .buttonStyle(.borderedProminent)

                Text(result)
                    .font(.title2)
                    .foregroundStyle(result == "Correct!" ? .green : .red)

                Button("Reveal Hints") {
                    revealHints = true
                }

                Button("Next Player") {
                    Task { await loadNewPlayer() }
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .navigationTitle("NBA Guess")
            .task {
                await loadNewPlayer()
            }
        }
    }

    func loadNewPlayer() async {
        result = ""
        guess = ""
        revealHints = false
        await network.fetchRandomPlayer()
    }

    func checkGuess() {
        guard let p = network.currentPlayer else { return }

        let answer = "\(p.first_name) \(p.last_name)".lowercased()
        let userGuess = guess.lowercased().trimmingCharacters(in: .whitespaces)

        if userGuess == answer {
            result = "Correct!"
        } else {
            result = "Try again"
        }
    }
}
