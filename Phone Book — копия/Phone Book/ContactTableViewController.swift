//
//  ContactTableViewController.swift
//  Phone Book
//
//  Created by User on 01.11.2021.
//
import UIKit

class ContactTableViewController: UITableViewController{
    var navBar: UINavigationBar
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar = (self.navigationController?.navigationBar)!
    }
    
    
    @IBAction func EditButtonPressed(_ sender: UIButton){
        if sender.title(for: .normal) == "Edit"{
            sender.setTitle("Save", for: .normal)
            
        }
    }
}
