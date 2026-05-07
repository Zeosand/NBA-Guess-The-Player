//
//  DataModels.swift
//  NBA Guess The Player
//
//  Created by Student on 5/5/26.
//


import Foundation

struct PlayerResponse: Codable {
    let data: [Player]
}

struct Player: Codable, Identifiable {
    let id: Int
    let first_name: String
    let last_name: String
    let position: String
    let height_feet: Int?
    let height_inches: Int?
    let team: Team
}

struct Team: Codable {
    let id: Int
    let full_name: String
}
