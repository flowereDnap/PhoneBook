//
//  Controller.swift
//  Phone Book
//
//  Created by User on 31.10.2021.
//

import Foundation
import UIKit

//  FIXME: What does it mean class Controller?



class Controller {
    
    var currentContactId:Int{
        set(newId){
            Model.currentContactId = newId
        }
        get{
            return Model.currentContactId
        }
    }
    var count:Int{
        return Model.data.count
    }
    
    //  FIXME: as usual, we don't name methods from the uppercase letter
    public func addContact(contact:Contact)->(){
        Model.data.append(contact)
    }
    
    func getContact(Id: Int) -> Contact{
        return Model.data[Id]
    }

    func updCurrentContact(contact: Contact){
        Model.data[Model.currentContactId] = contact
    }
    
    func deleteCurrentContact(){
        Model.data.remove(at: Model.currentContactId)
    }
}
