//
//  ModelCore+CoreDataProperties.swift
//  Phone Book
//
//  Created by User on 28.02.2022.
//
//

import Foundation
import CoreData


extension ModelCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModelCore> {
        return NSFetchRequest<ModelCore>(entityName: "ModelCore")
    }

    @NSManaged public var contacts: NSSet?

}

// MARK: Generated accessors for contacts
extension ModelCore {

    @objc(addContactsObject:)
    @NSManaged public func addToContacts(_ value: ContactCore)

    @objc(removeContactsObject:)
    @NSManaged public func removeFromContacts(_ value: ContactCore)

    @objc(addContacts:)
    @NSManaged public func addToContacts(_ values: NSSet)

    @objc(removeContacts:)
    @NSManaged public func removeFromContacts(_ values: NSSet)

}

extension ModelCore : Identifiable {

}
