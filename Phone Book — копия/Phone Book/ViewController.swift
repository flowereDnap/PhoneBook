//
//  ViewController.swift
//  Phone Book
//
//  Created by User on 28.10.2021.
//

import UIKit

// FIXME: why we use this initialize 3 times? What the reason of it?
var controller:Controller = Controller()


class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredData: [Contact]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        filteredData = Model.data
        searchBar.delegate = self
    }
    
    @IBAction func addButton(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier:
        "AddContactScene") as! AddTableViewController
        self.navigationController?.pushViewController(editScreen, animated:
true)
        
    }

    
}


extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        filteredData = searchText.isEmpty ? Model.data : Model.data.filter { (item: Contact) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return controller.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = controller.getContact(Id:indexPath.row).name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier:
        "ContactScene") as! ContactTableViewController
        editScreen.currentContact = controller.getContact(Id: indexPath.row)
        
        self.navigationController?.pushViewController(editScreen, animated:
true)
    }
}

