//
//  Recipe.swift
//  PersonalRecipe
//
//  Created by Luka Babunadze on 05.03.25.
//
import Foundation

struct Recipe: Identifiable, Codable {
    var id: Int
    var title: String
    var description: String
    var status: String
    var estimatedTime: Int
    var images: [String]
}
