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
    let height: String?   // <-- FIX
    let team: Team
}


struct Team: Codable {
    let id: Int
    let full_name: String
}

extension Player {
    var heightFeet: Int? {
        guard let h = height else { return nil }
        return Int(h.split(separator: "-").first ?? "")
    }

    var heightInches: Int? {
        guard let h = height else { return nil }
        return Int(h.split(separator: "-").last ?? "")
    }
}
