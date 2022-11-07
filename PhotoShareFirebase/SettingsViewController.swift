//
//  SettingsViewController.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 7.11.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toInitialVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInitialVC" {
            print("Navigation to initial view controller")
        }
    }
}
