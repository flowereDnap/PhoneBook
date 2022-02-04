/*
import UIKit

class ContactViewController: UIViewController{
  typealias ViewMode = ContactTableViewController.ViewMode
  enum Segues {
    static let toContactTableView = "toContactTableView"
  }
  enum TextFields{
    static let nameField = "nameField"
    static let numberField = "numberField"
  }
  
  var viewMode: ViewMode = .view
  weak var controller: ContactManager?
  var currentContact :Contact?
  var imagePicker: ImagePicker!
  var ContactTableView: ContactTableViewController?
  var dataChanged: Bool = false {
    didSet{
      if dataChanged {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
      } else {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
      }
    }
  }
  @IBOutlet var profilePicture: UIImageView!
  
  static func getView(viewMode: ViewMode, controller: ContactManager, currentContact: Contact?) -> ContactViewController {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: ContactViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactScene") as! ContactViewController
    vc.viewMode = viewMode
    vc.controller = controller
    vc.currentContact = currentContact
    return vc
  }
  
  override func viewWillAppear(_ animated: Bool) {
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
      profilePicture.isUserInteractionEnabled = true
     
    case .view:
      rightButton = UIBarButtonItem.init(title: "Edit",
                                         style: .done,
                                         target: self,
                                         action: #selector(editButtonPressed))
      leftButton = UIBarButtonItem.init(title: "Back",
                                        style: .done,
                                        target: self,
                                        action: #selector(backButtonPressed))
      profilePicture.isUserInteractionEnabled = false
    case .create:
      rightButton = UIBarButtonItem.init(title: "Create",
                                         style: .done,
                                         target: self,
                                         action: #selector(createButtonPressed))
      leftButton = UIBarButtonItem.init(title: "Back",
                                        style: .done,
                                        target: self,
                                        action: #selector(backButtonPressed))
      profilePicture.isUserInteractionEnabled = true
      
    }
    self.navigationItem.rightBarButtonItem = rightButton
    self.navigationItem.leftBarButtonItem = leftButton
    ContactTableView?.viewMode = viewMode
    ContactTableView?.viewWillAppear(false)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
    
    profilePicture.addGestureRecognizer(tapGestureRecognizer)
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2
    guard let image = currentContact?.image else {
      profilePicture.image = UIImage(named: "contactDefaultImage")
      return
    }
    profilePicture.image = image
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Segues.toContactTableView {
      self.ContactTableView = segue.destination as? ContactTableViewController
      ContactTableView!.viewMode = viewMode
      ContactTableView!.controller = controller
      ContactTableView!.currentContact = currentContact
      ContactTableView!.textFieldDelegate = self
      
    }
  }
  
  //MARK: -nav bar button actions
  @objc func editCancelButtonPressed(_ sender: UIButton){
    self.viewMode = .view
    viewWillAppear(false)
  }
  
  @objc func backButtonPressed(_ sender: UIButton){
    if !dataChanged {
      self.navigationController?.popViewController(animated: true)
    } else {
      let alert = UIAlertController(title: "Changes not saved",
                                    message: "discard all changes?",
                                    preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "Keep editing",
                                    style: UIAlertAction.Style.default,
                                    handler: nil))
      alert.addAction(UIAlertAction(title: "Yes",
                                    style: UIAlertAction.Style.destructive,
                                    handler: { _ in
        self.navigationController?.popViewController(animated: true)
      }))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @objc func createButtonPressed(_ sender: UIButton) {
    if dataChanged {
      let contact: Contact = Contact(name: ContactTableView!.nameField.text!,
                                     number: ContactTableView!.numberField.text ?? "",
                                     image: profilePicture.image,
                                     fields: [])
      controller!.addContact(contact: contact)
      currentContact = contact
      viewMode = .view
      viewWillAppear(false)
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
    viewWillAppear(false)
  }
  
  @objc func saveButtonPressed(_ sender: UIButton) {
    controller!.updContact(Id: (currentContact?.id)!,
                           name: ContactTableView!.nameField.text,
                           number: ContactTableView!.numberField.text,
                           image: profilePicture.image)
    viewMode = .view
    currentContact = controller!.getContact(Id: (currentContact?.id)!)
    viewWillAppear(false)
  }
}

extension ContactViewController: ImagePickerDelegate {
  
  func didSelect(image: UIImage?) {
    if !(profilePicture.image?.isEqualToImage(image: image!) ?? true){
      dataChanged = true
    }
    self.profilePicture.image = image
  }
  func deleteImage(in sender: UIImageView) {
    sender.image = UIImage(named: "contactDefaultImage")
    dataChanged = true
  }
}

extension ContactViewController: UIImagePickerControllerDelegate {
  @IBAction func showImagePicker(tapGestureRecognizer: UITapGestureRecognizer) {
    let tappedImage = tapGestureRecognizer.view as! UIImageView
    let imageExist = !(profilePicture.image?.isEqualToImage(image: UIImage(named: "contactDefaultImage")!) ?? true)
    
    self.imagePicker.present(from: tappedImage, imageExist: imageExist)
  }
}

extension ContactViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    func callWrongInputAllert() {
      let alert = UIAlertController(title: "wrong input",
                                    message: "only 0-9 allowed (first character mqay be \"+\")",
                                    preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "ok",
                                    style: UIAlertAction.Style.default,
                                    handler: nil))
      self.present(alert, animated: true, completion: nil)
    }

    switch textField.accessibilityIdentifier {
    case TextFields.nameField:
      return true
    case TextFields.numberField:
      if textField.text?.first != "+" {
        let charsNotNumb = string.filter{(char: Character) in
          return !char.isNumber
        }
        if charsNotNumb.count == 0 {
          return true
        } else if charsNotNumb.count > 1 {
          callWrongInputAllert()
          return false
        } else if charsNotNumb.first == "+" {
          if range.location == 0 {
            return true
          }
          callWrongInputAllert()
          return false
        }
      } else {
        let charsNotNumb = string.filter{(char: Character) in return !char.isNumber}
        if charsNotNumb.count == 0{
          return true
        }
      }
      callWrongInputAllert()
      return false
    default:
      return false
    }
  }
}*/
