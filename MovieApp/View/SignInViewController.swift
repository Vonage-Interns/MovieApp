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

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


    @IBAction func signInTapped(_ sender: UIButton) {
        // Validate input (textfield currently holds email)
        guard let emailInput = emailTextField.text, !emailInput.isEmpty,
              let passwordInput = passwordTextField.text, !passwordInput.isEmpty else {
            showAlert("Please enter email and password")
            return
        }
        
        // Authenticate user using email + password
        if viewModel.validateUser(email: emailInput, password: passwordInput) {
            guard let userID = viewModel.fetchUserID(forEmail: emailInput) else {
                showAlert("Unable to load user ID")
                return
            }
            // Fetch stored username for this email (fallback to entered email)
            let displayUsername = viewModel.fetchUsername(forEmail: emailInput) ?? emailInput
            // Present HomeView with real username and also passing userID
            let homeView = HomeView(username: displayUsername, userID: userID, onLogout: { [weak self] in
                self?.dismiss(animated: true)
            })
            let hostingController = UIHostingController(rootView: homeView)
            hostingController.modalPresentationStyle = .fullScreen
            present(hostingController, animated: true)
        } else {
            showAlert("Invalid credentials")
        }
    }
    
    @IBAction func goToSignUpTapped(_ sender: UIButton) {
        print("Go to Sign Up button tapped")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Instantiate directly; storyboard returns a UIViewController. If identifier is wrong this will crash, which is fine for development.
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC")
        present(signUpVC, animated: true)
    }
    
    @IBAction func showAllUsers(_ sender: UIButton) {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")

        do {
            let userObjects = try context.fetch(fetchRequest)
            let appUsers = userObjects.compactMap { AppUser(managedObject: $0) } // Appuser extension

            for user in appUsers {
                print("\(user.email) — \(user.hashedPassword)")
            }
        } catch {
            print("Error fetching users: \(error)")
        }
    }

}
