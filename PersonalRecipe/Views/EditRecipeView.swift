//
//  EditRecipeView.swift
//  PersonalRecipe
//
//  Created by Luka Babunadze on 14.03.25.
//

import SwiftUI

struct EditRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var recipe: Recipe
    @State private var selectedStatus: Status = .toCook // Default value
    @State private var estimatedTime: String = ""
    @Binding var recipes: [Recipe]

    var body: some View {
        Form {
            Section(header: Text("Recipe Details")) {
                
                VStack {
                    Text("Title")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Recipe Title", text: $recipe.title)
                }
                
                VStack {
                    Text("Description")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Recipe Description", text: $recipe.description)
                }
                
                VStack {
                    Text("Estimated Time (in minutes)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Estimated Time", text: $estimatedTime)
                        .keyboardType(.numberPad)
                }
            }

            Section(header: Text("Status")) {
                Picker("Status", selection: $selectedStatus) {
                    ForEach(Status.allCases.filter { $0 != .all }, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Progress")) {
                Slider(value: Binding(
                    get: { Double(recipe.progress) },
                    set: { newValue in
                        recipe.progress = Int(newValue) // Update progress directly
                    }
                ), in: 0...100, step: 1)
                .accentColor(recipe.status == .cooked ? .green : .blue)
                Text("\(recipe.progress)%")
                    .font(.subheadline)
            }

            HStack {
                Spacer()
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
                Spacer()
            }
        }
        .navigationTitle("Edit Recipe")
        .navigationBarItems(
            trailing: Button("Edit") {
               if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                   
                   recipes[index].status = selectedStatus
                   recipes[index].estimatedTime = Int(estimatedTime) ?? 0
                   recipes[index].progress = recipe.progress

                   
                   DataLoader.saveRecipes(recipes)
               }
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.blue)
        )
        .onAppear {
            if let currentStatus = Status(rawValue: recipe.status.rawValue) {
                selectedStatus = currentStatus
            }
            estimatedTime = String(recipe.estimatedTime)
        }
    }
}


