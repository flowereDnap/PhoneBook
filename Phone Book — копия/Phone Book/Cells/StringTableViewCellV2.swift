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
  private var parentView: ContactViewControllerV2?
  private var item: ContactField? {
    didSet {
      label.text = item?.lable
      if case let .name(text) = item?.value {
        textField.text = text
        delegate = NameFieldDelegate(parentView: parentView!)
        textField.isUserInteractionEnabled = !(parentView!.viewMode == .view)
      }
      if case let .number(text) = item?.value {
        textField.text = text
        delegate = NumberFieldDelegate(parentView: parentView!)
        textField.isUserInteractionEnabled = !(parentView!.viewMode == .view)
        
      }
      if case let .date(date) = item?.value {
        let dateFormatter = DateFormatter()
        textField.text = dateFormatter.string(from: date)
        delegate = NumberFieldDelegate(parentView: parentView!)
        textField.isUserInteractionEnabled = false
      }
      textField.delegate = delegate
    }
  }
  
  func setUpCell(parentView:ContactViewControllerV2, item: ContactField) {
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
    var val: String? = nil
    if case let .name(myVal) = item?.value{
      val = myVal
    }
    if case let .number(myVal) = item?.value {
      val = myVal
    }
    if textField.text != val {
      parentView?.dataChanged = true
    } else {
      parentView?.dataChanged = false
    }
    
    if case .name(_) = item?.value {
        item?.value = .name(textField.text!)
    }
    if case .number(_) = item?.value {
         item?.value = .number(textField.text!)
    }
  }
  
  func save(){
    if let new = parentView?.currentContact?.mainFields.firstIndex(where: {$0.position == item?.position}){
      parentView?.currentContact?.mainFields[new] = item!
    } else if let new = parentView?.currentContact?.additionalFields.firstIndex(where: {$0.position == item?.position}){
      parentView?.currentContact?.additionalFields[new] = item!
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

protocol saveCell: UITableViewCell {
  func save()
}
