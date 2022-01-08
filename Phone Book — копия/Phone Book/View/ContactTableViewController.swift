import UIKit


class ContactTableViewController: UITableViewController {
    enum ViewMode {
        case edit
        case view
        case create
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var numberField: UITextField!

    var viewMode: ViewMode = .view
    weak var controller: ContactManager?
    
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
            let contact = controller!.getContact(Id: controller!.currentContactId)
            nameField.text = contact.name
            numberField.text = contact.number
        }
        numberField.delegate = self
    }
    
    @objc func nuberFieldInputControl() {
        if !controller!.numberCheck(number: numberField.text ?? "") {
          numberField.text?.remove(at: (numberField.text?.firstIndex
                                        { !$0.isNumber }!)!)
            let alert = UIAlertController(title: "wrong input",
                                          message: "only 0-9 allowed",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok",
                                          style: UIAlertAction.Style.default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension ContactTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.first != "+" {
            let charsNotNumb = string.filter{(char: Character) in return !char.isNumber
            }
            if charsNotNumb.count == 0 {
                return true
            } else if charsNotNumb.count > 1 {
                return false
            } else if charsNotNumb.first == "+" {
                if range.location == 0 {
                    return true
                }
                return false
            }
        } else {
            let charsNotNumb = string.filter{(char: Character) in return !char.isNumber}
            if charsNotNumb.count == 0{
                return true
            }
        }
        return false
    }

}



