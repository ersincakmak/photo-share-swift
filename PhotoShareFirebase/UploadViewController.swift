//
//  UploadViewController.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 9.11.2022.
//

import UIKit
import Photos
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UploadViewController: UIViewController, CustomAlertController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    var imageChangeObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        self.resetValues()
        self.setImageViewGestureRecognizer()
        self.trackImageChanges()
    }
    
    private func resetValues(){
        imageView.image = UIImage(named: "select_image")
        textField.text = ""
        uploadButton.isEnabled = false
    }
    
    @objc private func showOptions(){
        let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        let openGallery = UIAlertAction(title: "Open gallerry", style: .default) { _ in
            self.openPHPicker()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(openGallery)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
    @IBAction func textFieldEditChange(_ sender: Any) {
        validateItems()
    }
    
    private func trackImageChanges(){
        imageChangeObservation = imageView.observe(\.image, changeHandler: { _, change in
            self.validateItems()
        })
    }
    
    private func validateItems(){
        guard
            let image = imageView.image,
            image != UIImage(named: "select_image"),
            let text = textField.text,
            text != ""
        else {
            uploadButton.isEnabled = false
            return
        }
        uploadButton.isEnabled = true
    }
    
    private func setImageViewGestureRecognizer() {
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showOptions))
        gestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        guard
            let title = textField.text,
            let image = imageView.image,
            let imageData = image.jpegData(compressionQuality: 0.25)
        else { return }
        
        let firestore = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("media").child("\(UUID().uuidString).jpg")
        
        imageRef.putData(imageData) { metadata, error in
            if error != nil {
                self.showAlert(message: error?.localizedDescription, target: self)
                print("There was an error occurred while uploading image to storage")
            } else {
                imageRef.downloadURL { url, error in
                    if error != nil {
                        self.showAlert(message: error?.localizedDescription, target: self)
                        print("There was an error occurred while downloading image url from storage")
                    } else {
                        let post = [
                            "title": title,
                            "image": url?.absoluteString ?? "",
                            "owner": Auth.auth().currentUser?.email ?? "unknown user"
                        ] as [String : Any]
                        
                        firestore.collection("posts").addDocument(data: post) { error in
                            if error != nil {
                                self.showAlert(message: error?.localizedDescription, target: self)
                                print(error?.localizedDescription ?? "There was an error occurred while uploading post")
                            } else {
                                self.resetValues()
                                self.tabBarController?.selectedIndex = 0
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UploadViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    /// call this method for `PHPicker`
    func openPHPicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
}
