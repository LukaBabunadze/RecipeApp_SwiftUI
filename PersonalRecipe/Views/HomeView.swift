import SwiftUI

struct HomeView: View {
    @Binding var recipes: [Recipe]

    var body: some View {
        NavigationView {
            List {
                ForEach(recipes) { recipe in
                    ZStack {
                        VStack {
                            if let imagePath = recipe.images.first {
                                let imageURL = imagePath.hasPrefix("http") ? URL(string: imagePath) : URL(fileURLWithPath: imagePath)
                                
                                AsyncImage(url: imageURL) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(height: 140)
                                            .cornerRadius(10)
                                            .clipped()
                                    } else if phase.error != nil {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 140)
                                            .foregroundColor(.gray)
                                    } else {
                                        ProgressView()
                                    }
                                }
                            }


                            HStack {
                                VStack(alignment: .leading) {
                                    Text(recipe.title)
                                        .font(.title2)
                                        .padding(.bottom, 5)
                                    Text(recipe.description)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                }
                                .padding(.trailing, 30)
                                .padding(.leading, 10)

                                Spacer()

                                Image(systemName: "trash.fill")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                                            recipes.remove(at: index)
                                            DataLoader.saveRecipes(recipes)
                                        }
                                    }
                            }
                        }
                        .padding(6)
                        .padding(.bottom, 30)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 3, x: 0, y: 2)
                    }
                    .padding(.bottom, 10)
                    .listRowSeparator(.hidden)
                }
                Button("Reset Recipes") {
                    DataLoader.resetRecipes()
                    recipes = DataLoader.loadRecipes()
                }
                .foregroundStyle(.blue)
                .listRowSeparator(.hidden)
                .padding(.bottom, 70)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("My Recipes")
        }
    }
}

#Preview {
    ContentView()
}

