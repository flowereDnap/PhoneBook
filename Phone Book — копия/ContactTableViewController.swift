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

    var currentContact:Contact = Contact(name: "", number: "")
    var controller: Controller = Controller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        nameField.text = currentContact.name
        numberField.text = currentContact.number
    }
    
    @IBAction func EditButtonPressed(_ sender: UIButton){
        if sender.title(for: .normal) == "Edit"{
            self.navigationItem.leftBarButtonItem?.title = "Cansel"
            self.navigationItem.rightBarButtonItem?.title = "Save"
            nameField.isUserInteractionEnabled = true
            numberField.isUserInteractionEnabled = true
        }else if sender.title(for: .normal) == "Save"{
            self.navigationItem.leftBarButtonItem?.title = "Cansel"
            self.navigationItem.rightBarButtonItem?.title = "Save"
            nameField.isUserInteractionEnabled = false
            numberField.isUserInteractionEnabled = false
            
            guard let name = nameField.text else{
                controller.deleteCurrentContact()
                return
            }
            let editedContact: Contact = Contact(name: name, number: numberField.text ?? "")
            controller.updCurrentContact(contact: editedContact)
        }
    }
    
    @IBAction func BackButtonPressed(_ sender: UIButton){
        if sender.title(for: .normal) == "Back"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Main")
                    self.present(newViewController, animated: true, completion: nil)
        }else if sender.title(for: .normal) == "Cansel"{
            self.navigationItem.leftBarButtonItem?.title = "Back"
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            nameField.isUserInteractionEnabled = false
            numberField.isUserInteractionEnabled = false
            
            let currentContact = controller.getContact(Id: 0)
            nameField.text = currentContact.name
            numberField.text = currentContact.number
        }
    }
    // MARK: - Table view data source
   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
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
