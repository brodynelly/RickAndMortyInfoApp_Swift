//
//  APIService.swift
//  IOSFinalProject_F
//
//  Created by Brody Nelson on 5/4/25.
//// In Services/APIService.swift
//
//  APIService.swift
//  IOSFinalProject_F
//
//  Created by Brody Nelson on 5/4/25.
//

import Foundation
import Combine

class APIService: ObservableObject {
    @Published var characters: [Character] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    private var currentPage = 1
    private var totalPages = 1
    private var nextURL: String? = "https://rickandmortyapi.com/api/character"

    @MainActor
    func fetchCharacters() async {
        guard !isLoading, let urlString = nextURL else {
            if nextURL == nil {
                print("DEBUG: Reached end of character list or no URL.")
            } else if isLoading {
                print("DEBUG: Fetch request ignored, already loading.")
            }
            return
        }

        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL: \(urlString)"
            print("DEBUG: Invalid URL - \(urlString)")
            return
        }

        isLoading = true
        errorMessage = nil
        print("DEBUG: Fetching characters from URL: \(url)")

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                errorMessage = "Invalid server response. Status Code: \(statusCode)"
                print("DEBUG: Invalid response - Status Code: \(statusCode)")
                isLoading = false
                return
            }

            let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)

            characters.append(contentsOf: apiResponse.results)
            nextURL = apiResponse.info.next
            totalPages = apiResponse.info.pages
            currentPage += 1
            print("DEBUG: Successfully fetched page. Total characters: \(characters.count). Next URL: \(nextURL ?? "None")")

        } catch {
            errorMessage = "Failed to fetch or decode data: \(error.localizedDescription)"
            print("DEBUG: Error fetching/decoding data: \(error)")
        }

        isLoading = false
    }

    @MainActor
    func loadMoreIfNeeded(currentItem item: Character?) {
        guard let item = item else {
            Task {
                await fetchCharacters()
            }
            return
        }

        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
        if characters.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            print("DEBUG: Threshold reached by item \(item.name). Loading more.")
            Task {
                await fetchCharacters()
            }
        }
    }

    @MainActor
    func refreshCharacters() async {
        print("DEBUG: Refreshing characters...")
        characters = []
        nextURL = "https://rickandmortyapi.com/api/character"
        currentPage = 1
        isLoading = false
        errorMessage = nil

        await fetchCharacters()
    }
}
