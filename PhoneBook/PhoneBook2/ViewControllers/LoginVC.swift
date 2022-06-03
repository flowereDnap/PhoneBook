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
  @IBOutlet var settingsButton: UIButton!
  
  let loadingVC = LoadingViewController.getView()
  var parentView: ViewController!
  var loginResponse: Bool = false {
    didSet{
      if loginResponse == true {
        DispatchQueue.global(qos: .userInitiated).async {
        print("order",0)
        if ApiClient.user != nil {
          print("order",2)
          DispatchQueue.global(qos: .userInitiated).sync{
              DataManager.dataProvType = .server
          }
          
        }
        }
      }
      LoadingViewController.hide()
      loginResponse = false
    }
  }
  

  var handle: AuthStateDidChangeListenerHandle?
  
  override func viewWillAppear(_ animated: Bool) {
    passwordTextField.text = nil
    LoadingViewController.parentView = self as UIViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    settingsButton.setImage(UIImage(named: "settingsIcon"), for: .normal)
    settingsButton.imageView?.contentMode = .scaleAspectFit
    settingsButton.showsMenuAsPrimaryAction = true
    settingsButton.menu = makeSettingsMenu()
    
    
    passwordTextField.enablePasswordToggle()
    
    loadingVC.modalPresentationStyle = .overCurrentContext
    loadingVC.modalTransitionStyle = .crossDissolve
    
    //hide an error lable
    errorLable.alpha = 0
  }
  
  func authF()->(){
    //var email: String = ""
    //var password: String = ""

      let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
 
    Auth.auth().signIn(withEmail: email, password: password) { user, error in
      if let error = error {
        DispatchQueue.main.async {
          self.showError(error.localizedDescription)
         }
        self.loginResponse = true
        return
      }
      
      ApiClient.user = User(authData: Auth.auth().currentUser!)
      let db = Firestore.firestore()
      
      let docRef = db.collection("users").document(ApiClient.user!.uid)
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
              ApiClient.user!.name = document.get("name") as! String
            } else {
                print("Document does not exist in cache")
            }
        }
      
      ApiClient.user!.password = password
      
      self.loginResponse = true
      self.showToast(message: "loaded with server")
    }
  }
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
   
    let error = checkTheFields()
    if let error = error {
      showError(error)
      return
    } else {
      hideError()
    }

    print("login0",self.loginResponse)
    DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
      print("order",1)
      LoadingViewController.show()
      LoadingViewController.load(complation: self!.authF)
      print("apiuser1", ApiClient.user)
    
    }
    
   // DispatchQueue.global(qos: .userInitiated).sync {
    //  print(loginResponse)
      //while !loginResponse {
        
      //}
    //}
   
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
  
  func makeSettingsMenu()-> UIMenu{
    let action1 =  UIAction(title: "data provider") { _ in
      let optionMenu = UIAlertController(title: nil,
                                         message: "Choose Option",
                                         preferredStyle: .actionSheet)
      
      for type in DataProv.allCases {
        
        var title = "Save to \(type.rawValue)"
        var isEnabled = true
        if type == DataManager.dataProvType{
          title = "Saved to \(type.rawValue)"
          isEnabled = false
        }
        
        let action = UIAlertAction(title: title,
                                   style: .default) { [self] (UIAlertAction) in
          if type != .server {
            DataManager.dataProvType = type
            self.parentView.setUpView()
            self.showToast(message: "loaded with \(type.rawValue)")
            self.dismiss(animated: true, completion: nil)
          }
        }
        action.isEnabled = isEnabled
        optionMenu.addAction(action)
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      optionMenu.addAction(cancelAction)
      
      self.present(optionMenu, animated: true, completion: nil)
    }
    return UIMenu(title: "Settings",
                  options: .displayInline,
                  children: [action1])
  }
  
}
