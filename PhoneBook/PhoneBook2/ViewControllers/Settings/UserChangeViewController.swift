//
//  UserChangeViewController.swift
//  PhoneBook2
//
//  Created by User on 21.03.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserChangeViewController: UIViewController {
  
  enum ChangeType{
    case name
    case email
  }

  var placeholderText: String!
  var value: String!
  var changeType: ChangeType!
  
  func getView(changeType: ChangeType) -> UIViewController {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: UserChangeViewController = mainStoryboard.instantiateViewController(withIdentifier: "UserChange") as! UserChangeViewController
    vc.changeType = changeType
    switch changeType {
    case .name:
      vc.placeholderText = "user name"
      vc.value = DataManager.user.name
    case .email:
      vc.placeholderText = "email"
      vc.value = DataManager.user.email
    }
    
    

    return vc
  }
  
  @IBOutlet var textField: UITextField!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    textField.text = value
        // Do any additional setup after loading the view.
    }

 
  @IBAction func confirmBtt(_ sender: UIButton){
    let new_value = textField.text!
    switch changeType {
    case .name:
      let db = Firestore.firestore()
      let docRef = db.collection("users").document(DataManager.user.uid)
      docRef.setData(["name": new_value])
      DataManager.user.name = new_value
      self.dismiss(animated: true, completion: nil)
    case .email:
      
      if !LoginViewController.isValidEmail(testStr: new_value){
        self.showToast(message: "not valid email")
        return
      }
      Auth.auth().currentUser?.updateEmail(to: new_value) { error in
        debugPrint(error?.localizedDescription)
        return
      }
      DataManager.user.email = new_value
      self.dismiss(animated: true, completion: nil)
    default:
      return
    }
     
    
    
  }
  @IBAction func dismissBtt(_ sender: UIButton){
    if textField.text! != value {
      // cancel editing existing one
      let alert = UIAlertController(title: "Cancel",
                                    message: "discard all changes?",
                                    preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "Back",
                                    style: UIAlertAction.Style.destructive,
                                    handler: { _ in
        self.dismiss(animated: false, completion: nil)
      }))
      alert.addAction(UIAlertAction(title: "Keep editing",
                                    style: UIAlertAction.Style.default,
                                    handler: nil))
      
      self.present(alert, animated: true, completion: nil)
    } else {
      self.dismiss(animated: false, completion: nil)
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
