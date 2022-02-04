import UIKit


public struct ImageWrapper: Codable {
  var imgData: Data?
  static private let contactDefaultImage: UIImage = UIImage(named: "contactDefaultImage")!
  var image: UIImage? {
    get {
      if let imgData = imgData {
        return UIImage(data: imgData)
      }
      return ImageWrapper.contactDefaultImage
    }
    set {
      guard let img = newValue else {
        imgData = nil
        return
      }
      imgData = img.pngData()!
    }
  }
  init(image: UIImage?) {
    self.image = image
  }
}

public enum ContactFieldValue: Codable {
  case id(Int)
  case name(String)
  case number(String)
  case mail(String)
  case date(Date)
  case image(ImageWrapper)
}

enum Labels:String, Codable{
    case id = "id"
    case name
    case number
    case dateOfCreation = "date of creation"
    case image
    case mail
    case dateOfBirth = "date of birth"
  
}



public struct ContactField:Codable{
  var lable:String?
  let type: Labels
  var toShow: Bool {
    switch type {
    case .id:
      return false
    case .name:
      return true
    case .number:
      return true
    case .dateOfCreation:
      return false
    case .image:
      return true
    case .mail:
      return true
    case .dateOfBirth:
      return true
    default:
      return false
    }
  }
  var position: Int = -1
  var value: ContactFieldValue?
  init (lable: String?, type: Labels, position:Int = -1, value: ContactFieldValue?){
    self.lable = lable
    self.position = position
    self.value = value
    self.type = type
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

struct Contact: Codable {
  var mainFields: [ContactField]
  var additionalFields: [ContactField]
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
  
  init(name:String?, number:String?, image:UIImage?, mainFields:[ContactField]? = nil, additionalFields: [ContactField] = []){
    self.name = name ?? ""
    self.number = number ?? ""
    self.creationDate = Date()
    self.id = Model.id
    self.additionalFields = []
    if let mainFields = mainFields {
      self.mainFields = mainFields
    } else {
    self.mainFields = []
    let nameField = ContactField(lable: Labels.name.rawValue,
                                 type: Labels.name,
                                 position: 1,
                                 value: ContactFieldValue.name(name ?? ""))
    self.mainFields.append(nameField)
    let numberField = ContactField(lable: Labels.number.rawValue,
                                   type: Labels.number,
                                   position: 2,
                                   value: ContactFieldValue.number(number ?? ""))
    self.mainFields.append(numberField)
    let imageField = ContactField(lable: Labels.image.rawValue,
                                  type: Labels.image,
                                  position: 0,
                                  value: ContactFieldValue.image(ImageWrapper(image: image)))
    self.mainFields.append(imageField)
    let dateField = ContactField(lable: Labels.dateOfCreation.rawValue,
                                 type: Labels.dateOfCreation,
                                 value: ContactFieldValue.date(Date()))
    self.mainFields.append(dateField)
    let idField = ContactField(lable: Labels.id.rawValue,
                               type: Labels.id,
                               value: ContactFieldValue.id(self.id!))
    self.mainFields.append(idField)
    }
    self.additionalFields.append(contentsOf: additionalFields)
    self.image = image
  }
  
}


protocol ProfileViewModelItem {
  var type: ProfileViewModelItemType { get }
  var rowCount: Int { get }
  var sectionTitle: String  { get }
}

extension ProfileViewModelItem {
  var rowCount: Int {
    return 1
  }
}

class ProfileViewModelNameAndPictureItem: ProfileViewModelItem {
  var type: ProfileViewModelItemType {
    return .nameAndPicture
  }
  var sectionTitle: String {
    return "Main Info"
  }
  var pictureUrl: String
  var userName: String
  init(pictureUrl: String, userName: String) {
    self.pictureUrl = pictureUrl
    self.userName = userName
  }
}

enum ProfileViewModelItemType {
  case nameAndPicture
  case about
  case email
  case friend
  case attribute
}

class ProfileViewModelAboutItem: ProfileViewModelItem {
  var type: ProfileViewModelItemType {
    return .about
  }
  var sectionTitle: String {
    return "About"
  }
  var about: String
  
  init(about: String) {
    self.about = about
  }
}
class ProfileViewModelEmailItem: ProfileViewModelItem {
  
  var type: ProfileViewModelItemType {
    return .email
  }
  var sectionTitle: String {
    return "Email"
  }
  var email: String
  init(email: String) {
    self.email = email
  }
}
class ProfileViewModelAttributeItem: ProfileViewModelItem {
  var type: ProfileViewModelItemType {
    return .attribute
  }
  var sectionTitle: String {
    return "additional"
  }
  
  var rowCount: Int {
    return fields.count
  }
  var fields: [ContactField]
  init(fields: [ContactField]) {
    self.fields = fields
  }
}

