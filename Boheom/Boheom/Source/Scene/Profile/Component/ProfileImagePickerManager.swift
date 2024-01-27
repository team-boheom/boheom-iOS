import UIKit
import PhotosUI

class ProfileImagePickerManager {
    private var itemProviders: NSItemProvider?

    func makeImagePicker() -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let imagePicker = PHPickerViewController(configuration: config)
        return imagePicker
    }

    func setSelectImage(item: NSItemProvider?) {
        guard let item else { return }
        self.itemProviders = item
    }

    func toUIImage() async -> UIImage? {
        guard let targe = itemProviders,
              targe.canLoadObject(ofClass: UIImage.self)
        else { return nil }

        let resultImage = await withCheckedContinuation { continuation in
            targe.loadObject(ofClass: UIImage.self) { image, _ in
                continuation.resume(returning: image as? UIImage)
            }
        }

        return resultImage
    }

    func toData() async -> Data? {
        guard let target = await toUIImage() else { return nil }
        return target.jpegData(compressionQuality: 0.5)
    }
}
