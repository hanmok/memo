
import SwiftUI

struct PhotoPickerPrac: View {
    
    @State private var isShowingPhotoPicker = false
    @State private var avatarImage = UIImage(named: "default-avatar")!
    
    var body: some View {
        NavigationView {
        VStack {
            Image(uiImage:avatarImage)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .padding()
                .onTapGesture { isShowingPhotoPicker = true }
            Spacer()
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPicker(avatarImage: $avatarImage)
        }
        }
    }
}


struct PhotoPicker: UIViewControllerRepresentable{
    
    @Binding var avatarImage: UIImage
    
    // called automatically when we create PhotoPicker struct.
    // we don't have to call this function manually
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
//    typealias UIViewControllerType = UIImagePickerController
    
    // create coordinator when we have one.
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage { // 1: 100% (original)
                guard let data = image.jpegData(compressionQuality: 0.1), let compressedImage = UIImage(data: data) else { return }
                photoPicker.avatarImage = compressedImage
            } else {
                // return an error shw an alert.
            }
            picker.dismiss(animated: true)
        }
    }
}
