//
//  StringTableViewCellV2.swift
//  Phone Book
//
//  Created by User on 04.02.2022.
//

import UIKit

class StringTableViewCellV2: UITableViewCell, saveCell {
  
  
  @IBOutlet var label: UILabel!
  @IBOutlet var textField: UITextField!
  
  var delegate: UITextFieldDelegate?
  private weak var parentView: ContactViewController?
  internal var item: ContactField? {
    didSet {
      label.text = item?.lable
      switch item?.type {
      case .name:
        textField.text = item?.value as? String
        delegate = NameFieldDelegate(parentView: parentView!)
        textField.isUserInteractionEnabled = !(parentView!.viewMode == .view)
      case .number:
        textField.text = item?.value as? String
        delegate = NumberFieldDelegate(parentView: parentView!)
        textField.isUserInteractionEnabled = !(parentView!.viewMode == .view)
      case .email:
        textField.text = item?.value as? String
        delegate = MailFieldDelegate(parentView: parentView!)
        textField.isUserInteractionEnabled = !(parentView!.viewMode == .view)
      default:
        break
      }
      textField.delegate = delegate
    }
  }
  
  func setUpCell(parentView:ContactViewController, item: ContactField) {
    self.parentView = parentView
    self.item = item
    textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    let val = item?.value as? String
    if textField.text != val {
      parentView?.dataChanged = true
    } else {
      parentView?.dataChanged = false
    }
    
    item?.value = textField.text!
    self.save()
  }
  
  func save(){
    if item!.isMain() {
      if let updContactId = parentView?.currentEditingContact?.mainFields.firstIndex(where: {$0.position == item?.position}){
        parentView?.currentEditingContact?.mainFields[updContactId] = item!
      }
    } else {
      if let updContactId = parentView?.currentEditingContact?.otherFields.firstIndex(where: {$0.position == item?.position}){
        parentView?.currentEditingContact?.otherFields[updContactId] = item!
      }
    }
  }
  
  static var nib:UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
  
  static var identifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell {
  var tableView: UITableView? {
    return self.next(of: UITableView.self)
  }
  
  var indexPath: IndexPath? {
    return self.tableView?.indexPath(for: self)
  }
}

extension UIResponder {
  /**
   * Returns the next responder in the responder chain cast to the given type, or
   * if nil, recurses the chain until the next responder is nil or castable.
   */
  func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
    return self.next.flatMap({ $0 as? U ?? $0.next() })
  }
}

protocol saveCell: UITableViewCell{
  func save()
  var item: ContactField? {get set}
}
