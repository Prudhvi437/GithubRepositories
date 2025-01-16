//
//  RepositoriesViewModelTests.swift
//  GithubRepositories
//
//  Created by Prudhvi on 1/16/25.
//
import XCTest
@testable import GithubRepositories

final class RepositoriesViewModelTests: XCTestCase {
    
    var viewModel: RepositoriesViewModel!
    
    override func setUpWithError() throws {
        viewModel = RepositoriesViewModel() // Initialize the ViewModel
    }
    
    override func tearDownWithError() throws {
        viewModel = nil // Clean up after each test
    }
    
    func testFetchRepositories() throws {
        let expectation = XCTestExpectation(description: "Fetch repositories for a valid username")
        
        // Call the fetch method
        viewModel.fetchRepositories(for: "facebook")
        
        // Simulate an API delay for asynchronous code
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.viewModel.repositories.isEmpty, "Repositories should not be empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchRepositoriesWithEmptyUsername() throws {
        let expectation = XCTestExpectation(description: "Handle empty username gracefully")
        
        viewModel.fetchRepositories(for: "") // Empty username
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewModel.errorMessage == "Please enter a GitHub username.", "Error message should incidcate the username is empty")
            XCTAssertTrue(self.viewModel.repositories.isEmpty, "Repositories list should remain empty for an invalid username")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testFilterRepositoriesByLanguage() throws {
        // Simulate adding repositories
        viewModel.repositories = [
            Repository(id: 1, name: "Repository 1", description: "Test", language: "Swift", stargazersCount: 10, forksCount: 2, updatedAt: ""), 
            Repository(id: 2, name: "Repository 2", description: "Test", language: "Java", stargazersCount: 5, forksCount: 1, updatedAt: "")
        ]
        
        viewModel.filterRepositories(by: "Swift") // Filter for"Swift"
        
        XCTAssertEqual(viewModel.filteredRepositories.count, 1, "Filtered repositories should only contain 'Swift' repositories")
        XCTAssertEqual(viewModel.filteredRepositories.first?.language, "Swift", "The language of filtered repositories should be 'Swift'")
    }
}
