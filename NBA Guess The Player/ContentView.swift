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
            VStack(spacing: 24) {
                if let p = network.currentPlayer {
                    VStack(spacing: 16) {
                        Text("Guess the NBA Player")
                            .font(.title)
                            .bold()
                        
                        if revealAnswer {
                            Text("\(p.first_name) \(p.last_name)")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.blue)
                                .padding(.vertical, 4)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            if revealHints {
                                Group {
                                    Text("**Team:** \(p.team.full_name)")
                                    Text("**Position:** \(p.position.isEmpty ? "Unknown" : p.position)")
                                    Text("**Height:** \(p.heightFeet ?? 0)'\(p.heightInches ?? 0)\"")
                                    Text("**Weight:** \(p.weight ?? "Unknown") lbs")
                                    Text("**College:** \(p.college ?? "None")")
                                    Text("**Country:** \(p.country ?? "Unknown")")
                                    Text("**Jersey:** \(p.jersey_number ?? "Unknown")")
                                    Text("**Draft:** \(p.draft_year ?? 0) • Rd \(p.draft_round ?? 0) • Pick \(p.draft_number ?? 0)")
                                }
                                .font(.subheadline)
                            } else {
                                Text("Hints Hidden")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 20)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                } else {
                    ProgressView("Loading player...")
                        .padding()
                }

                VStack(spacing: 12) {
                    TextField("Enter player name", text: $guess)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    Button(action: checkGuess) {
                        Text("Submit Guess")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    if !result.isEmpty {
                        Text(result)
                            .font(.headline)
                            .foregroundStyle(result == "Correct!" ? .green : .red)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        Button("Reveal Hints") { revealHints = true }
                            .buttonStyle(.bordered)
                            .disabled(revealHints)
                        
                        Button("Show Player") { revealAnswer = true }
                            .buttonStyle(.bordered)
                            .disabled(revealAnswer)
                    }
                    
                    Button(action: { Task { await loadNewPlayer() } }) {
                        Label("Next Player", systemImage: "arrow.right.circle.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .padding(.top, 8)
                }

                Spacer()
            }
            .padding(.vertical)
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
        revealAnswer = false
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
