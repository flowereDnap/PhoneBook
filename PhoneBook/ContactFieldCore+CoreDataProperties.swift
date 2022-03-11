//
//  ContactFieldCore+CoreDataProperties.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//
//

import Foundation
import CoreData


extension ContactFieldCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactFieldCore> {
        return NSFetchRequest<ContactFieldCore>(entityName: "ContactFieldCore")
    }

    @NSManaged public var lable: String
    @NSManaged public var position: Int64
    @NSManaged public var typeOfValue: String
    @NSManaged public var valueAsData: Data

}

extension ContactFieldCore : Identifiable {

}
