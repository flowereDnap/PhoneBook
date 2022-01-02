//
//  ContactTableViewController.swift
//  Phone Book
//
//  Created by User on 01.11.2021.
//

import UIKit



class ContactTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum ViewMode{
        case edit
        case view
        case create
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var numberField: UITextField!
    @IBOutlet var profilePicture: UIImageView!
    
    
    var viewMode:ViewMode = .view
    weak var controller:ContactManager?
    var imagePicker: ImagePicker!
    
    @IBAction func showImagePicker(_ sender: UIButton) {
            self.imagePicker.present(from: sender)
        }

    override func viewWillAppear(_ animated: Bool) {
        var rightButton: UIBarButtonItem
        switch viewMode {
        case .edit:
            rightButton = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
            nameField.isUserInteractionEnabled = true
            numberField.isUserInteractionEnabled = true
        case .view:
            rightButton = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action: #selector(editButtonPressed))
            nameField.isUserInteractionEnabled = false
            numberField.isUserInteractionEnabled = false
        case .create:
            rightButton = UIBarButtonItem.init(title: "Create", style: .done, target: self, action: #selector(createButtonPressed))
            nameField.isUserInteractionEnabled = true
            numberField.isUserInteractionEnabled = true
        }
        if self.controller != nil {
            print("yes")
        }
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    /*
        if viewMode == .view {
            let contact = controller!.getContact(Id: controller!.currentContactId)
            nameField.text = contact.name
            numberField.text = contact.number
            profilePicture.image = contact.image
        }
        numberField.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tapGestureRecognizer)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .done, target: self, action: #selector(backButtonPressed))
*/
    }
    
    @objc func nuberFieldInputControl(){
        if !controller!.numberCheck(number: numberField.text ?? ""){
            numberField.text?.remove(at: (numberField.text?.firstIndex(where: {!$0.isNumber})!)!)
            
            let alert = UIAlertController(title: "wrong input", message: "only 0-9 allowed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func backButtonPressed(_ sender: UIButton){
        if viewMode != .view {
            let alert = UIAlertController(title: "Changes not saved", message: "discard all changes?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cansel", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.destructive, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func createButtonPressed(_ sender: UIButton){
        if nameField.text != nil{
         
            let contact: Contact = Contact( name: nameField.text!, number: numberField.text ?? "", creationDate: Date())
            controller!.addContact(contact: contact)
            controller!.currentContactId = controller!.count - 1
            viewMode = .view
            viewWillAppear(false)
        }
        else{
            
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton){
        viewMode = .edit
        viewWillAppear(false)
    }
       
    @objc func saveButtonPressed(_ sender: UIButton){
        controller!.updContact(Id: controller!.currentContactId , name: nameField.text , number : numberField.text, image: nil)
        viewMode = .view
        viewWillAppear(false)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}


extension ContactTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.first != "+"{
            let charsNotNumb = string.filter{(char: Character) in return !char.isNumber}
            if charsNotNumb.count == 0{
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


extension ContactTableViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profilePicture.image = image
        controller!.updContact(Id: controller!.currentContactId,name: nil, number: nil, image: profilePicture.image)
        
    }
}
