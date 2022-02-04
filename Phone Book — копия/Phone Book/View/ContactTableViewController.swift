/*import UIKit


class ContactTableViewController: UITableViewController {
 
  
  @IBOutlet var nameField: UITextField!
  @IBOutlet var numberField: UITextField!
  
  var viewMode: ViewMode = .view
  weak var controller: ContactManager?
  var currentContact: Contact?
  var textFieldDelegate: ContactViewController?
  
  override func viewWillAppear(_ animated: Bool) {
    switch viewMode {
    case .edit:
      nameField.isUserInteractionEnabled = true
      numberField.isUserInteractionEnabled = true
    case .view:
      nameField.isUserInteractionEnabled = false
      numberField.isUserInteractionEnabled = false
    case .create:
      nameField.isUserInteractionEnabled = true
      numberField.isUserInteractionEnabled = true
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if viewMode == .view {
      nameField.text = currentContact?.name
      numberField.text = currentContact?.number
    }
    nameField.delegate = textFieldDelegate
    nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    numberField.delegate = textFieldDelegate
    numberField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  @objc func textFieldDidChange(_ textField: UITextField) {
    switch textField.accessibilityIdentifier{
    case ContactViewController.TextFields.nameField:
      if textField.text != currentContact?.name{
        (textField.delegate as! ContactViewController).dataChanged = true
      } else {
        (textField.delegate as! ContactViewController).dataChanged = false
      }
    case ContactViewController.TextFields.numberField:
      if textField.text != currentContact?.number{
        (textField.delegate as! ContactViewController).dataChanged = true
      } else {
        (textField.delegate as! ContactViewController).dataChanged = false
      }
    default:
      break
    }
  }
 
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}



*/
