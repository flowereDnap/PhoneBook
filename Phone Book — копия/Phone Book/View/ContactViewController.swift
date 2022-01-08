
import UIKit

class ContactViewController: UIViewController{
  
  typealias ViewMode = ContactTableViewController.ViewMode
  enum Segues {
    static let toContactTableView = "toContactTableView"
  }
  
  var viewMode: ViewMode = .view
  weak var controller: ContactManager?
  var imagePicker: ImagePicker!
  var ContactTableView: ContactTableViewController?
  @IBOutlet var profilePicture: UIImageView!
  
  override func viewWillAppear(_ animated: Bool) {
    var rightButton: UIBarButtonItem
    switch viewMode {
    case .edit:
      rightButton = UIBarButtonItem.init(title: "Save",
                                         style: .done,
                                         target: self,
                                         action: #selector(saveButtonPressed))
    case .view:
      rightButton = UIBarButtonItem.init(title: "Edit",
                                         style: .done,
                                         target: self,
                                         action: #selector(editButtonPressed))
    case .create:
      rightButton = UIBarButtonItem.init(title: "Create",
                                         style: .done,
                                         target: self,
                                         action: #selector(createButtonPressed))
    }
    self.navigationItem.rightBarButtonItem = rightButton
    ContactTableView?.viewMode = viewMode
    ContactTableView?.viewWillAppear(false)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
    
    profilePicture.isUserInteractionEnabled = true
    profilePicture.addGestureRecognizer(tapGestureRecognizer)
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(backButtonPressed))
  }
  
  static func getView(viewMode:ViewMode,controller:ContactManager) -> ContactViewController {
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let vc: ContactViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactScene") as! ContactViewController
    vc.viewMode = viewMode
    vc.controller = controller
    return vc
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Segues.toContactTableView {
      self.ContactTableView = segue.destination as? ContactTableViewController
      ContactTableView!.viewMode = viewMode
      ContactTableView!.controller = controller
    }
  }
  
  //MARK: -nav bar button actions
  @objc func backButtonPressed(_ sender: UIButton){
    if viewMode != .view {
      let alert = UIAlertController(title: "Changes not saved",
                                    message: "discard all changes?",
                                    preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "Cansel",
                                    style: UIAlertAction.Style.default,
                                    handler: nil))
      alert.addAction(UIAlertAction(title: "Continue",
                                    style: UIAlertAction.Style.destructive,
                                    handler: { _ in
        self.navigationController?.popViewController(animated: true)
      }))
      self.present(alert, animated: true, completion: nil)
    } else {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  @objc func createButtonPressed(_ sender: UIButton) {
    if ContactTableView!.nameField.text != nil {
      let contact: Contact = Contact(name: ContactTableView!.nameField.text!,
                                     number: ContactTableView!.numberField.text ?? "", creationDate: Date())
      controller!.addContact(contact: contact)
      controller!.currentContactId = controller!.count - 1
    } else {
      //to do
    }
    viewMode = .view
    viewWillAppear(false)
  }
  
  @IBAction func editButtonPressed(_ sender: UIButton) {
    viewMode = .edit
    viewWillAppear(false)
  }
  
  @objc func saveButtonPressed(_ sender: UIButton) {
    controller!.updContact(Id: controller!.currentContactId,
                           name: ContactTableView!.nameField.text,
                           number: ContactTableView!.numberField.text,
                           image: nil)
    viewMode = .view
    viewWillAppear(false)
  }
}

extension ContactViewController: ImagePickerDelegate {
  
  func didSelect(image: UIImage?) {
    self.profilePicture.image = image
    controller!.updContact(Id: controller!.currentContactId,
                           name: nil,
                           number: nil,
                           image: profilePicture.image)
  }
}
extension ContactViewController: UIImagePickerControllerDelegate {
  @IBAction func showImagePicker(_ sender: UIButton) {
    self.imagePicker.present(from: sender)
  }
}
