//
//  LoginViewController.swift
//  PhoneBook2
//
//  Created by User on 18.03.2022.
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class LoginViewController: UIViewController {
  
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var errorLable: UILabel!
  @IBOutlet var signUpTextField: UITextField!
  
  let loadingVC = LoadingViewController()
  var parentView: ViewController!
  
  var gotAnswer: Bool! {
    didSet {
      if gotAnswer == true {
        self.dismiss(animated: true, completion: nil)
      } else {
        self.present(loadingVC, animated: true, completion: nil)
      }
    }
  }
  
  var handle: AuthStateDidChangeListenerHandle?
  
  override func viewWillAppear(_ animated: Bool) {
    passwordTextField.text = nil
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    passwordTextField.enablePasswordToggle()
    
    loadingVC.modalPresentationStyle = .overCurrentContext
    loadingVC.modalTransitionStyle = .crossDissolve
    
    //hide an error lable
    errorLable.alpha = 0
  }
  
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
   
    let error = checkTheFields()
    if let error = error {
      showError(error)
      return
    } else {
      hideError()
    }
    
    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

 
    gotAnswer = false
    Auth.auth().signIn(withEmail: email, password: password) { user, error in
      if let error = error {
        self.showError(error.localizedDescription)
        self.gotAnswer = true
        return
      }
      DataManager.user = User(authData: Auth.auth().currentUser!)
      let db = Firestore.firestore()
      
        let docRef = db.collection("users").document(DataManager.user.uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
              DataManager.user.name = document.get("name") as! String
              print("name:  ", DataManager.user.name)
            } else {
                print("Document does not exist in cache")
            }
        }
      
      DataManager.user.password = password
      self.gotAnswer = true
      
      DataManager.dataProvType = .server
      self.showToast(message: "loaded with server")
      self.parentView.setUpView()
      self.dismiss(animated: true, completion: nil)
    }
  }
  @IBAction func signUpButtonPressed(_ sender: UIButton) {
    // check the fields
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: SignUpVC = mainStoryboard.instantiateViewController(withIdentifier: "SignUp") as! SignUpVC
    vc.modalPresentationStyle = .fullScreen
    self.present(vc , animated: true, completion: nil)
  
    
    
    
  }
  
  func transitionToListOfContacts() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "ContactsList") as! UINavigationController
    vc.modalPresentationStyle = .fullScreen
    self.present(vc , animated: true, completion: nil)
  }
  
  func showError(_ err: String) {
    errorLable.text = err
    errorLable.alpha = 1

  }
  func hideError(){
    errorLable.alpha = 0
  }
  
  func checkTheFields() -> String? {
    
    if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      return "Please fill in all fields."
    }
    
    let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if !LoginViewController.isPasswordValid(cleanedPassword) {
      return "Make sure your password is at least 6 characters long"
    }
    
    let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if !LoginViewController.isValidEmail(testStr: cleanedEmail){
      return "invalid email"
    }
    
    return nil
  }
  
  static func isPasswordValid(_ password : String) -> Bool{
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^[0-9A-Za-z\\d$@$#!%*?&]{6,}")
    return passwordTest.evaluate(with: password)
  }
  
  static func isValidEmail(testStr:String) -> Bool {
    
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
  }
}
