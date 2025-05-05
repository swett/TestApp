//
//  PhotoPicker.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 02.05.2025.
//

import SwiftUI
import UIKit
import PhotosUI

struct PhotoPicker: View {
    @Binding var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var useCamera = false
    @State private var showingOptions = false
    @Binding var isError: Bool
    @Binding var errorMassage: String
//    var onImageSelected: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(isError ? Color.theme.colorCB3D40.opacity(0.1) :  Color.theme.colorD0CFCF, lineWidth: 1)
                .frame(height: 56)
                .overlay {
                    HStack {
                        Text("\(selectedImage != nil ? "Photo Uploaded" :"Upload Your photo")")
                        Spacer()
                        Button {
                            showingOptions = true
                        } label: {
                            Text("Upload")
                                .foregroundStyle(Color.theme.color009BBD)
                                .font(.style(.button2))
                        }
                        .confirmationDialog("Select a color", isPresented: $showingOptions, titleVisibility: .visible) {
                            Button("Camera") {
                                useCamera = true
                                showingImagePicker = true
                            }
                            
                            Button("Gallery") {
                                useCamera = false
                                showingImagePicker = true
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            
            if isError {
                Text(errorMassage)
                    .font(.style(.body4))
                    .foregroundColor(Color.theme.colorCB3D40)
            }
                
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: useCamera ? .camera : .photoLibrary) { image in
                selectedImage = image
//                onImageSelected()
            }
        }
    }
}

#Preview {
    PhotoPicker(selectedImage: .constant(UIImage(named: "")), isError: .constant(false), errorMassage: .constant(""))
        .padding(.horizontal, 16)
}


struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var onImagePicked: (UIImage) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
