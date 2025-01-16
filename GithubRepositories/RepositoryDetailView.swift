//
//  RepositoryDetailView.swift
//  GithubRepositories
//
//  Created by Prudhvi on 1/15/25.
//
import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(repository.name)
                .font(.largeTitle)
                .bold()
            if let description = repository.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            Text("Language: \(repository.language ?? "N/.A")")
            Text("Stars: \(repository.stargazersCount)")
            Text("Forks: \(repository.forksCount)")
            Text("Last Updated: \(repository.updatedAt)")
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
