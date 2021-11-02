//
//  Model.swift
//  Phone Book
//
//  Created by User on 31.10.2021.
//

import Foundation

public struct Contact{
    public var name: String
    public var number: String
}

class Model{
    static public var data:[Contact] = [Contact(name:"lala",number: " h")]
    public static var currentContactId:Int = 0
}
