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
    @State private var selectedStatus: Status = .toCook
    
    @State private var selectedImages: [UIImage] = []
    @State private var selectedCameraImage: UIImage? = nil
    
    @State private var showMultiImagePicker: Bool = false
    @State private var showCameraPicker: Bool = false
    
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
                Section(header: Text("Photo")) {
                    
                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    
                    Button("Select from Library") {
                        showMultiImagePicker = true
                    }
                    Button("Take Photo") {
                        showCameraPicker = true
                    }
                    
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    var imagePaths: [String] = []
                    for image in selectedImages {
                        if let path = saveImageToDocuments(image: image) {
                            imagePaths.append(path)
                        }
                    }
                    
                    let newRecipe = Recipe(
                        id: Double.random(in: 1...1000000),
                        title: title,
                        description: description,
                        status: selectedStatus,
                        estimatedTime: Int(estimatedTime) ?? 0,
                        images: imagePaths
                    )
                    onSave(newRecipe)
                    
                    title = ""
                    description = ""
                    estimatedTime = ""
                    selectedStatus = .toCook
                    selectedImages = []
                    
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(isPresented: $showMultiImagePicker) {
                MultiImagePicker(selectedImages: $selectedImages)
            }
            .sheet(isPresented: $showCameraPicker) {
                ImagePicker(selectedImage: $selectedCameraImage, sourceType: .camera)
            }
            .onChange(of: selectedCameraImage) { newValue, _ in
                if let newImage = newValue {
                    selectedImages.append(newImage)
                    selectedCameraImage = nil
                }
            }
        }
    }
    
    private func saveImageToDocuments(image: UIImage) -> String? {
            guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
            let filename = UUID().uuidString + ".jpg"
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(filename)
            do {
                try data.write(to: fileURL)
                return fileURL.path
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
    }
}

#Preview {
    ContentView()
}
