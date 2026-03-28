//
//  PhotoView.swift
//  SnacktacularUI
//
//  Created by Zimeng Yang on 3/22/26.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    @State var spot: Spot // passed in from SpotDetailView
    @State private var photo = Photo()
    @State private var data = Data() // we need this to take image & convert into data to save it
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Spacer() 
            
            selectedImage
                .resizable()
                .scaledToFit()
            
            Spacer()
            
            TextField("description", text: $photo.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            
            Text("by: \(photo.reviewer), on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")

                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            Task {
                                await PhotoViewModel.saveImage(spot: spot, photo: photo, data: data)
                                dismiss()
                            }
                        }
                    }
                }
                .photosPicker(isPresented: $isPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    Task {
                        do {
                            if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image
                            }
                            // Get the raw data from image so we can save it to Firebase Storage
                            guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                                print("😡 ERROR: Could not convert data from selectedPhoto")
                                return
                            }
                            data = transferredData
                            
                        } catch {
                            print("😡 ERROR: Could not create Image from selectedPhoto. \(error.localizedDescription)")
                        }
                    }
                    
                }
            
        }
        .padding()
        
    }
}

#Preview {
    NavigationStack {
        PhotoView(spot: Spot())
    }
}
