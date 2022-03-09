//
//  ContactCore+CoreDataProperties.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//
//

import Foundation
import CoreData


extension ContactCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactCore> {
        return NSFetchRequest<ContactCore>(entityName: "ContactCore")
    }

    @NSManaged public var dateOfCreation: Date
    @NSManaged public var id: String
    @NSManaged public var mainFields: NSSet?
    @NSManaged public var otherFields: NSSet?

}

// MARK: Generated accessors for mainFields
extension ContactCore {

    @objc(addMainFieldsObject:)
    @NSManaged public func addToMainFields(_ value: ContactFieldCore)

    @objc(removeMainFieldsObject:)
    @NSManaged public func removeFromMainFields(_ value: ContactFieldCore)

    @objc(addMainFields:)
    @NSManaged public func addToMainFields(_ values: NSSet)

    @objc(removeMainFields:)
    @NSManaged public func removeFromMainFields(_ values: NSSet)

}

// MARK: Generated accessors for otherFields
extension ContactCore {

    @objc(addOtherFieldsObject:)
    @NSManaged public func addToOtherFields(_ value: ContactFieldCore)

    @objc(removeOtherFieldsObject:)
    @NSManaged public func removeFromOtherFields(_ value: ContactFieldCore)

    @objc(addOtherFields:)
    @NSManaged public func addToOtherFields(_ values: NSSet)

    @objc(removeOtherFields:)
    @NSManaged public func removeFromOtherFields(_ values: NSSet)

}

extension ContactCore : Identifiable {

}
