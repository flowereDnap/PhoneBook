//
//  SignUpVC.swift
//  PhoneBook2
//
//  Created by User on 25.04.2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class SignUpVC: UIViewController {

  @IBOutlet var emailField: UITextField!
  @IBOutlet var userNameField: UITextField!
  @IBOutlet var passwordField: UITextField!
  @IBOutlet var passwordConfirmField: UITextField!
  @IBOutlet var errorLable: UILabel!
  @IBOutlet var backBtt: UIButton!
  
  let loadingVC = LoadingViewController.getView()
  
  var gotAnswer: Bool! {
    didSet {
      if gotAnswer == true {
        self.dismiss(animated: true, completion: nil)
      } else {
        self.present(loadingVC, animated: true, completion: nil)
      }
    }
  }
  
  override func viewDidLoad(){
    super.viewDidLoad()
    errorLable.alpha = 0

    passwordField.isSecureTextEntry = true
    passwordConfirmField.isSecureTextEntry = true
    
    passwordField.enablePasswordToggle2()
    passwordConfirmField.enablePasswordToggle3()
  }
  
  @IBAction func backBtt(_ sender: UIButton){
    self.dismiss(animated: true)
  }
  @IBAction func signUpBtt(_ sender: UIButton){
    
      
      if  emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
          passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        showError("Please fill in all fields.")
        return
      }
      
      let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      
      if !LoginViewController.isPasswordValid(cleanedPassword) {
        showError("Make sure your password is at least 6 characters long")
        return
      }
      
      let cleanedEmail = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      
      if !LoginViewController.isValidEmail(testStr: cleanedEmail){
        showError("invalid email")
        return
      }
      
  
    let email = emailField.text!
    let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let passwordConfirm = passwordConfirmField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let userName = userNameField.text!
    
    //creating new account with email and validating password

      if userName.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        self.showError("invalid name")
        return
      }
      if password != passwordConfirm {
        self.showError("passwords dont match")
        return
      }
      
      self.gotAnswer = false
      Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
        if error != nil {
          self.showError("error creating user: \(error!.localizedDescription)")
          self.gotAnswer = true
          return
        }
        
        let db = Firestore.firestore()
        let user = User(uid: result!.user.uid, email: result!.user.email ?? "", name: userName)
        ApiClient.user = user
        db.collection("users").document(user.uid).setData(["name": user.name])
        
        self.gotAnswer = true
        self.dismiss(animated: true)
        
    }
  }
  
  func showError(_ err: String) {
    errorLable.text = err
    errorLable.alpha = 1

  }
  func hideError(){
    errorLable.alpha = 0
  }
 
  func transitionToListOfContacts() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "ContactsList") as! UINavigationController
    vc.modalPresentationStyle = .fullScreen
    self.present(vc , animated: true, completion: nil)
  }

}
