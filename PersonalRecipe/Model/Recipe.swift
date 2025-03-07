//
//  Recipe.swift
//  PersonalRecipe
//
//  Created by Luka Babunadze on 05.03.25.
//
import Foundation

enum Status: String, Codable, CaseIterable, Hashable {
    case toCook = "To Cook"
    case cooked = "Cooked"
    case cooking = "Cooking"
}

struct Recipe: Identifiable, Codable {
    var id: Double
    var title: String
    var description: String
    var status: Status
    var estimatedTime: Int
    var images: [String]
}
