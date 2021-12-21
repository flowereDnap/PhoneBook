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
    public var id:Int? = nil
    public var creationDate: Date
}

class Model{
    private static var loaded_data:[Contact]? = nil
    static let contactListKey = "contactsList2"
    static let idKey = "id"
    static var id:Int{
        get{
            let mydata = UserDefaults.standard.value(forKey:idKey) as? NSInteger
            UserDefaults.standard.set((mydata ?? 0) + 1, forKey: idKey)
            return mydata ?? 0
        }
        set{
            
        }
    }
    static public var data:[Contact]{
        get{
    
            if let loaded_data = loaded_data{
                return loaded_data
            }
            else{
                var data2:[Contact]?
                if let mydata = UserDefaults.standard.value(forKey:contactListKey) as? Data {
                    data2 = try? PropertyListDecoder().decode(Array<Contact>.self, from: mydata)
                    
                }
                loaded_data = data2 ?? []
                return loaded_data!
            }
        }
        set{
        
            loaded_data = newValue
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:contactListKey)
            
            
        }
    }
    public static var currentContactId:Int = 0
    
}

