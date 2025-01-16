//
//  RepositoryRow.swift
//  GithubRepositories
//
//  Created by Prudhvi on 1/15/25.
//
import SwiftUI

struct RepositoryRow: View {
let repository: Repository

var body: some View {
    VStack(alignment: .leading, spacing: 5) {
        Text(repository.name)
            .font(.headline)
        if let description = repository.description {
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        HStack {
            Text("⭐ \(repository.stargazersCount)")
            Text("🍴 \(repository.forksCount)")
            if let language = repository.language {
                Text("🔤 \(language)")
            }
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }
    .padding(.vertical, 8)
}
}
