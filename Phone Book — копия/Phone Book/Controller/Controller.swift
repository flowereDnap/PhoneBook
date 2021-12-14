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
    func numberCheck(number:String)->Bool{
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: String(number.dropFirst(1)))) && (number.first == "+" || number.first?.isNumber ?? true){
            return true
        }
        else{
            return false
        }
    }
    
     func addContact(contact:Contact){
            Model.data.append(contact)
    }
    
    func getContact(Id: Int) -> Contact{
        return Model.data[Id]
    }

    func updCurrentContact(contact: Contact){
            Model.data[Model.currentContactId] = contact     
    }
    
    func deleteContact(Id:Int){
        Model.data.remove(at: Id)
    }
}


extension UIApplication {

    static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
// How to use

