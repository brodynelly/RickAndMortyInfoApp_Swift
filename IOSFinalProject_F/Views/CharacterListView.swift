//
//  CharacterListView.swift
//  IOSFinalProject_F
//
//  Created by Brody Nelson on 5/6/25.
//

import SwiftUI

// The main view displaying the list of characters
struct CharacterListView: View {
    
    @StateObject private var apiService = APIService()

    var body: some View {
        NavigationStack {
                // allows for page to be scrollable
                List {
                ForEach(apiService.characters) { character in
    // allows for easy navigation between pages
    NavigationLink(destination: CharacterDetailView(character: character)) {
                        CharacterRowView(character: character)

                          .task {
                                await apiService.loadMoreIfNeeded(currentItem: character)
                            }
                    }
                }

                // display loading message and error handeling
                if apiService.isLoading {
                    ProgressView("Loading more characters...")
                      .frame(maxWidth:.infinity, alignment:.center)
                      .padding()
                } else if let errorMessage = apiService.errorMessage,!apiService.characters.isEmpty {
                    Text("Error loading more: \(errorMessage)")
                      .foregroundColor(.red)
                      .frame(maxWidth:.infinity, alignment:.center)
                      .padding()
                }
            }
          .navigationTitle("Rick & Morty")
              .task { if apiService.characters.isEmpty {
                            await apiService.fetchCharacters()
                        }
     }
          .refreshable {
                await apiService.refreshCharacters()
            }
          .overlay {
                 if apiService.isLoading && apiService.characters.isEmpty {
                     ProgressView("Loading Characters...")
                 } else if let errorMessage = apiService.errorMessage, apiService.characters.isEmpty {
                     VStack {
                          Text("Failed to load characters.")
                             .font(.headline)
                          Text(errorMessage)
                             .font(.callout)
                             .foregroundColor(.gray)
                          Button("Retry") {
                               Task {
                                    await apiService.refreshCharacters()
                               }
                          }
                        .padding(.top)
                     }
                   .padding()
                 }
            }
        }
    }
}

// Preview Provider for CharacterListView
struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}
