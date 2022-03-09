//
//  NumberFieldDelegate.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//

import UIKit

class NumberFieldDelegate: NSObject, UITextFieldDelegate {
  
  var parentView: UIViewController
  
  init (parentView: UIViewController) {
    self.parentView = parentView
  }
  
  func callWrongInputAllert() {
    let alert = UIAlertController(title: "wrong input",
                                  message: "only 0-9 allowed (first character may be \"+\")",
                                  preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "ok",
                                  style: UIAlertAction.Style.default,
                                  handler: nil))
    parentView.present(alert, animated: true, completion: nil)
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    
    
    if textField.text?.first != "+" {
      let charsNotNumb = string.filter{(char: Character) in
        return !char.isNumber
      }
      if charsNotNumb.count == 0 {
        return true
      } else if charsNotNumb.count > 1 {
        callWrongInputAllert()
        return false
      } else if charsNotNumb.first == "+" {
        if range.location == 0 {
          return true
        }
        callWrongInputAllert()
        return false
      }
    } else {
      let charsNotNumb = string.filter{(char: Character) in return !char.isNumber}
      if charsNotNumb.count == 0{
        return true
      }
    }
    callWrongInputAllert()
    return false
  }
}
