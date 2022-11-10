//
//  ViewController.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 7.11.2022.
//

import UIKit
import FirebaseAuth

enum ShowLoadingParams {
    case show, hide
}

final class ViewController: UIViewController, CustomAlertController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            self.showAlert(message: "You must provide email and password.", target: self)
            return
        }
        toggleLoading(.show)
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.toggleLoading(.hide)
            if error != nil {
                self.showAlert(message: error?.localizedDescription, target: self)
            } else {
                self.performSegue(withIdentifier: "toTabBarVC", sender: nil)
            }
        }
    }
    
    @IBAction func signInButtonTapped(){
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            self.showAlert(message: "You must provide email and password.", target: self)
            return
        }
        toggleLoading(.show)
        Auth.auth().signIn(withEmail: email, password: password) { data, error in
            self.toggleLoading(.hide)
            if error != nil {
                self.showAlert(message: error?.localizedDescription, target: self)
            } else {
                print(data?.user ?? "There is no user")
                self.performSegue(withIdentifier: "toTabBarVC", sender: nil)
            }
        }
    }
    
    private func toggleLoading(_ state: ShowLoadingParams){
        switch state {
        case .show:
            loadingView.isHidden = false
            indicator.startAnimating()
        case .hide:
            loadingView.isHidden = true
            indicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTabBarVC" {
            print("Navigation to Tab Bar Controller")
        }
    }
}

