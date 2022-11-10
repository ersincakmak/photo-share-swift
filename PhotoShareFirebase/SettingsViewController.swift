//
//  SettingsViewController.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 7.11.2022.
//

import UIKit
import FirebaseAuth

final class SettingsViewController: UIViewController, CustomAlertController {
    
    @IBOutlet weak var hiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userEmail = Auth.auth().currentUser?.email ?? "unknown"
        let regex = try! NSRegularExpression(
            pattern: "@.+",
            options: NSRegularExpression.Options.caseInsensitive
        )
        let range = NSMakeRange(0, userEmail.count)
        let username = regex.stringByReplacingMatches(in: userEmail, options: [], range: range, withTemplate: "")
        hiLabel.text = "Hi, @\(username)!"
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
