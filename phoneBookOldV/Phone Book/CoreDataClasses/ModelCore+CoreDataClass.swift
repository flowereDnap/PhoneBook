//
//  ModelCore+CoreDataClass.swift
//  Phone Book
//
//  Created by User on 28.02.2022.
//
//

import Foundation
import CoreData

@objc(ModelCore)
public class ModelCore: NSManagedObject {
  public var id: String = {
    return UUID().uuidString
  }()
  
}
