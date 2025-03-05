import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe] = DataLoader.loadRecipes()

    var body: some View {
        TabView {
            HomeView(recipes: $recipes)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            Text("Cooking Tab")
                .tabItem {
                    Label("Cooking", systemImage: "flame.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}

