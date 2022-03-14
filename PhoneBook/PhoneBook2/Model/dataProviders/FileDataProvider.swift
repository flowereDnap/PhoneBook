//
//  FileDataProvider.swift
//  PhoneBook2
//
//  Created by User on 11.03.2022.
//


import UIKit

class FileDataProvider: DataProvider {
  let filesManager = FilesManager()
  let encoder = JSONEncoder()
  let decoder = JSONDecoder()
  
  private var loaded_data: [Contact] = []
  var data: [Contact] = []
  
  var dataLoad: [Contact] {
    get {
      do {
        let mydata = try filesManager.read(fileNamed: DataManager.contactListKey)
        let res = try decoder.decode(Array<Contact>.self, from: mydata)
        return res
      } catch {
        debugPrint("load with file failed")
        return []
      }
    }
    set {
      do {
        let dataToSave = try encoder.encode(newValue)
        try filesManager.save(fileNamed: DataManager.contactListKey, data: dataToSave)
      } catch {
      }
    }
  }
  
  init() {
    self.data = dataLoad.map{$0.copy()}
  }
  
  func save() {
    self.dataLoad = self.data
  }
  
  func addContact() -> Contact {
    let newContact = Contact()
    data.append(newContact)
    save()
    return newContact
  }
  
  func updContact(contact: Contact) {
    let changingContact = data.first{$0.id == contact.id}
    changingContact?.mainFields = contact.mainFields
    changingContact?.otherFields = contact.otherFields
  }
  
  func deleteContact(id: String) {
    if let index = data.firstIndex(where:  {$0.id == id}) {
      data.remove(at: index)
      save()
    }
  }
  
  
}


class FilesManager {
  enum Error: Swift.Error {
    case fileAlreadyExists
    case invalidDirectory
    case writtingFailed
    case fileNotExists
    case readingFailed
  }
  let fileManager: FileManager
  init(fileManager: FileManager = .default) {
    self.fileManager = fileManager
  }
  func save(fileNamed: String, data: Data) throws {
    guard let url = makeURL(forFileNamed: fileNamed) else {
      throw Error.invalidDirectory
    }

    if fileManager.fileExists(atPath: url.absoluteString) {
      throw Error.fileAlreadyExists
    }
    do {
      try data.write(to: url)
    } catch {
      debugPrint(error)
      throw Error.writtingFailed
    }
  }
  
  private func makeURL(forFileNamed fileName: String) -> URL? {
    guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return nil
    }
    return url.appendingPathComponent(fileName)
  }
  
  func read(fileNamed: String) throws -> Data {
    
    guard let url = makeURL(forFileNamed: fileNamed) else {
      throw Error.invalidDirectory
    }

    guard fileManager.fileExists(atPath: url.path) else {
     throw Error.fileNotExists
    }
    do {
      return try Data(contentsOf: url)
    } catch {
      debugPrint(error)
      throw Error.readingFailed
    }
  }
  
}
