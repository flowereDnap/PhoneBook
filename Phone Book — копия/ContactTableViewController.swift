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
    
    enum SelectedType{
        case edit
        case view
        case create
    }
    
    var currentContact:Contact = Contact(name: "", number: "")
    var selectedType:SelectedType = .view
    var controller: Controller = Controller()
    
    override func viewWillAppear(_ animated: Bool) {
        switch selectedType {
        case .edit:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
            nameField.isUserInteractionEnabled = true
            numberField.isUserInteractionEnabled = true
        case .view:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action: #selector(editButtonPressed))
            nameField.isUserInteractionEnabled = false
            numberField.isUserInteractionEnabled = false
        case .create:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Create", style: .done, target: self, action: #selector(createButtonPressed))
            nameField.isUserInteractionEnabled = true
            numberField.isUserInteractionEnabled = true

        }
                //или self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = currentContact.name
        numberField.text = currentContact.number
        self.navigationItem.leftBarButtonItem?.action = #selector(backButtonPressred)
    }
    
    @objc func backButtonPressred(_ sender: UIButton){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func createButtonPressed(_ sender: UIButton){
        if nameField.text != nil{
            let contact: Contact = Contact(name: nameField.text!, number: numberField.text ?? "")
            controller.addContact(contact: contact)
            controller.currentContactId = controller.count
            selectedType = .view
            viewWillAppear(false)
        }
        else{
            
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton){
        selectedType = .edit
        viewWillAppear(false)
    }
    
    
    @objc func saveButtonPressed(_ sender: UIButton){
        guard let name = nameField.text else{
            controller.deleteCurrentContact()
            return
        }
        let editedContact: Contact = Contact(name: name, number: numberField.text ?? "")
        controller.updCurrentContact(contact: editedContact)
    selectedType = .view
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

        // Configure the cell...

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

