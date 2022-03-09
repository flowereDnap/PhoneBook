//
//  NameFieldDelegate.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//


import UIKit

class NameFieldDelegate: NSObject, UITextFieldDelegate {
  
  var parentView: ContactViewController
  
  init (parentView: ContactViewController) {
    self.parentView = parentView
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    parentView.dataChanged = true
    return true
  }
  
  func callWrongInputAllert() {
    let alert = UIAlertController(title: "wrong input",
                                  message: "",
                                  preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "ok",
                                  style: UIAlertAction.Style.default,
                                  handler: nil))
    parentView.present(alert, animated: true, completion: nil)
  }
}
