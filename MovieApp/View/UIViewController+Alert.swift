//
//  UIViewController+Alert.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 06/11/25.
//

import UIKit

extension UIViewController {
    func showAlert(_  message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
