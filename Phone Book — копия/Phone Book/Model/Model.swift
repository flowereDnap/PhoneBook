//
//  Model.swift
//  Phone Book
//
//  Created by User on 31.10.2021.
//

import Foundation

public struct Contact: Codable{
    public var name: String
    public var number: String
}

class Model{
    private static var loaded_data:[Contact]? = nil
    static let key = "contacts_list"
    static public var data:[Contact]{
        get{
            if let loaded_data = loaded_data{
                return loaded_data
            }
            else{
                if let mydata = UserDefaults.standard.value(forKey:key) as? Data {
                    let data2:[Contact]? = try? PropertyListDecoder().decode(Array<Contact>.self, from: mydata)
                    loaded_data = data2 ?? []
                }
                
                return loaded_data!
            }
        }
        set{
            
            
            loaded_data = newValue
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:key)
           
        
        }
    }
    public static var currentContactId:Int = 0

}

