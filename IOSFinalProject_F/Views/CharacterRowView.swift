//
//  CharacterRowView.swift
//  IOSFinalProject_F
//
//  Created by Brody Nelson on 5/4/25.
//
import SwiftUI

// A reusable view component for displaying a single character in a list row
struct CharacterRowView: View {
    let character: Character

    var body: some View {
        HStack(spacing: 15) {
            // load the characters image
            AsyncImage(url: URL(string: character.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 50)

                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1))

                case .failure:
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)

                @unknown default:
                    EmptyView()
                }
            }

            // display the name and various other related information
            VStack(alignment: .leading, spacing: 4) {
                // title for the name and subtitle for Species
                Text(character.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)

                
                DetailRow(label: "Gender:", value: character.gender)
                DetailRow(label: "Origin:", value: character.origin.name)
                DetailRow(label: "Last Known Location:", value: character.location.name)
                
                // condition for empty list
                if !character.type.isEmpty {
                    DetailRow(label: "Type:", value: character.type)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}
