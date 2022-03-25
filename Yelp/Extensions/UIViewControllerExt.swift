//
//  UIViewControllerExt.swift
//  Yelp
//
//  Created by Bach Mai on 3/24/22.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
