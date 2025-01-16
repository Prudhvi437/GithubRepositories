//
//  RepositoriesViewModel.swift
//  GithubRepositories
//
//  Created by Prudhvi on 1/15/25.
//
import Foundation
import Combine

class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = [] // All repositories
    @Published var filteredRepositories: [Repository] = [] // Filtered list
    @Published var errorMessage: String = "" // Error message for UI
    @Published var isLoading: Bool = false // Loading indicator state
    
    private var cancellables: Set<AnyCancellable> = []
    private var page = 1
    private var userName = ""
    private var isPaginating = false
    
    // MARK: - Fetch repositories
    func fetchRepositories(for userName: String) {
        print("fetchRepositories triggered for username: \(userName)")
        guard !userName.isEmpty else {
            self.errorMessage = "Please enter a GitHub username."
            print("Empty username provided")
            return
        }
        
        guard !isLoading else { return } // Prevent multiple concurrent requests
        isLoading = true
        errorMessage = ""
        
        print("Fetching repositories for username: \(userName)")
        
        APIService.shared.fetchRepositories(username: userName, page: page)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    // Differentiate between decoding error and other errors
                    if let urlError = error as? URLError {
                        print("Network error: \(urlError.localizedDescription)")
                        self?.errorMessage = "Network error. Please check your connection and try again."
                    } else {
                        print("Error fetching repositories: \(error.localizedDescription)")
                        self?.errorMessage = "Failed to fetch repositories: \(error.localizedDescription)"
                    }
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] repositories in
                print("Fetched \(repositories.count) repositories")
                if repositories.isEmpty {
                    self?.errorMessage = "No repositories found for '\(userName)'."
                }
                self?.repositories = repositories
                self?.filteredRepositories = repositories
                self?.page += 1 // Reset pagination
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Filter Repositories by Language
    func filterRepositories(by language: String?) {
        if let language = language, !language.isEmpty {
            filteredRepositories = repositories.filter { $0.language == language }
        } else {
            filteredRepositories = repositories // Show all respositories if no longuage is selected
        }
    }
    
    // MARK: - Load More Repositories (Pagination)
    func loadMoreRepositories() {
        guard !isPaginating else { return } // Prevent multiple concurrent requests
        isPaginating = true
        page += 1 // Increment page number
        
        APIService.shared.fetchRepositories(username: userName, page: page)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isPaginating = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription // Update error message
                    print("Pagination Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] newRepositories in
                print("Fetched \(newRepositories.count) additional repositories")
                self?.repositories.append(contentsOf: newRepositories)
                self?.filteredRepositories = self?.repositories ?? []
            })
            .store(in: &cancellables)
    }
}
