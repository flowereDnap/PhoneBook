import UIKit


public struct ImageWrapper: Codable, Hashable {
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

public enum ContactFieldValue: Codable , Hashable{
  case id(String)
  case name(String)
  case number(String)
  case mail(String)
  case date(Date)
  case image(ImageWrapper)
  
}

enum Labels:String, Codable, Hashable{
  case id = "id"
  case name
  case number
  case dateOfCreation = "date of creation"
  case image
  case mail
  case dateOfBirth = "date of birth"
  
}

extension ContactFieldValue {
  func value() -> Any{
    if case let .id(value) = self{
      return value
    }
    if case let .name(value) = self{
      return value
    }
    if case let .number(value) = self{
      return value
    }
    if case let .mail(value) = self{
      return value
    }
    if case let .image(value) = self{
      return value
    }
    if case let .date(value) = self{
      return value
    }
    return 0
  }
}


public struct ContactField: Codable, Hashable{
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
    }
  }
  var position: Int = -1
  
  mutating func move(back:Bool = false){
    if back {
      position = position - 1
    } else {
      position = position + 1
    }
  }
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
  static let contactListKey = "contactsList3"
  static let idKey = "id"
  static var id: String{
    get{
      return UUID().uuidString
    }
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
}

class Contact: Codable,Copyable{
  
  private enum CodingKeys: String, CodingKey {
          case mainFields, additionalFields
      }
  var mainFields: [ContactField]
  var additionalFields: [ContactField]
  var searchFoundIn: NSAttributedString?
  
  func sort (){
    self.mainFields.sort { first, second in
      first.position < second.position
    }
    self.additionalFields.sort { first, second in
      first.position < second.position
    }
  }
  init(mainFields:[ContactField]? = nil, additionalFields: [ContactField] = []) {
    self.additionalFields = []
    if let mainFields = mainFields {
      self.mainFields = mainFields
    } else {
      self.mainFields = []
      let nameField = ContactField(lable: Labels.name.rawValue,
                                   type: Labels.name,
                                   position: 1,
                                   value: ContactFieldValue.name(""))
      self.mainFields.append(nameField)
      let numberField = ContactField(lable: Labels.number.rawValue,
                                     type: Labels.number,
                                     position: 2,
                                     value: ContactFieldValue.number(""))
      self.mainFields.append(numberField)
      let imageField = ContactField(lable: Labels.image.rawValue,
                                    type: Labels.image,
                                    position: 0,
                                    value: ContactFieldValue.image(ImageWrapper(image:nil)))
      self.mainFields.append(imageField)
      let dateField = ContactField(lable: Labels.dateOfCreation.rawValue,
                                   type: Labels.dateOfCreation,
                                   value: ContactFieldValue.date(Date()))
      self.mainFields.append(dateField)
      let idField = ContactField(lable: Labels.id.rawValue,
                                 type: Labels.id,
                                 value: ContactFieldValue.id(Model.id))
      self.mainFields.append(idField)
    }
    self.additionalFields.append(contentsOf: additionalFields)
    self.sort()
  }
  required init(instance: Contact) {
          self.mainFields = instance.mainFields
          self.additionalFields = instance.additionalFields
          self.searchFoundIn = instance.searchFoundIn
    print(self.mainFields)
    }
  
}

// MARK: - <Hashable>
extension Contact: Hashable {
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self))
  }
}

// MARK: - <Equatable>
extension Contact: Equatable {
  
  public static func ==(lhs: Contact, rhs: Contact) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
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

protocol ContactsDataProtocol {
  var allContacts: [Contact] { get set}
  var id: String {get}
  
}


class UserDefaultsDataProvide: ContactsDataProtocol {
  var id: String = {
    return UUID().uuidString
  }()
  private var loaded_data: [Contact]? = nil
  var allContacts: [Contact] {
    get {
      
      if let loaded_data = loaded_data {
        return loaded_data
      }
      else {
        var data2: [Contact]?
        if let mydata = UserDefaults.standard.value(forKey:Model.contactListKey) as? Data {
          data2 = try? PropertyListDecoder().decode(Array<Contact>.self, from: mydata)
        }
        loaded_data = data2 ?? []
        return loaded_data!
      }
    }
    set {
      loaded_data = newValue
      UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:Model.contactListKey)
    }
  }
  
}

class FileDataProvider: ContactsDataProtocol {
  
  static private let fileURL: String = "allContacts"
  let fileManager = FilesManager()
  var id: String = {
    return UUID().uuidString
  }()
  
  private var loaded_data: [Contact]? = nil
  var allContacts: [Contact]{
    get {
      
      if let loaded_data = loaded_data {
        return loaded_data
      }
      else {
        var data2: [Contact]?
        do{
          let mydata = try fileManager.read(fileNamed: FileDataProvider.fileURL)
          data2 =  mydata.withUnsafeBytes {
            $0.load(as: Array<Contact>.self)}
        } catch {
          print("data read fail")
        }
        loaded_data = data2 ?? []
        return loaded_data!
      }
    }
    set {
      loaded_data = newValue
      let data = withUnsafeBytes(of: loaded_data) { Data($0) }
      do {
        try fileManager.save(fileNamed: FileDataProvider.fileURL, data: data)
      } catch {
        print("save to file failed")
      }
      
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
    guard fileManager.fileExists(atPath: url.absoluteString) else {
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

class CoreDataProvider: ContactsDataProtocol {
  var allContacts: [Contact] {
    get{
      return []
    }
    set{
      
    }
  }
  
  var id: String = {
    return UUID().uuidString
  }()
}

/*class CoreDataManager {
 static let shared = CoreDataManager()
 private init() {}
 private lazy var persistentContainer: NSPersistentContainer = {
 let container = NSPersistentContainer(name: "Contacts")
 container.loadPersistentStores(completionHandler: { _, error in
 _ = error.map { fatalError("Unresolved error \($0)") }
 })
 return container
 }()
 
 var mainContext: NSManagedObjectContext {
 return persistentContainer.viewContext
 }
 
 func backgroundContext() -> NSManagedObjectContext {
 return persistentContainer.newBackgroundContext()
 }
 }
 */
protocol Copyable {
    init(instance: Self)
}

extension Copyable {
    func copy() -> Self {
        return Self.init(instance: self)
    }
}
