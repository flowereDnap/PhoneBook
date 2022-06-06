//
//  String.swift
//  PhoneBook2
//
//  Created by User on 06.06.2022.
//

import Foundation

extension String {
  func capitalizingFirstLetter() -> String {
       return prefix(1).uppercased() + self.dropFirst()
     }

     mutating func capitalizeFirstLetter() {
       self = self.capitalizingFirstLetter()
     }
}
