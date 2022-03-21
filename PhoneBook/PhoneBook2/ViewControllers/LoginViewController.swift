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

class LoginViewController: UIViewController {
  
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var errorLable: UILabel!
  
  var handle: AuthStateDidChangeListenerHandle?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    handle = Auth.auth().addStateDidChangeListener { _, authData in
      if let authData = authData {
        let user = User(authData: authData)
        ApiClient.user = user
        self.showToast(message: "Hi, \(user.name)")
        print("Hi, \(user.name)")
      }
    }
    
    //hide an error lable
    errorLable.alpha = 0
  }
  
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
   
    let error = checkTheFields()
    if let error = error {
      //print an error
      showError(error)
      return
    } else {
      hideError()
    }
    
    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if let error = error {
        self.showError(error.localizedDescription)
        return
      }
      print("result type: ", type(of:result),"result: ", result )
      self.transitionToListOfContacts()
    }
  }
  @IBAction func signUpButtonPressed(_ sender: UIButton) {
    // check the fields
    
    let error = checkTheFields()
    if let error = error {
      //print an error
      showError(error)
      return
    } else {
      hideError()
    }
    
    let email = emailTextField.text!
    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    //creating new account with email and validating password
    let alert = UIAlertController(title: "registration",
                                  message: "enter name you want to register with",
                                  preferredStyle: .alert)
    alert.addTextField { field in
      field.placeholder = "user name"
    }
    alert.addTextField { field in
      field.placeholder = "confirm password"
      field.isSecureTextEntry = true
    }
    alert.addAction(UIAlertAction(title: "Cancel",
                                  style: .cancel,
                                  handler: nil))
    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
      guard let fields = alert.textFields else {
        return
      }
      let name = fields[0].text!
      let confPassword = fields[1].text!
      
      if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        self.showError("invalid name")
        return
      }
      if password != confPassword {
        self.showError("passwords dont match")
        return
      }
      Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
        if error != nil {
          self.showError("error creating user: \(error!.localizedDescription)")
          return
        }
        
        let db = Firestore.firestore()
        let user = User(uid: result!.user.uid, email: result!.user.email ?? "", name: name)
        do {
          try db.collection("users").document(user.uid).setData(from: user)
        } catch {
          debugPrint("user save fail")
        }
        self.transitionToListOfContacts()
      }
    }))
    self.present(alert, animated: true, completion: nil)
    
    
    
  }
  
  func transitionToListOfContacts() {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "ContactsList") as! UINavigationController
    vc.modalPresentationStyle = .fullScreen
    self.present( vc , animated: false, completion: nil)
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
