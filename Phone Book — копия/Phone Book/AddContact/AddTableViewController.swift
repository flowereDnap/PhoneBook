//
//  AddTableViewController.swift
//  Phone Book
//
//  Created by User on 28.10.2021.
//

import UIKit

class AddTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    let controller: Controller = Controller()
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var numberField: UITextField!
    
    @IBAction func saveButton(_ sender: UIButton){
        let newContact: Contact = Contact(name: nameField.text ?? "", number: numberField.text ?? "")
        controller.addContact(contact: newContact)
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
}
