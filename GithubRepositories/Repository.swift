//
//  Repository.swift
//  GithubRepositories
//
//  Created by Prudhvi on 1/15/25.
//
import Foundation

struct Repository: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let description: String? // Optional because it may not be present
    let language: String? // Optional because it may not be present
    let stargazersCount: Int // Correctly mapped to JSON "stargazers_count"
    let forksCount: Int // Correctly mapped to JSON "forks_count"
    let updatedAt: String // Correctly mapped to JSON "updated_at"
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case updatedAt = "updated_at"
    }
    
    // Conformance to Equatable
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}
