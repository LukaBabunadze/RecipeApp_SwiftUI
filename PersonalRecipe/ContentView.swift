import SwiftUI


struct ContentView: View {
    @State private var recipes: [Recipe] = DataLoader.loadRecipes()

    var body: some View {
        TabView {
            HomeView(recipes: $recipes)
                .tabItem {
                    Label("My Recipes", systemImage: "house.fill")
                }
            
            AddRecipeView { newRecipe in
                recipes.append(newRecipe)
                DataLoader.saveRecipes(recipes)
            }
            .tabItem {
                Label("Add Recipe", systemImage: "plus.diamond")
            }
        }
    }
}

#Preview {
    ContentView()
}

