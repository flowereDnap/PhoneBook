//
//  ContactFieldCore+CoreDataProperties.swift
//  Phone Book
//
//  Created by User on 01.03.2022.
//
//

import Foundation
import CoreData


extension ContactFieldCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactFieldCore> {
        return NSFetchRequest<ContactFieldCore>(entityName: "ContactFieldCore")
    }

    @NSManaged public var lable: String?
    @NSManaged public var position: Int64
    @NSManaged public var typeCore: String?
    @NSManaged public var valueCore: NSObject?
    @NSManaged public var valueType: String?

}

extension ContactFieldCore : Identifiable {

}
