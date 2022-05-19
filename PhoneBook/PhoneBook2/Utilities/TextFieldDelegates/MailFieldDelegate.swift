//
//  MailFieldDelegate.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//

import UIKit

class MailFieldDelegate: NSObject, UITextFieldDelegate {
  
  weak var parentView: UIViewController?
  
  init (parentView: UIViewController) {
    self.parentView = parentView
  }
  
  func callWrongInputAllert() {
    let alert = UIAlertController(title: "wrong input",
                                  message: "",
                                  preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "ok",
                                  style: UIAlertAction.Style.default,
                                  handler: nil))
    parentView?.present(alert, animated: true, completion: nil)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return true
  }
}

