//
//  MailFieldDelegate.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//



import UIKit

class MailFieldDelegate: NSObject, UITextFieldDelegate {
  
  weak var parentView: ContactViewController?
  
  init (parentView: ContactViewController) {
    self.parentView = parentView
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: string)
    parentView?.dataChanged = result
    if !result {
      callWrongInputAllert()
    }
    return result
  }
  
  func callWrongInputAllert() {
    let alert = UIAlertController(title: "Wrong input",
                                  message: "Email is invalid",
                                  preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok",
                                  style: UIAlertAction.Style.default,
                                  handler: nil))
    parentView?.present(alert, animated: true, completion: nil)
  }
}
