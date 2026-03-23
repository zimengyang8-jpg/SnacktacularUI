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
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            selectedImage
                .resizable()
                .scaledToFit()
                
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    // TODO: add save
                    dismiss()
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
                } catch {
                    print("😡 ERROR: Could not create Image from selectedPhoto. \(error.localizedDescription)")
                }
            }
            
        }
    }
}

#Preview {
    PhotoView(spot: Spot())
}
