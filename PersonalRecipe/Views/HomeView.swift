import SwiftUI

struct HomeView: View {
    @Binding var recipes: [Recipe]
    @State private var selectedStatus: Status = .all // Adding a default status filter
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Status", selection: $selectedStatus) {
                    ForEach(Status.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                List {
                    ForEach(filteredRecipes, id: \.id) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe, recipes: $recipes)) {
                            ZStack {
                                VStack {
                                    if let imageName = recipe.images.first, let imageURL = imageURL(for: imageName) {
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
                                            HStack {
                                                Slider(value: Binding(
                                                    get: { Double(recipe.progress) },
                                                    set: { _ in }
                                                ), in: 0...100, step: 1)
                                                .accentColor(recipe.status.rawValue == Status.cooked.rawValue ? .green : .blue)
                                                    .disabled(true)
                                                
                                                Text("\(recipe.progress)%")
                                                    .font(.subheadline)
                                                    .padding(.leading, 10)
                                            }
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

    private var filteredRecipes: [Recipe] {
        switch selectedStatus {
        case .all:
            return recipes
        default:
            return recipes.filter { $0.status == selectedStatus }
        }
    }
    
    func imageURL(for imageName: String) -> URL? {
        if imageName.hasPrefix("http") {
            return URL(string: imageName)
        } else {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return documentsDirectory.appendingPathComponent(imageName)
        }
    }
}

#Preview {
    ContentView()
}
