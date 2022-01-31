

import UIKit

class ContactViewControllerV2: UITableViewController{
  typealias ViewMode = ContactTableViewController.ViewMode
  enum TextFields{
    static let nameField = "nameField"
    static let numberField = "numberField"
  }
  
  var viewMode: ViewMode = .view
  weak var controller: ContactManager?
  var currentContact :Contact?
 
  var ContactTableView: ContactTableViewController?
  var dataChanged: Bool = false {
    didSet{
      if dataChanged {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
      } else {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
      }
    }
  }
  
  static func getView(viewMode: ViewMode, controller: ContactManager, currentContact: Contact?) -> ContactViewControllerV2 {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: ContactViewControllerV2 = mainStoryboard.instantiateViewController(withIdentifier: "ContactSceneV2") as! ContactViewControllerV2
    vc.viewMode = viewMode
    vc.controller = controller
    vc.currentContact = currentContact
    return vc
  }
  
  override func viewWillAppear(_ animated: Bool) {
    dataChanged = false
    var rightButton: UIBarButtonItem
    var leftButton: UIBarButtonItem
    switch viewMode {
    case .edit:
      rightButton = UIBarButtonItem.init(title: "Save",
                                         style: .done,
                                         target: self,
                                         action: #selector(saveButtonPressed))
      rightButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .disabled)
      rightButton.isEnabled = false
      
      leftButton = UIBarButtonItem.init(title: "Cancel",
                                        style: .done,
                                        target: self,
                                        action: #selector(editCancelButtonPressed))
  
     
    case .view:
      rightButton = UIBarButtonItem.init(title: "Edit",
                                         style: .done,
                                         target: self,
                                         action: #selector(editButtonPressed))
      leftButton = UIBarButtonItem.init(title: "Back",
                                        style: .done,
                                        target: self,
                                        action: #selector(backButtonPressed))
 
    case .create:
      rightButton = UIBarButtonItem.init(title: "Create",
                                         style: .done,
                                         target: self,
                                         action: #selector(createButtonPressed))
      leftButton = UIBarButtonItem.init(title: "Back",
                                        style: .done,
                                        target: self,
                                        action: #selector(backButtonPressed))
      
      
    }
    self.navigationItem.rightBarButtonItem = rightButton
    self.navigationItem.leftBarButtonItem = leftButton
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  
  }
  
  //MARK: -nav bar button actions
  @objc func editCancelButtonPressed(_ sender: UIButton){
    self.viewMode = .view
    viewWillAppear(false)
  }
  
  @objc func backButtonPressed(_ sender: UIButton){
    if !dataChanged {
      self.navigationController?.popViewController(animated: true)
    } else {
      let alert = UIAlertController(title: "Changes not saved",
                                    message: "discard all changes?",
                                    preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "Keep editing",
                                    style: UIAlertAction.Style.default,
                                    handler: nil))
      alert.addAction(UIAlertAction(title: "Yes",
                                    style: UIAlertAction.Style.destructive,
                                    handler: { _ in
        self.navigationController?.popViewController(animated: true)
      }))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @objc func createButtonPressed(_ sender: UIButton) {
    if dataChanged {
      let contact: Contact = Contact(name: ContactTableView!.nameField.text!,
                                     number: ContactTableView!.numberField.text ?? "",
                                     image: profilePicture.image,
                                     fields: [])
      controller!.addContact(contact: contact)
      currentContact = contact
      viewMode = .view
      viewWillAppear(false)
    } else {
      let alert = UIAlertController(title: "Empty contact",
                                    message: "You can't save empty contact",
                                    preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "Ok",
                                    style: UIAlertAction.Style.default,
                                    handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
    
   
  }
  
  @IBAction func editButtonPressed(_ sender: UIButton) {
    viewMode = .edit
    viewWillAppear(false)
  }
  
  @objc func saveButtonPressed(_ sender: UIButton) {
    controller!.updContact(Id: (currentContact?.id)!,
                           name: ContactTableView!.nameField.text,
                           number: ContactTableView!.numberField.text,
                           image: profilePicture.image)
    viewMode = .view
    currentContact = controller!.getContact(Id: (currentContact?.id)!)
    viewWillAppear(false)
  }
}






extension ContactViewControllerV2 {
  override func numberOfSections(in tableView: UITableView) -> Int {
     return 2
   }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     switch section{
     case 0:
       return 3
       return 0
     case 1:
       return currentContact?.fields.filter{$0.toShow}.count ?? 3 - 3
     default:
       return 0
     }
   }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let item = currentContact?.fields.filter{$0.toShow}.first{$0.position == indexPath.row}
     switch item?.type{
     case .mail:
       let cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.identifier, for: indexPath) as! StringTableViewCell
       cell.setUpCell(parentView: self, item: item!)
       return cell
     case .dateOfBirth:
       let cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.identifier, for: indexPath) as! StringTableViewCell
       cell.setUpCell(parentView: self, item: item!)
       return cell
     case .name:
       let cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.identifier, for: indexPath) as! StringTableViewCell
       cell.setUpCell(parentView: self, item: item!)
       return cell
     case .number:
       let cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCell.identifier, for: indexPath) as! StringTableViewCell
       cell.setUpCell(parentView: self, item: item!)
       return cell
     case .image:
       let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageTableViewCell.identifier, for: indexPath) as! ProfileImageTableViewCell
       cell.setUpCell(parentView: self, item: item!)
       return cell
     default:
       return UITableViewCell()
   }
   }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section{
    case 0:
      return "Main info"
    case 1:
      return "Additional"
    default:
      return ""
    }
  }
   
  
}
