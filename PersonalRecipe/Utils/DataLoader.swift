import Foundation

class DataLoader {
    static let fileURL: URL = {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0]
        return documentDirectory.appendingPathComponent("recipes.json")
    }()
    
    private static func copyFileIfNeeded() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: fileURL.path),
           let bundleURL = Bundle.main.url(forResource: "recipes", withExtension: "json") {
            do {
                try fileManager.copyItem(at: bundleURL, to: fileURL)
            } catch {
                print("Error copying file: \(error)")
            }
        }
    }
    
    static func loadRecipes() -> [Recipe] {
        copyFileIfNeeded()
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let recipes = try decoder.decode([Recipe].self, from: data)
            return recipes
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
    
    static func saveRecipes(_ recipes: [Recipe]) {
        do {
            let data = try JSONEncoder().encode(recipes)
            try data.write(to: fileURL)
        } catch {
            print("Error saving recipes: \(error)")
        }
    }
    
    static func resetRecipes() {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                if let bundleURL = Bundle.main.url(forResource: "recipes", withExtension: "json") {
                    try fileManager.copyItem(at: bundleURL, to: fileURL)
                    print("Recipes reset to original!")
                }
            } catch {
                print("Error resetting recipes: \(error)")
            }
        }
    }
}

