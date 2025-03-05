import SwiftUI

struct HomeView: View {
    @Binding var recipes: [Recipe]

    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) { recipe in
                    HStack {
                        if let imageURL = URL(string: recipe.images.first ?? "") {
                            AsyncImage(url: imageURL) { image in
                                image.resizable()
                                     .scaledToFill()
                                     .frame(width: 70, height: 70)
                                     .cornerRadius(10)
                                     .clipped()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(recipe.title)
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                Text(recipe.description)
                                    .font(.subheadline)
                                    .lineLimit(2)
                            }
                            .padding(.trailing, 30)
                            .padding(.leading, 10)
                            
                            Spacer()
                            
                            Button(action: {
                                // Delete action: remove the recipe from the array and save
                                if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                                    recipes.remove(at: index)
                                    DataLoader.saveRecipes(recipes)
                                }
                            }) {
                                Image(systemName: "trash.fill")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                Button("Reset Recipes") {
                    DataLoader.resetRecipes()
                    recipes = DataLoader.loadRecipes()
                }
            }
            .navigationTitle("Recipes Home")
        }
    }
}

#Preview {
    ContentView()
}

