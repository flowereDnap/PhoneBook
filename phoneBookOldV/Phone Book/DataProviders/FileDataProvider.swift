//
//  FileDataProvider.swift
//  Phone Book
//
//  Created by User on 22.02.2022.
//

import Foundation

class FileDataProvider: ContactsDataProtocol {
  
  static private let fileURL: String = "allContacts"
  let fileManager = FilesManager()
  var id: String = {
    return UUID().uuidString
  }()
  
  private var loaded_data: [Contact] = []
  var allContacts: [Contact] {
    get {
      if !loaded_data.isEmpty {
        return loaded_data
      }
      else {
        var data2: [Contact]?
        do{
          let mydata = try fileManager.read(fileNamed: FileDataProvider.fileURL)
          data2 =  mydata.withUnsafeBytes {
            $0.load(as: Array<Contact>.self)}
        } catch {
          print(error)
        }
        
        loaded_data = data2 ?? []
        return loaded_data
      }
    }
    set {
      
      loaded_data = newValue
      let data = withUnsafeBytes(of: loaded_data) { Data($0) }
      do {
        print("in set")
        try fileManager.save(fileNamed: FileDataProvider.fileURL, data: data)
      } catch {
        print("save to file failed")
      }
    }
  }
  
  var count: Int {
    return loaded_data.count
  }
  
 
  //MARK: -Contact managment
  func addContact(contact: Contact) {
    loaded_data.append(contact)
    save()
  }
  
  func getContact(Id: String) -> Contact {
    return loaded_data[loaded_data.firstIndex(where: { (($0.mainFields.first(where: {$0.type == .id})?.value?.getEmbeddedValue())! as! String) == Id
    })!]
  }
  
  func updContact(Id: String, mainFields: [ContactField]? = nil , additionalFields:[ContactField]?) {
    
    if let mainFields = mainFields {
      getContact(Id: Id).mainFields = mainFields
    }
    if let additionalFields = additionalFields {
      getContact(Id: Id).additionalFields = additionalFields
    }
    save()
  }
  
  
  func deleteContact(Id: String) {
    
    loaded_data.remove(at: loaded_data.firstIndex(where: { (($0.mainFields.first(where: {$0.type == .id})?.value?.getEmbeddedValue())! as! String) == Id
    })!)
    save()
  }
  
  //upd of model
  func save() {
    allContacts = loaded_data
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
      //проверяем ссылку
      print("in save do, url: ", url)
      //записываем в файл
      try data.write(to: url)
      //достаю обратно
      let test = try Data(contentsOf: url)
      print("in save do, test data: ", test)
      //проверил работает ли конвертация из даты в мой тип
      let testC =  test.withUnsafeBytes {
        $0.load(as: Array<Contact>.self)}.first! as Contact
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
