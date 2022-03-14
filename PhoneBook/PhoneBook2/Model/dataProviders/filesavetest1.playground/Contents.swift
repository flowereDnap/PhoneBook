import UIKit




public enum Types: String , Codable{
  case image
  case name
  case number
  case date
  
  func getPrev()->Types?{
    switch self {
    case .image:
      return nil
    case .name:
      return .image
    case .number:
      return .name
    case .date:
      return nil
    }
  }
  
  func defaultValue()->Any{
    switch self {
    case .image:
      return UIImage(systemName: "face.smiling")!
    case .name:
      return ""
    case .number:
      return ""
    case .date:
      return Date()
    }
  }
}



public class ContactField: Codable{
  
  private enum CodingKeys: String, CodingKey {
          case position
          case type
          case lable
          case valueAsData
      }
  
  var position: Int
  var type: Types = .name
  var lable: String
  var value: Any? {
    set {
      let value: Any = newValue ?? type.defaultValue()
      switch type {
      case .image:
        valueAsData = (value as! UIImage).pngData()!
      case .name:
        valueAsData = Data((value as! String).utf8)
      case .number:
        valueAsData = Data((value as! String).utf8)
      case .date:
        valueAsData = withUnsafeBytes(of: (newValue as! Date).timeIntervalSinceReferenceDate) { Data($0) }
      }
    }
    get {
      switch type {
      case .name:
        return String(decoding: valueAsData, as: UTF8.self)
      case .number:
        return String(decoding: valueAsData, as: UTF8.self)
      case .image:
        return UIImage(data: valueAsData)
      case .date:
        return valueAsData.withUnsafeBytes {
            $0.load(as: Int.self)
        }
      }
  }
  }
  var valueAsData: Data!
  
  init(position:Int = -1, type: Types, lable: String? = nil, value: Any?) {
    self.position = position
    self.type = type
    if let lable = lable {
      self.lable = lable
    } else {
      self.lable = type.rawValue
    }
    self.value = value
  }
}

protocol Copyable {
  init(instance: Self)
}

extension Copyable {
  func copy() -> Self {
    return Self.init(instance: self)
  }
}

public class Contact: Codable, Copyable{
  required init(instance: Contact) {
    self.id = instance.id
    self.dateOfCreation = instance.dateOfCreation
    self.mainFields = instance.mainFields
    self.otherFields = instance.otherFields
  }
  
  
  private enum CodingKeys: String, CodingKey {
    case id, dateOfCreation, mainFields, otherFields
  }
  
  var id: String
  let dateOfCreation: Date
  var mainFields: [ContactField] = []
  var otherFields: [ContactField] = []
  var searchFoundIn: NSAttributedString?
  
  func getPositionOfLast(inMainFields:Bool, type: Types)->Int{
    if inMainFields{
      //if fields of type exist get last
      guard let result: Int = self.mainFields.last(where: {$0.type == type})?.position else {
        //if previous type exists
        if let newType = type.getPrev() {
          return getPositionOfLast(inMainFields: true, type: newType)
        } else {
          //there is no cells return 0
          return 0
        }
      }
      return result
    } else {
      guard let result: Int = self.otherFields.last(where: {$0.type == type})?.position else {
        if let newType = type.getPrev() {
          return getPositionOfLast(inMainFields: false, type: newType)
        } else {
          return 0
        }
      }
      return result
    }
  }
  
  func sort (){
    self.mainFields.sort { first, second in
      first.position < second.position
    }
    self.otherFields.sort { first, second in
      first.position < second.position
    }
  }
  
  init(mainFields:[ContactField]? = nil, otherFields: [ContactField]? = nil) {
    self.id = UUID().uuidString
    self.dateOfCreation = Date()
    if let mainFields = mainFields {
      self.mainFields = mainFields
    } else {
      let imageField = ContactField(position: 0,
                                    type: .image,
                                    value: nil)
      let nameField = ContactField(position: 1,
                                   type: .name,
                                   value: "")
      let numberField = ContactField(position: 2,
                                     type: .number,
                                     value: "")
      self.mainFields.append(imageField)
      self.mainFields.append(nameField)
      self.mainFields.append(numberField)
    }
    if let otherFields = otherFields {
      self.otherFields = otherFields
    }
  }

}


/*

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
      throw Error.invalidfDirectory
    }
    
    if fileManager.fileExists(atPath: url.absoluteString) {
      throw Error.fileAlreadyExists
    }
    do {
      //проверяем ссылку
      //print("in save do, url: ", url)
      //записываем в файл
      try data.write(to: url, options: .atomic)
      //достаю обратно
      //let test = try Data(contentsOf: url)
      //print("in save do, test data: ", test)
      //проверил работает ли конвертация из даты в мой тип
      //let testC =  test.withUnsafeBytes {
      //   $0.load(as: Array<Contact>.self)}.first! as Contact
    } catch {
      debugPrint(error)
      throw Error.writtingFailed
    }
  }
  
  func makeURL(forFileNamed fileName: String) -> URL? {
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
  
}*/
/*
let fileManager = FileManager()
let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("test_new")
let str = "asdasdasd"
let data = withUnsafeBytes(of: str) { Data($0) }

print(data)
do{
  //try data.write(to: url, options: .atomic)
  let readD = try Data(contentsOf: url)
  print(readD.withUnsafeBytes {
    $0.load(as: String.self)
  })
} catch {
  
}


let str2 = Contact()
print(str2.id)
let data2 = withUnsafeBytes(of: str2) { Data($0) }
print(data2)
do{
  try data2.write(to: url2, options: .atomic)
  
  let readD2 = try Data(contentsOf: url2)
  
  let cont = readD2.withUnsafeBytes {
    $0.load(as: Contact.self)
  }
  cont.id = "spoi"
  
  print(dump(readD2.withUnsafeBytes {
    $0.load(as: Contact.self)
  }))

  print(1)
} catch {
  print(2)
}
*/
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let myCont = Contact()
let dataJSON = try! encoder.encode(myCont)

let fileManager = FileManager()
let url2 = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("test_json")

do{
  try dataJSON.write(to: url2, options: .atomic)
  
  let readD2 = try Data(contentsOf: url2)
  
  let decoder = JSONDecoder()
  let cont = try decoder.decode(Contact.self, from: readD2)
  print(dump(cont))
} catch {
  print(2)
}

