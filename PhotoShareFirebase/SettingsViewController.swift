//
//  SettingsViewController.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 7.11.2022.
//

import UIKit
import FirebaseAuth

final class SettingsViewController: UIViewController, CustomAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toInitialVC", sender: nil)
        } catch {
            showAlert(message: error.localizedDescription, target: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInitialVC" {
            print("Navigation to initial view controller")
        }
    }
}
