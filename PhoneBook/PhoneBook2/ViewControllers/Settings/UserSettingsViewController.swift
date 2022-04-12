//
//  UserSettingsViewController.swift
//  PhoneBook2
//
//  Created by User on 21.03.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class UserSettingsViewController: UIViewController {
  
  func getView() -> UIViewController {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: UserSettingsViewController = mainStoryboard.instantiateViewController(withIdentifier: "UserSettings") as! UserSettingsViewController
    
    return vc
  }
  
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  }
  @IBOutlet var userNameLable: UILabel!
  @IBOutlet var emailLable: UILabel!

  @IBAction func editUserNameBtt(_ sender: UIButton){
    let vc = UserChangeViewController().getView( changeType: .name)
      self.present(vc , animated: true, completion: nil)
  }
  @IBAction func editEmailBtt(_ sender: UIButton){
    let vc = UserChangeViewController().getView( changeType: .email)
      self.present(vc , animated: true, completion: nil)
  }
  @IBAction func changePasswordBtt(_ sender: UIButton){
    let vc = PasswordChangeViewController().getView()
      self.present(vc , animated: true, completion: nil)
  }
 
  @IBAction func backBtt(_ sender: UIButton){
      self.dismiss(animated: true, completion: nil)
  }
 
  override func viewWillAppear(_ animated: Bool) {
    
    userNameLable.text = DataManager.user.name
    emailLable.text = DataManager.user.email
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
