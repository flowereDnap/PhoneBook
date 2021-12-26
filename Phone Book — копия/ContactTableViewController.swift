//
//  ContactTableViewController.swift
//  Phone Book
//
//  Created by User on 01.11.2021.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var numberField: UITextField!
    @IBOutlet var tableView2: UITableView!
    
    enum ViewMode{
        case edit
        case view
        case create
    }
    
    var viewMode:ViewMode = .view
    weak var controller:ContactManager?
    
    static func getView(viewMode:ViewMode,controller:ContactManager)->ContactTableViewController{
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : ContactTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactScene") as! ContactTableViewController
        vc.viewMode = viewMode
        vc.controller = controller
        
        return vc
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
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewMode == .view {
            let contact = controller!.getContact(Id: controller!.currentContactId)
            nameField.text = contact.name
            numberField.text = contact.number
        }
        numberField.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .done, target: self, action: #selector(backButtonPressed))

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
            let contact: Contact = Contact(name: nameField.text!, number: numberField.text ?? "", creationDate: NSDate() as Date)
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
        controller!.updContact(Id: controller!.currentContactId , name: nameField.text , number : numberField.text)
        viewMode = .view
        viewWillAppear(false)
    }
    
    
    
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     cell.isSelected = false
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
