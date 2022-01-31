//
//  profileImageTableViewCell.swift
//  Phone Book
//
//  Created by User on 30.01.2022.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {
  
  var imagePicker: ImagePicker!
  public static let identifier = "ProfileImageTableViewCell"
  private var parentView: ContactViewControllerV2?
  private var item: ContactField? {
        didSet {
          if case let .image(wrappedImage) = item?.value {
          let image = wrappedImage.image
            profilePicture.isUserInteractionEnabled = !(parentView?.viewMode == .view)
          self.imagePicker = ImagePicker(presentationController: parentView!, delegate: self)
          let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
          
          profilePicture.addGestureRecognizer(tapGestureRecognizer)
          profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2
            guard let image = image else {
            profilePicture.image = UIImage(named: "contactDefaultImage")
            return
          }
          profilePicture.image = image
        }
        }
     }
  
  func setUpCell(parentView:ContactViewControllerV2, item: ContactField) {
    self.parentView = parentView
    self.item = item
  }
  
  @IBOutlet var profilePicture: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

extension ProfileImageTableViewCell: ImagePickerDelegate {
  func didSelect(image: UIImage?) {
    if !(profilePicture.image?.isEqualToImage(image: image!) ?? true){
      parentView?.dataChanged = true
    }
    self.profilePicture.image = image
  }
  func deleteImage(in sender: UIImageView) {
    sender.image = UIImage(named: "contactDefaultImage")
    parentView?.dataChanged = true
  }
}
extension ProfileImageTableViewCell: UIImagePickerControllerDelegate {
  @IBAction func showImagePicker(tapGestureRecognizer: UITapGestureRecognizer) {
    let tappedImage = tapGestureRecognizer.view as! UIImageView
    let imageExist = !(profilePicture.image?.isEqualToImage(image: UIImage(named: "contactDefaultImage")!) ?? true)
    
    self.imagePicker.present(from: tappedImage, imageExist: imageExist)
  }
}

