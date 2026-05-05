//
//  DataModels.swift
//  NBA Guess The Player
//
//  Created by Student on 5/5/26.
//

struct GameResponse: Codable {
    let data: [Game]
}

struct Game: Codable, Identifiable {
    let id: Int
    let date: String
    let home_team: Team
    let visitor_team: Team
    let home_team_score: Int
    let visitor_team_score: Int
}

struct Team: Codable {
    let id: Int
    let full_name: String
}
