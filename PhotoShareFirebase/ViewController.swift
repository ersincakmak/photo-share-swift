//
//  ViewController.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 7.11.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toTabBarVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTabBarVC" {
            print("Navigation to Tab Bar Controller")
        }
    }
}

