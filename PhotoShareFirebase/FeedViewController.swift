//
//  FeedViewController.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 10.11.2022.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let db = Firestore.firestore()
        
        db.collection("posts").getDocuments { snapshots, error in
            if error != nil {
                print("There was an error occurred while fetching the posts")
            } else {
                guard let document = snapshots?.documents[0] else { return }
                let image = document.data()["image"]
                print(image)
//                guard let imageData = Data(base64Encoded: image as! String) else { return }
//                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
}
