//
//  AddTableViewCell.swift
//  Phone Book
//
//  Created by User on 15.02.2022.
//

import UIKit

class AddTableViewCell: UITableViewCell {
  
  static var nib:UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
  
  static var identifier: String {
    return String(describing: self)
  }
  
  enum cellType{
    case main
    case add
  }
  
  @IBOutlet var button:UIButton!
  private var type: cellType!
  var parentView: ContactViewController!
  var currentEditingContact: Contact!
  var delegate:UITextFieldDelegate?
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setUpCell(type:cellType, parentView: ContactViewController){
    self.type = type
    self.parentView = parentView
    self .currentEditingContact = parentView.currentEditingContact
  }
  
  @IBAction func addButtonPressed(_ sender: UIButton){
    switch type {
    case .main:
      let optionMenu = UIAlertController(title: nil,
                                         message: "Choose Option",
                                         preferredStyle: .actionSheet)
      let action1 = UIAlertAction(title: "new name",
                                  style: .default) { [self] (UIAlertAction2) in
        callCreateAllert(type: .name, isMain: true)
      }
      let action2 = UIAlertAction(title: "new number",
                                  style: .default) { [self] (UIAlertAction2) in
        callCreateAllert(type: .number, isMain: true)
      }
      let action3 = UIAlertAction(title: "Cancel", style: .cancel)
      optionMenu.addAction(action3)
      optionMenu.addAction(action1)
      optionMenu.addAction(action2)
      parentView.present(optionMenu, animated: true, completion: nil)
    case .add:
      let optionMenu = UIAlertController(title: nil,
                                         message: "Choose Option",
                                         preferredStyle: .actionSheet)
      let action2 = UIAlertAction(title: "new date of birth",
                                  style: .default) { [self] (UIAlertAction2) in
        callCreateAllert(type: .date, isMain: false)
      }
      let action3 = UIAlertAction(title: "Cancel", style: .cancel)
      optionMenu.addAction(action3)
      optionMenu.addAction(action2)
      parentView.present(optionMenu, animated: true, completion: nil)
    default:
      return
    }
  }
  
  func callCreateAllert(type: Types, isMain: Bool){
    let alert = UIAlertController(title: "new \(type.rawValue)",
                                  message: "type in new \(type.rawValue)",
                                  preferredStyle: .alert)
    alert.addTextField { field in
      field.placeholder = "label"
      field.returnKeyType = .next
    }
    switch type {
    case .name:
      self.delegate = NameFieldDelegate(parentView: self.parentView)
    case .number:
      self.delegate = NumberFieldDelegate(parentView: self.parentView)
    default:
      self.delegate = NameFieldDelegate(parentView: self.parentView)
    }
    alert.addTextField { field in
      field.placeholder = "\(type.rawValue)"
      field.returnKeyType = .continue
      if self.delegate != nil {
        field.delegate = self.delegate
      }
    }
    alert.addAction(UIAlertAction(title: "Cancel",
                                  style: .cancel,
                                  handler: nil))
    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
      guard let fields = alert.textFields, fields.count == 2 else {
        return
      }
      let lable = fields[0].text
      let value = fields[1].text
      if isMain {
        let positionOfLast = self.currentEditingContact.getPositionOfLast(inMainFields: true,
                                                         type: type)
        var newField: ContactField
        switch type {
        case .name:
          newField = ContactField(position: positionOfLast + 1,
                                  type: .name,
                                  lable: lable,
                                  value: value ?? "")
        case .number:
          newField = ContactField(position: positionOfLast + 1,
                                  type: .number,
                                  lable: lable,
                                  value: value ?? "")
        default:
          return
        }
        
        self.parentView.saveDataFromCells()
        self.currentEditingContact.mainFields.forEach {
          if $0.position > positionOfLast {
            $0.position = $0.position + 1
          }
        }
        self.currentEditingContact.mainFields.append(newField)
        self.currentEditingContact.sort()
        self.parentView.tableView.reloadData()
        self.parentView.dataChanged = true
      } else {
        let positionOfLast = self.currentEditingContact.getPositionOfLast(inMainFields: false,
                                                         type: type)
        
        var newField: ContactField
        switch type {
        case .date:
          //TODO : string to date delegate
          newField = ContactField(position: positionOfLast + 1,
                                  type: .date,
                                  lable: lable,
                                  value: Date())
        default:
          return
        }
        
        self.parentView.saveDataFromCells()
        self.currentEditingContact.otherFields.forEach {
          if $0.position > positionOfLast {
            $0.position = $0.position + 1
          }
        }
        self.currentEditingContact.otherFields.append(newField)
        self.currentEditingContact.sort()
        self.parentView.tableView.reloadData()
        self.parentView.dataChanged = true
      }
    }))
    parentView.present(alert, animated: true, completion: nil)
    
  }
}
