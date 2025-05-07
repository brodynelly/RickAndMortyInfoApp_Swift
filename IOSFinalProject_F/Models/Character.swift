//
//  Character.swift
//  IOSFinalProject_F
//
//  Created by Brody Nelson on 5/4/25.
//

import Foundation

// Represents the overall structure of the API response
struct APIResponse: Codable {
    let info: Info
    let results: [Character]
}

// Represents the metadata part of the API response (pagination info)
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String? // URL for the next page, optional
    let prev: String? // URL for the previous page, optional
}

// Represents a single character
struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin // Nested object
    let location: Location // Nested object
    let image: String // URL string for the character's image
    let episode: [String]// Array of URL strings for episodes
    let url: String // URL string for the character's own API endpoint
    let created: String // Date string
}

// Represents the origin location of a character
struct Origin: Codable {
    let name: String
    let url: String // URL string for the origin's API endpoint
}

// Represents the last known location of a character
struct Location: Codable {
    let name: String
    let url: String // URL string for the location's API endpoint
}
