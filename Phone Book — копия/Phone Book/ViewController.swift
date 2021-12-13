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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        title = "Phone Book"
        tableView.dataSource = self
        tableView.delegate = self
        
        filteredData = Model.data
        searchBar.delegate = self
    }
    
    
    @IBAction func addButton(_ sender: UIButton){
       
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : ContactTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactScene") as! ContactTableViewController
        //vc.currentContact = controller.getContact(Id: indexPath.row)
        vc.selectedType = .create
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(true ? 1 : 0)
        filteredData = searchText.isEmpty ? Model.data : Model.data.filter { item in
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
            return filteredData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        print(filteredData)
        cell.textLabel?.text = filteredData[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : ContactTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactScene") as! ContactTableViewController
        //vc.currentContact = controller.getContact(Id: indexPath.row)
        vc.currentContact = controller.getContact(Id: indexPath.row)
        controller.currentContactId = indexPath.row
        vc.selectedType = .view
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    
    }
}

