

import UIKit

class ContactViewControllerV2: UITableViewController {
  enum ViewMode {
    case edit
    case view
    case create
  }
  
  var viewMode: ViewMode = .view
  weak var controller: ContactManager?
  var currentContact :Contact?
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
    if let currentContact = currentContact {
      vc.currentContact = currentContact
    } else {
      vc.currentContact = Contact(name: nil, number: nil, image: nil)
    }
    
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
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView?.register(StringTableViewCellV2.nib, forCellReuseIdentifier: StringTableViewCellV2.identifier)
    tableView?.register(ProfileImageTableViewCell.nib, forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
         tableView.estimatedRowHeight = 44
    
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
      let contact: Contact = Contact(name: currentContact?.name ?? "",
                                     number: currentContact?.number ?? "",
                                     image: currentContact?.image,
                                     mainFields: currentContact?.mainFields ?? [],
                                     additionalFields: currentContact?.additionalFields ?? [])
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
                           name: currentContact?.name,
                           number: currentContact?.number,
                           image: currentContact?.image,
                           mainFields: currentContact?.mainFields,
                           additionalFields: currentContact?.additionalFields)
    viewMode = .view
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
      return currentContact?.mainFields.filter{$0.toShow}.count ?? 0
    case 1:
      return currentContact?.additionalFields.filter{$0.toShow}.count ?? 0
    default:
      return 0
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var item: ContactField?
    switch indexPath.section{
    case 0:
      item = currentContact?.mainFields.filter{$0.toShow}.first{$0.position == indexPath.row}
    case 1:
      item = currentContact?.additionalFields.filter{$0.toShow}.first{$0.position == indexPath.row}
    default:
      break
    }
    
    switch item?.type{
    case .mail:
      let cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCellV2.identifier, for: indexPath) as! StringTableViewCellV2
      cell.setUpCell(parentView: self, item: item!)
      return cell
    case .dateOfBirth:
      let cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCellV2.identifier, for: indexPath) as! StringTableViewCellV2
      cell.setUpCell(parentView: self, item: item!)
      return cell
    case .name:
      let cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCellV2.identifier, for: indexPath) as! StringTableViewCellV2
      cell.setUpCell(parentView: self, item: item!)
      return cell
    case .number:
      let cell = tableView.dequeueReusableCell(withIdentifier: StringTableViewCellV2.identifier, for: indexPath) as! StringTableViewCellV2
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
