//
//  ViewController.swift
//  Phone Book
//
//  Created by User on 28.10.2021.
//

import UIKit

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
    
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // When there is no text, filteredData is the same as the original data
            // When user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
        filteredData = searchText.isEmpty ? Model.data : Model.data.filter { (item: Contact) -> Bool in
                // If dataItem matches the searchText, return true to include it
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        
            tableView.reloadData()
        }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.count
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
        controller.currentContactId = indexPath.row
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "newViewController")
                self.present(newViewController, animated: true, completion: nil)
    }
}
