//
//  RecipeDetailView.swift
//  PersonalRecipe
//
//  Created by Luka Babunadze on 14.03.25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Binding var recipes: [Recipe]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(recipe.images, id: \.self) { imagePath in
                            if let url = imageURL(for: imagePath) {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 300, height: 200)
                                            .cornerRadius(10)
                                            .clipped()
                                    } else if phase.error != nil {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 300, height: 200)
                                            .foregroundColor(.gray)
                                    } else {
                                        ProgressView()
                                            .frame(width: 300, height: 200)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Text(recipe.title)
                    .font(.largeTitle)
                    .padding(.top, 10)
                
                Text("Status: \(recipe.status)")
                    .font(.headline)
                    .foregroundColor(recipe.status.rawValue == Status.cooked.rawValue ? .green : recipe.status.rawValue == Status.toCook.rawValue ? .orange : .yellow)
                    .padding(.top, 2)
                Text("Estimated Time: \(recipe.estimatedTime) min")
                    .font(.headline)
                
                Text("Progress: ")
                    .font(.headline)
                
                Slider(value: Binding(
                    get: { Double(recipe.progress) },
                    set: { _ in }
                ), in: 0...100, step: 1)
                .accentColor(recipe.status.rawValue == Status.cooked.rawValue ? .green : .blue)
                    .disabled(true)

                Text("Detail Description: ")
                    .font(.title3)
                    .fontWeight(.bold)
                Text(recipe.description)
                    .font(.body)
                    .padding(.top, 5)
            }
            .padding()
        }
        .navigationTitle(recipe.title)
        .toolbar {
            NavigationLink(destination: EditRecipeView(recipe: recipe, recipes: $recipes)) {
                Text("Edit")
            }
        }
    }
    
    private func imageURL(for imagePath: String) -> URL? {
        if imagePath.hasPrefix("http") {
            return URL(string: imagePath)
        } else {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentsDirectory.appendingPathComponent(imagePath)
        }
    }
}

