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
  var parentView: ContactViewControllerV2!
  var currentContact: Contact!
  var delegate:UITextFieldDelegate?
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setUpCell(type:cellType, parentView: ContactViewControllerV2, currentContact: Contact){
    self.type = type
    self.parentView = parentView
    self .currentContact = currentContact
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
        return
      }
      let action2 = UIAlertAction(title: "new number",
                                       style: .default) { [self] (UIAlertAction2) in
        callCreateAllert(type: .number, isMain: true)
        return
      }
      optionMenu.addAction(action1)
      optionMenu.addAction(action2)
      parentView.present(optionMenu, animated: true, completion: nil)
    case .add:
      let optionMenu = UIAlertController(title: nil,
                                         message: "Choose Option",
                                         preferredStyle: .actionSheet)
      let action1 = UIAlertAction(title: "new mail",
                                       style: .default) { [self] (UIAlertAction2) in
        callCreateAllert(type: .mail, isMain: false)
        return
      }
      let action2 = UIAlertAction(title: "new date of birth",
                                       style: .default) { [self] (UIAlertAction2) in
        callCreateAllert(type: .dateOfBirth, isMain: false)
        return
      }
      optionMenu.addAction(action1)
      optionMenu.addAction(action2)
      parentView.present(optionMenu, animated: true, completion: nil)
    default:
        return
    }
  }
  
  func callCreateAllert(type:Labels, isMain: Bool){
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
      let positionOfLast = (self.currentContact.mainFields.last(where: {$0.type == type})?.position ?? 0)
      var newField: ContactField
      switch type {
        case .name:
          newField = ContactField(lable: lable, type: type, position: positionOfLast + 1, value: .name(value ?? ""))
        case .number:
          newField = ContactField(lable: lable, type: type, position: positionOfLast + 1, value: .number(value ?? ""))
        default:
          return
      }
      
      self.parentView.saveBeforeReload()
      for index in 0..<self.currentContact.mainFields.count {
          if self.currentContact.mainFields[index].position > positionOfLast{
            self.currentContact.mainFields[index].move()
        }
      }
      self.currentContact.mainFields.append(newField)
      self.currentContact.sort()

      self.parentView.tableView.reloadData()
      self.parentView.dataChanged = true
      } else {
        let positionOfLast = (self.currentContact.additionalFields.last(where: {$0.type == type})?.position ?? -1)
          
        var newField: ContactField
        switch type {
        case .mail:
          newField = ContactField(lable: lable, type: type, position: positionOfLast + 1, value: .mail(value ?? ""))
        case .dateOfBirth:
          //TODO : string to date delegate
          newField = ContactField(lable: lable, type: type, position: positionOfLast + 1, value: .date(Date()))
        default:
          return
        }
        
        self.parentView.saveBeforeReload()
        for index in 0..<self.currentContact.additionalFields.count {
          if self.currentContact.additionalFields[index].position > positionOfLast{
            self.currentContact.additionalFields[index].move()
          }
        }
        self.currentContact.additionalFields.append(newField)
        self.currentContact.sort()
        self.parentView.tableView.reloadData()
        self.parentView.dataChanged = true
      }
    }))
    parentView.present(alert, animated: true, completion: nil)
    
  }
}
