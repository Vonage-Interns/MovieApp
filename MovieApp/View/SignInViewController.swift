//
//  SignInViewController.swift
//  MovieApp
//
//  Created by Shreeshailgouda Patil on 05/11/25.
//

import UIKit
import CoreData
import SwiftUI

class SignInViewController: UIViewController {

  

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


    @IBAction func signInTapped(_ sender: UIButton) {
        // Validate input
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert("Please enter username and password")
            return
        }
        // Authenticate user
        if viewModel.validateUser(username: username, password: password) {
            let homeView = HomeView(username: username, onLogout: { [weak self] in
                self?.dismiss(animated: true)
            }) // Create SwiftUI view
            
            let hostingController = UIHostingController(rootView: homeView)// Wrap SwiftUI view
            hostingController.modalPresentationStyle = .fullScreen // Present full screen
            present(hostingController, animated: true)
        }
        else {
            showAlert ("Invalid credentials")

        }
    }
    
    @IBAction func goToSignUpTapped(_ sender: UIButton) {
        print("Go to Sign Up button tapped")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? UIViewController {
            self.present(signUpVC, animated: true)
        }
    }
    
    
    // Helper to show alerts
//    func showAlert(_ message: String) {
//        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
    
    @IBAction func showAllUsers(_ sender: UIButton) {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                let username = user.value(forKey: "username") as? String ?? ""
                let password = user.value(forKey: "password") as? String ?? ""
                print("\(username) — \(password)")
            }
        } catch {
            print("Error fetching users: \(error)")
        }
    }

    
    

}
