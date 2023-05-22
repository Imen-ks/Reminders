//
//  PhotoPickerView.swift
//  Reminders
//
//  Created by Imen Ksouri on 16/05/2023.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var isAddingImage: Bool
    @Binding var pictures: [(id: UUID, data: Data)]

    var body: some View {
        Button {
            isAddingImage.toggle()
        } label: {
            Text("Add Image")
        }
        .sheet(isPresented: $isAddingImage) {
            PhotoPicker(pictures: $pictures)
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    @State static var isAddingImage = true
    @State static var pictures: [(id: UUID, data: Data)] = [(id: UUID(), data: Data())]
    static var previews: some View {
        PhotoPickerView(isAddingImage: $isAddingImage, pictures: $pictures)
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var pictures: [(id: UUID, data: Data)]

    /// A dismiss action provided by the environment. This may be called to dismiss this view controller.
    @Environment(\.dismiss) var dismiss

    /// Creates the picker view controller that this object represents.
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> PHPickerViewController {

        // Configure the picker.
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        // Limit to images.
        configuration.filter = .images
        // Avoid transcoding, if possible.
        configuration.preferredAssetRepresentationMode = .current

        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }

    /// Creates the coordinator that allows the picker to communicate back to this object.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Updates the picker while it’s being presented.
    func updateUIViewController(_ uiViewController: PHPickerViewController,
                                context: UIViewControllerRepresentableContext<PhotoPicker>) {
        // No updates are necessary.
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    let parent: PhotoPicker

    /// Called when one or more items have been picked, or when the picker has been canceled.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        // Dismiss the presented picker.
        self.parent.dismiss()

        guard
            let result = results.first,
            result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
        else { return }

        // swiftlint:disable:next redundant_discardable_let
        let _ = result.itemProvider.loadTransferable(type: Data.self) { result in
            switch result {
            case .failure(let error):
                print("Error loading data: \(error.localizedDescription)")
            case .success(let imageData):
                Task { @MainActor [] in
                    withAnimation {
                        self.parent.pictures.append((id: UUID(), data: imageData))
                    }
                }
            }
        }
    }

    init(_ parent: PhotoPicker) {
        self.parent = parent
    }
}
