//
//  ContactTableViewController.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//

import UIKit

class ContactViewController: UITableViewController {
  enum ViewMode {
    case edit
    case view
    case create
  }
  
  var dataChanged: Bool = false {
    didSet{
      if dataChanged {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
      } else {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
      }
    }
  }
  var viewMode: ViewMode = .view
  private var currentContact: Contact!
  var currentEditingContact: Contact!
  
  static func getView(viewMode: ViewMode, currentContact: Contact) -> ContactViewController {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: ContactViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactScene") as! ContactViewController
    //toDo
    vc.viewMode = viewMode
    vc.currentContact = currentContact
    vc.currentEditingContact = currentContact.copy()
    return vc
  }
  
  func setUpView(){
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
    setUpView()
    
    tableView?.register(StringTableViewCellV2.nib, forCellReuseIdentifier: StringTableViewCellV2.identifier)
    tableView?.register(ProfileImageTableViewCell.nib, forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
    tableView?.register(AddTableViewCell.nib, forCellReuseIdentifier: AddTableViewCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    
  }
  
  //MARK: -nav bar button actions
  @objc func editCancelButtonPressed(_ sender: UIButton){
    self.viewMode = .view
    currentEditingContact = currentContact?.copy()
    self.dataChanged = false
    setUpView()
  }
  
  @objc func backButtonPressed(_ sender: UIButton){
    if !dataChanged {
      if viewMode == .create {
        DataManager.deleteContact(id: currentContact.id)
      }
      self.navigationController?.popViewController(animated: true)
    } else {
      //if canceled creating
      if viewMode == .create {
        let alert = UIAlertController(title: "Contact not saved",
                                      message: "Don't save?",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Back",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { _ in
          DataManager.deleteContact(id: self.currentContact.id)
          self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Keep creating",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
       
      } else {
        // cancel editing existing one
        let alert = UIAlertController(title: "Changes not saved",
                                      message: "discard all changes?",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Back",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { _ in
          self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Keep editing",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
      }
      
    }
  }
  
  @objc func createButtonPressed(_ sender: UIButton) {
    //check if creating contact is not empty
    if dataChanged {
      // get data from cells
      saveDataFromCells()
      //upd contact
      currentContact = currentEditingContact
      DataManager.updContact(contact: currentEditingContact)
      //save changes
      DataManager.save()
      viewMode = .view
      setUpView()
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
    setUpView()
  }
  
  @objc func saveButtonPressed(_ sender: UIButton) {
    // upd data from cells
    saveDataFromCells()
    //upd contact
    currentContact = currentEditingContact
    DataManager.updContact(contact: currentEditingContact)
    //save changes
    DataManager.save()
    
    viewMode = .view
    setUpView()
  }
  
  func saveDataFromCells(){
    let totalSection = tableView.numberOfSections
    for section in 0..<totalSection
    {
      let totalRows = tableView.numberOfRows(inSection: section)
      for row in 0..<totalRows - 1
      {
        (tableView.cellForRow(at: IndexPath(row: row, section: section)) as! saveCell).save()
      }
    }
  }
}





//MARK: -TableView
extension ContactViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section{
    case 0:
      var result = currentEditingContact?.mainFields.count ?? 0
      if !(self.viewMode == .view) {
        result = result + 1
      }
      return result
    case 1:
      
      var result = currentEditingContact?.otherFields.count ?? 0
      if !(self.viewMode == .view) {
        result = result + 1
      }
      return result
    default:
      return 0
    }
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var item: ContactField?
    switch indexPath.section{
    case 0:
      item = currentEditingContact?.mainFields.first{$0.position == indexPath.row}
    case 1:
      item = currentEditingContact?.otherFields.first{$0.position == indexPath.row}
    default:
      break
    }
    
    switch item?.type{
    case .date:
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
      let cell = tableView.dequeueReusableCell(withIdentifier: AddTableViewCell.identifier, for: indexPath) as! AddTableViewCell
      let type: AddTableViewCell.cellType
      if indexPath.section == 0 {type = .main} else {type = .add}
      cell.setUpCell(type: type,
                     parentView: self)
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section{
    case 0:
      return "Main info"
    case 1:
      return "Other"
    default:
      return ""
    }
  }
  
  override func tableView(_ tableView: UITableView,
                          trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    if !(viewMode == .view) {
      let action = UIContextualAction(style: .normal,
                                      title: "Delete") { [weak self] (action, view, completionHandler) in
        guard let self = self else {
          return
        }
        guard let position =  (self.tableView.cellForRow(at: IndexPath(
          row: indexPath.row,section: 0)) as? saveCell)?.item?.position else {
            let alert = UIAlertController(title: "Error",
                                          message: "You cant delete this",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
          }
        
        let alert = UIAlertController(title: "Delete",
                                      message: "Are you sure about that?",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { action in
          switch indexPath.section {
          case 0:
            self.currentEditingContact.mainFields.remove(at: (self.currentEditingContact.mainFields.firstIndex { $0.position == position })!)
            self.currentEditingContact.mainFields.forEach{
              if $0.position > position{
                $0.position = $0.position - 1
              }
            }
          case 1:
            self.currentEditingContact.otherFields.remove(at: (self.currentEditingContact.otherFields.firstIndex{ $0.position == position })!)
            self.currentEditingContact!.otherFields.forEach {
              if $0.position > position {
                $0.position = $0.position - 1
              }
            }
          default:
            return
          }
          self.dataChanged = true
          self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
        completionHandler(true)
      }
      action.backgroundColor = .black
      return UISwipeActionsConfiguration(actions: [action])
    }
    return .none
    
  }
}
