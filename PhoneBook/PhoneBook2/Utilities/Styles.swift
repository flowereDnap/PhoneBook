//
//  Styles.swift
//  PhoneBook2
//
//  Created by User on 09.04.2022.
//

import SwiftUI


extension UITextField {
    func setPreferences() {
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 20
        // etc.
    }
}

extension UIButton {
  func setPreferences() {
    let bgColor: UIColor = .black
    let cornerRadius: CGFloat = 8
    
    self.setTitleColor(.white, for: .normal)
    self.layer.borderWidth = 0.5
    self.layer.borderColor = UIColor.gray.cgColor
    self.backgroundColor = bgColor
    self.layer.cornerRadius = 6
    self.layer.masksToBounds = true
    
               self.clipsToBounds = true
               
  }
}
