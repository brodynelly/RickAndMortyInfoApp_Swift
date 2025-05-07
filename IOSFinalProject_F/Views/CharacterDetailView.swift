//
//  CharacterDetailView.swift
//  IOSFinalProject_F
//
//  Created by Brody Nelson on 5/4/25.
//
//
//  CharacterDetailView.swift
//  IOSFinalProject_F
//
//  Created by Brody Nelson on 5/4/25.
//

import SwiftUI

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageUrl = URL(string: character.image) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 5)
                        case .failure:
                            Image(systemName: "photo.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .foregroundColor(.gray.opacity(0.5))
                        default:
                            ProgressView()
                                .frame(height: 200)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Text(character.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Details")
                        .font(.title2)
                        .padding(.bottom, 5)
                    DetailRow(label: "Status:", value: character.status)
                    DetailRow(label: "Species:", value: character.species)
                    if !character.type.isEmpty {
                        DetailRow(label: "Type:", value: character.type)
                    }
                    DetailRow(label: "Gender:", value: character.gender)
                    DetailRow(label: "Origin:", value: character.origin.name)
                    DetailRow(label: "Last Known Location:", value: character.location.name)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Episodes")
                        .font(.title2)
                    Text("Appeared in \(character.episode.count) episode\(character.episode.count == 1 ? "" : "s")")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
