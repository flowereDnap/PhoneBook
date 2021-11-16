//
//  ContactTableViewController.swift
//  Phone Book
//
//  Created by User on 01.11.2021.
//

import UIKit

class ContactTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var profilePicture: UIImageView!
    var picker = UIImagePickerController ()
    @IBAction func chooseProfilePicBtnClicked(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            picker.sourceType = UIImagePickerController.SourceType.camera
            self.present(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    func openGallary(){
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker.dismiss(animated: true, completion: nil)
        profilePicture.image=info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        let editedContact: Contact = Contact(name: nameField.text!, number: numberField.text ?? "", image: profilePicture.image)
        controller.updCurrentContact(contact: editedContact)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var numberField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var controller: Controller = Controller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentContact = controller.getContact()
        nameField.text = currentContact.name
        numberField.text = currentContact.number
        if let contactImage = currentContact.image{
            imageView.image = contactImage
        }
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
            let editedContact: Contact = Contact(name: name, number: numberField.text ?? "", image: profilePicture.image)
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
            
            let currentContact = controller.getContact()
            nameField.text = currentContact.name
            numberField.text = currentContact.number
        }
    }
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
