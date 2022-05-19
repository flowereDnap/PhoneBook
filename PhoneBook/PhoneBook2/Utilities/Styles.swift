//
//  Styles.swift
//  PhoneBook2
//
//  Created by User on 09.04.2022.
//

import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

extension UIButton {
  func setUpStyle(){
    self.setTitleColor(UIColor.black, for: .normal)
    self.backgroundColor = .clear
    self.layer.cornerRadius = 4.0
  }
}
extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}


