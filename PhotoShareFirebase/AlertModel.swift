//
//  AlertModel.swift
//  PhotoShareFirebase
//
//  Created by Ersin ÇAKMAK on 8.11.2022.
//

import Foundation
import UIKit

protocol CustomAlertController {
    func showAlert(message: String?, target: UIViewController)
}

extension CustomAlertController {
    func showAlert(message: String?, target: UIViewController){
        let alertController = UIAlertController(
            title: "Warning",
            message: message ?? "There was an error occurred.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        target.present(alertController, animated: true)
    }
}
