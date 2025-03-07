//
//  AddRecipeView.swift
//  PersonalRecipe
//
//  Created by Luka Babunadze on 06.03.25.
//

import SwiftUI

struct AddRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var estimatedTime: String = ""
    @State private var imageURL: String = ""
    @State private var selectedStatus: Status = .toCook
    
    var onSave: (Recipe) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Estimated Time (min)", text: $estimatedTime)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Status")) {
                    Picker("Status", selection: $selectedStatus) {
                        ForEach(Status.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Image URL")) {
                    TextField("Enter image URL", text: $imageURL)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newRecipe = Recipe(
                        id: 10.20,
                        title: title,
                        description: description,
                        status: Status.cooked,
                        estimatedTime: 30,
                        images:[ "https://images.pexels.com/photos/30871742/pexels-photo-30871742/free-photo-of-close-up-of-cherry-blossom-in-springtime.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"]
                    )
                    onSave(newRecipe)
                    title = ""
                    description = ""
                    estimatedTime = ""
//                    imageURL = ""
                                       
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    ContentView()
}
