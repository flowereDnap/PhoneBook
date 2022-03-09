//
//  ContactCore+CoreDataProperties.swift
//  Phone Book
//
//  Created by User on 28.02.2022.
//
//

import Foundation
import CoreData


extension ContactCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactCore> {
        return NSFetchRequest<ContactCore>(entityName: "ContactCore")
    }

    @NSManaged public var searchFoundIn: NSAttributedString?
    @NSManaged public var model: ModelCore?
    @NSManaged public var mainFieldsCore: NSSet?
    @NSManaged public var additionalFieldsCore: NSSet?

}

// MARK: Generated accessors for mainFields
extension ContactCore {

    @objc(addMainFieldsObject:)
    @NSManaged public func addToMainFieldsCore(_ value: ContactFieldCore)

    @objc(removeMainFieldsObject:)
    @NSManaged public func removeFromMainFieldsCore(_ value: ContactFieldCore)

    @objc(addMainFields:)
    @NSManaged public func addToMainFieldsCore(_ values: NSSet)

    @objc(removeMainFields:)
    @NSManaged public func removeFromMainFieldsCore(_ values: NSSet)

}

// MARK: Generated accessors for additionalFields
extension ContactCore {

    @objc(addAdditionalFieldsObject:)
    @NSManaged public func addToAdditionalFieldsCore(_ value: ContactFieldCore)

    @objc(removeAdditionalFieldsObject:)
    @NSManaged public func removeFromAdditionalFieldsCore(_ value: ContactFieldCore)

    @objc(addAdditionalFields:)
    @NSManaged public func addToAdditionalFieldsCore(_ values: NSSet)

    @objc(removeAdditionalFields:)
    @NSManaged public func removeFromAdditionalFieldsCore(_ values: NSSet)

}

extension ContactCore : Identifiable {

}
