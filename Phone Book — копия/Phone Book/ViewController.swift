//
//  ViewController.swift
//  Phone Book
//
//  Created by User on 28.10.2021.
//

import UIKit

// FIXME: why we use this initialize 3 times? What the reason of it?


protocol Observer: AnyObject{

    func update(subject: ContactManager)
}

enum FilterMode{
    case alf
    case date
}

var controller:ContactManager = ContactManager()
var filterMode:FilterMode = .alf


class ViewController: UIViewController, Observer {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func update(subject: ContactManager) {
        self.dataToShow = subject.data
        tableView.reloadData()
    }
    
   
    var dataToShow: [Contact]! = []
    
    override func viewWillAppear(_ animated: Bool) {
        let rightBtt = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        let image = UIImage(named: "sort_icon")?.withRenderingMode(.alwaysOriginal)
        let leftButt = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(filterButtonPressed))
        
        self.navigationItem.rightBarButtonItems = [ rightBtt, leftButt ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MyCell.self, forCellReuseIdentifier: "myCell")
        title = "Phone Book"
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        controller.attach(self)
        dataToShow = controller.data
    }
    
    
    @IBAction func addButton(_ sender: UIButton){
        
        let vc = ContactTableViewController.getView(viewMode: .create, controller: controller)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func filterButtonPressed(_ sender: UIBarButtonItem){
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
               
           // 2
        let deleteAction = UIAlertAction(title: "Sort by alf", style: .default, handler:{ [self] (UIAlertAction)in
                self.dataToShow.sort(by: {$0.name < $1.name})
               tableView.reloadData()
           })
           let saveAction = UIAlertAction(title: "Sort by date", style: .default, handler:{ [self] (UIAlertAction)in
               self.dataToShow.sort(by: {$0.creationDate < $1.creationDate})
               tableView.reloadData()
           })
               
           // 3
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
               
           // 4
           optionMenu.addAction(deleteAction)
           optionMenu.addAction(saveAction)
           optionMenu.addAction(cancelAction)
               
           // 5
           self.present(optionMenu, animated: true, completion: nil)
        
        
        
        /*switch filterMode {
        case .alf:
            dataToShow.sort(by: {$0.name < $1.name})
            tableView.reloadData()
            sender.title = "Sort by date"
            filterMode = .date
        case .date:
            dataToShow.sort(by: {$0.creationDate < $1.creationDate})
            tableView.reloadData()
            sender.title = "Sort by alf"
            filterMode = .alf*
        }*/
    }
}

//SEARCH
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        dataToShow = searchText.isEmpty ? controller.data : controller.data.filter { (item: Contact) -> Bool in
            
            return (item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || item.number.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
        }
        tableView.reloadData()
    }
}

//TABLEVIEW
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return dataToShow.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyCell
        cell.textLabel?.text = dataToShow[indexPath.row].name
        cell.contactId = dataToShow[indexPath.row].id
        cell.isSelected = false
        return cell
    }
    //DELETE with swipe
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)-> UISwipeActionsConfiguration?{
        let action = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            let alert = UIAlertController(title: "Delete", message: "Are you sure about that?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cansel", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.destructive, handler: { action in
                controller.deleteContact(Id: (self!.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! MyCell).contactId!)
                tableView.reloadData()
            }))
            self?.present(alert, animated: true, completion: nil)
            completionHandler(true)
        }
        action.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    //CELL CHOSEN
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        controller.currentContactId = (self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! MyCell).contactId!
        
        let vc = ContactTableViewController.getView(viewMode: .view, controller: controller)
        
        self.navigationController?.pushViewController(vc, animated: true)
        self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.isSelected = false
    }
}

class MyCell : UITableViewCell {
    var contactId: Int? = nil
}
