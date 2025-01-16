//
//  ContentView.swift
//  GithubRepositories
//
//  Created by Prudhvi on 1/15/25.
//
import SwiftUI

struct ContentView: View {
@StateObject private var viewModel = RepositoriesViewModel()
@State private var username = "" // Empty by default
@State private var selectedLanguage: String? = nil // For language filtering

var body: some View {
    NavigationView {
        VStack {
            // Error banner at the top
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Search Bar with Clear Button
            TextField("Enter GitHub Username", text: $username, onCommit: {
                // Trigger fetch only when the user press Enter
                if username.isEmpty{
                    // Reset if the input is empty
                    viewModel.errorMessage = "Please enter a GitHub username."
                    viewModel.repositories = []
                    viewModel.filteredRepositories = []
                } else {
                    print("Fetching repositories for username: \(username)")
                    viewModel.errorMessage = ""
                    viewModel.repositories = []
                    viewModel.filteredRepositories = []
                    print("Fetching repositories for \(username)")
                    viewModel.fetchRepositories(for: username)
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .overlay(
                HStack {
                    Spacer()
                    if !username.isEmpty {
                        Button(action: {
                            // Clear the search bar and reset data
                            username = ""
                            viewModel.repositories = []
                            viewModel.filteredRepositories = []
                            viewModel.errorMessage = "" // Clear error message
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                )

            // Language Filter
            Picker("Filter by Language", selection: $selectedLanguage) {
                Text("All").tag(String?.none)
                ForEach(Array(Set(viewModel.repositories.compactMap { $0.language })), id: \.self) { language in
                    Text(language).tag(language as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .onChange(of: selectedLanguage) { newValue in
                viewModel.filterRepositories(by: newValue)
            }

            // Repository List
            List(viewModel.filteredRepositories) { repo in
                NavigationLink(destination: RepositoryDetailView(repository: repo)) {
                    RepositoryRow(repository: repo)
                }
                .onAppear {
                    if repo == viewModel.repositories.last {
                        viewModel.loadMoreRepositories()
                    }
                }
            }
            .listStyle(PlainListStyle())

            // Loading Indicator
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            }
        } // <-- Closing VStack
        .navigationTitle("Repositories")
    }
} // <-- Closing NavigationView
} // <-- Closing ContentView struct
