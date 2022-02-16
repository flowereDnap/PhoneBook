//
//  profileImageTableViewCell.swift
//  Phone Book
//
//  Created by User on 30.01.2022.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell, saveCell {
  
  
  @IBOutlet var profilePicture: UIImageView!
  var imagePicker: ImagePicker!
  private var parentView: ContactViewControllerV2?
  internal var item: ContactField? {
        didSet {
          if case let .image(wrappedImage) = item?.value {
          let image = wrappedImage.image
            profilePicture.isUserInteractionEnabled = !(parentView?.viewMode == .view)
          self.imagePicker = ImagePicker(presentationController: parentView!, delegate: self)
          let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
          
          profilePicture.addGestureRecognizer(tapGestureRecognizer)
          profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2
          profilePicture.image = image
        }
        }
     }
  
  func setUpCell(parentView:ContactViewControllerV2, item: ContactField) {
    self.parentView = parentView
    self.item = item
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  func save(){
    if let new = parentView?.currentEditingContact?.mainFields.firstIndex(where: {$0.position == item?.position}){
      parentView?.currentEditingContact?.mainFields[new] = item!
    }
  }
}

extension ProfileImageTableViewCell: ImagePickerDelegate {
  func didSelect(image: UIImage?) {
    guard let image = image else {
      return
    }
    if !(profilePicture.image?.isEqualToImage(image: image) ?? true){
      parentView?.dataChanged = true
    }
    self.profilePicture.image = image
    item?.value = .image(ImageWrapper(image: image))
  }
  func deleteImage(in sender: UIImageView) {
    sender.image = UIImage(named: "contactDefaultImage")
    parentView?.dataChanged = true
    item?.value = .image(ImageWrapper(image: nil))
  }
}

extension ProfileImageTableViewCell: UIImagePickerControllerDelegate {
  @IBAction func showImagePicker(tapGestureRecognizer: UITapGestureRecognizer) {
    let tappedImage = tapGestureRecognizer.view as! UIImageView
    let imageExist = !(profilePicture.image?.isEqualToImage(image: UIImage(named: "contactDefaultImage")!) ?? true)
    
    self.imagePicker.present(from: tappedImage, imageExist: imageExist)
  }
  static var nib:UINib {
      return UINib(nibName: identifier, bundle: nil)
  }
  
  static var identifier: String {
      return String(describing: self)
  }
}

