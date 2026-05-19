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
    @State private var revealAnswer = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if revealAnswer, let p = network.currentPlayer {
                    Text("Answer: \(p.first_name) \(p.last_name)")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blue)
                }

                if let p = network.currentPlayer {
                    VStack(spacing: 8) {
                        if revealHints, let p = network.currentPlayer {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Team: \(p.team.full_name)")
                                Text("Position: \(p.position.isEmpty ? "Unknown" : p.position)")
                                Text("Height: \(p.heightFeet ?? 0)'\(p.heightInches ?? 0)\"")
                                Text("Weight: \(p.weight ?? "Unknown") lbs")
                                Text("College: \(p.college ?? "None")")
                                Text("Country: \(p.country ?? "Unknown")")
                                Text("Jersey: \(p.jersey_number ?? "Unknown")")
                                Text("Draft: \(p.draft_year ?? 0) • Round \(p.draft_round ?? 0) • Pick \(p.draft_number ?? 0)")
                            }
                        }
else {
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
                Button("Show Player") {
                    revealAnswer = true
                }


                Button("Next Player") {
                    Task { await loadNewPlayer() }
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .navigationTitle("NBA Guess the Player")
            .task {
                await loadNewPlayer()
            }
        }
    }

    func loadNewPlayer() async {
        result = ""
        guess = ""
        revealHints = false
        revealAnswer = false   // <-- reset answer
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
