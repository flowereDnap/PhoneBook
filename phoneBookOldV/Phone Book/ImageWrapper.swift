//
//  ImageWrapper.swift
//  Phone Book
//
//  Created by User on 22.02.2022.
//

import UIKit

public class ImageWrapper: NSObject, Codable{
  var imgData: Data?
  static private let contactDefaultImage: UIImage = UIImage(named: "contactDefaultImage")!
  var image: UIImage? {
    get {
      if let imgData = imgData {
        return UIImage(data: imgData)
      }
      return ImageWrapper.contactDefaultImage
    }
    set {
      guard let img = newValue else {
        imgData = nil
        return
      }
      imgData = img.pngData()!
    }
  }
  init(image: UIImage?) {
    super.init()
    self.image = image
  }
  
}



