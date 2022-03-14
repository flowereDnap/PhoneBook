//
//  ContactTableViewCell.swift
//  PhoneBook2
//
//  Created by User on 14.03.2022.
//

import UIKit

class ContactTableViewCell: MyCell {
  
  
  @IBOutlet var profileImage: UIImageView!
  @IBOutlet var title: UILabel!
  @IBOutlet var subTitle: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  private var isFilteringBySearchBar: Bool!
  private var contact: Contact! {
    didSet{
      guard let image = contact.mainFields.first(where: {$0.type == .image})?.value as? UIImage else {
        debugPrint("contact cell setUp fail")
        return
      }

      profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
      profileImage.image = image
      
      var text: String = "Unnamed"
      
      //contact name ("Unnamed" if none)
      let names = contact.mainFields.filter({$0.type == .name})
      let name = names.min(by: {$0.position < $1.position})
      if let name = name?.value as? String {
        if name != "" {
          text = name
        }
      }
      //set name text
      title.text = text
      if isFilteringBySearchBar{
        let string = NSMutableAttributedString(string: "found in: ")
        string.append(contact.searchFoundIn!)
        subTitle.attributedText = string
      } else {
        //if no name show additional data
        if let number = contact.mainFields.first(where: {$0.type == .number})?.value as? String {
          if text == "Unnamed" && number != "" {
            subTitle.text = "Number: " + number
          } else {
            subTitle.text = nil
          }
        }
      }
      contactId = contact.id
      isSelected = false
    }
  }
  
  func setUpCell(contact: Contact, isFilteringBySearchBar: Bool){
    self.isFilteringBySearchBar = isFilteringBySearchBar
    self.contact = contact
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  static var nib:UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
  
  static var identifier: String {
    return String(describing: self)
  }
  
}
