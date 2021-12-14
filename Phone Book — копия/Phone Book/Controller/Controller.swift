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
    
    
    public func addContact(contact:Contact)->(Bool){
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: String(contact.number.dropFirst(1)))) && contact.number.first == "+"{
            Model.data.append(contact)
            return true
        }
        else{
            /*let alert = UIAlertController(title: "wrong number ", message: "(use only digits)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            UIApplication.getTopViewController()?.present(alert, animated: true, completion: nil)*/
            print("case 1")
            return false
        }
        
    }
    
    func getContact(Id: Int) -> Contact{
        return Model.data[Id]
    }

    func updCurrentContact(contact: Contact)->(Bool){
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: String(contact.number.dropFirst(1)))) && contact.number.first == "+"{
            Model.data[Model.currentContactId] = contact
            return true
        }
        else{
            /*let alert = UIAlertController(title: "wrong number ", message: "(use only digits)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            UIApplication.getTopViewController()?.present(alert, animated: true, completion: nil)*/
            print("case 1")
            return false
        }
        
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

