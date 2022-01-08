import UIKit


public struct SomeImage: Codable {
  
  public let photo: Data
  
  public init(photo: UIImage) {
    self.photo = photo.pngData()!
  }
}

public enum Labels: Codable {
  case id(Int)
  case name(String)
  case number(String)
  case dateOfCreation(Date)
  case image(SomeImage)
}

public struct DefaultValue: Codable {
  public static func getDefault(lable: Labels)->Codable{
    switch lable {
    case .name:
      return ""
    case .number:
      return ""
    case .dateOfCreation:
      return Date()
    case .image:
      return SomeImage(photo: UIImage(named: "contactDefaultImage")!)
    case .id(_):
      return 1
    }
  }
}

public struct ContactField:Codable{
  public let lable: String
  public var value: Labels
  
  /*public init(lable p:Labels){
   switch p {
   case .name(_):
   lable = "name"
   case .number(_):
   lable = "number"
   case .dateOfCreation(_):
   lable = "dateOfCreation"
   case .image(_):
   lable = "image"
   case .id(_):
   lable = "id"
   }
   }*/
}

var test1 = SomeImage(photo: UIImage(named: "sort_icon")!)

struct Contact: Codable {
  var name: String
  var number: String
  var creationDate: Date
  var id: Int?
  var imgData: Data?
  static private let contactDefaultImage: UIImage = UIImage(named: "contactDefaultImage")!
  var image: UIImage? {
    get {
      if let imgData = imgData {
        return UIImage(data: imgData)
      }
      return Contact.contactDefaultImage
    }
    set {
      guard let img = newValue else {
        imgData = nil
        return
      }
      imgData = img.pngData()!
    }
  }
}

class Model {
  private static var loaded_data: [Contact]? = nil
  static let contactListKey = "contactsList2"
  static let idKey = "id"
  static var id: Int {
      let mydata = UserDefaults.standard.value(forKey: idKey) as? NSInteger
      UserDefaults.standard.set((mydata ?? 0) + 1, forKey: idKey)
      return mydata ?? 0
  }
  static public var data: [Contact] {
    get {
      
      if let loaded_data = loaded_data {
        return loaded_data
      }
      else {
        var data2: [Contact]?
        if let mydata = UserDefaults.standard.value(forKey:contactListKey) as? Data {
          data2 = try? PropertyListDecoder().decode(Array<Contact>.self, from: mydata)
        }
        loaded_data = data2 ?? []
        return loaded_data!
      }
    }
    set {
      loaded_data = newValue
      UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:contactListKey)
    }
  }
  public static var currentContactId:Int = 0
}

