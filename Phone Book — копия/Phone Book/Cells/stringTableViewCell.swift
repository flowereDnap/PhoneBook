//
//  stringTableViewCell.swift
//  Phone Book
//
//  Created by User on 30.01.2022.
//

import UIKit

class StringTableViewCell: UITableViewCell {
  
  public static let identifier = "StringTableViewCell"
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
            textField.isUserInteractionEnabled = (parentView!.viewMode == .edit)
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
      (textField.delegate as! ContactViewController).dataChanged = true
    } else {
      (textField.delegate as! ContactViewController).dataChanged = false
    }
  }
    
}
