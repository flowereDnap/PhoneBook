//
//  PasswordChange.swift
//  PhoneBook2
//
//  Created by User on 07.04.2022.
//

import UIKit
import FirebaseAuth

class PasswordChangeViewController: UIViewController {

  
  func getView() -> UIViewController {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: PasswordChangeViewController = mainStoryboard.instantiateViewController(withIdentifier: "PasswordChange") as! PasswordChangeViewController
    
    return vc
  }
  
  @IBOutlet var oldPassField: UITextField!
  @IBOutlet var newPassField: UITextField!
  @IBOutlet var newPassConfirmField: UITextField!
  @IBOutlet var saveBtt: UIButton!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    oldPassField.isSecureTextEntry = true
    saveBtt.setUpStyle()
        // Do any additional setup after loading the view.
    }

 
  @IBAction func confirmBtt(_ sender: UIButton){
    if oldPassField.text! != ApiClient.user!.password {
        self.showToast(message: "Wrong password")
        return
    }
    let newPass = newPassField.text!
    if !LoginViewController.isPasswordValid(newPass) {
      self.showToast(message: "Invalid new password")
      return
    }
    if newPass != newPassConfirmField.text! {
      self.showToast(message: "New passwords don't match")
      return
    }
    Auth.auth().currentUser?.updatePassword(to: newPass, completion: { error in
      debugPrint(error?.localizedDescription ?? "")
    })
    ApiClient.user!.password = newPass
    self.dismiss(animated: true, completion: nil)
  }
  @IBAction func dismissBtt(_ sender: UIButton){
    if newPassField.text! != "" || newPassConfirmField.text! != "" {
      // cancel editing existing one
      let alert = UIAlertController(title: "Cancel",
                                    message: "Discard all changes?",
                                    preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "Back",
                                    style: UIAlertAction.Style.destructive,
                                    handler: { _ in
        self.dismiss(animated: true, completion: nil)
      }))
      alert.addAction(UIAlertAction(title: "Keep editing",
                                    style: UIAlertAction.Style.default,
                                    handler: nil))
      
      self.present(alert, animated: true, completion: nil)
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
