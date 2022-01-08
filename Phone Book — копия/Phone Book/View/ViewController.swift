
import UIKit

protocol Observer: AnyObject {
  
  func update(subject: ContactManager)
}

enum FilterMode{
  case alf
  case date
}

var controller:ContactManager = ContactManager()
var filterMode:FilterMode = .alf


class ViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var dataToShow: [Contact]! = []
  
  override func viewWillAppear(_ animated: Bool) {
    let rightBtt = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
    let menuBtn = UIButton(type: .custom)
    menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
    menuBtn.setImage(UIImage(named:"sort_icon"), for: .normal)
    menuBtn.addTarget(self, action: #selector(filterButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    
    let leftBarItem = UIBarButtonItem(customView: menuBtn)
    let currWidth = leftBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
    currWidth?.isActive = true
    let currHeight = leftBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
    currHeight?.isActive = true
    
    self.navigationItem.rightBarButtonItems = [ rightBtt,leftBarItem]
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
  
  @IBAction func addButton(_ sender: UIButton) {
    let vc = ContactViewController.getView(viewMode: .create, controller: controller)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func filterButtonPressed(_ sender: UIBarButtonItem) {
    let optionMenu = UIAlertController(title: nil,
                                       message: "Choose Option",
                                       preferredStyle: .actionSheet)
    
    let deleteAction = UIAlertAction(title: "Sort by alf",
                                     style: .default) { [self] (UIAlertAction) in
      self.dataToShow.sort { $0.name < $1.name }
      tableView.reloadData()
    }
    let saveAction = UIAlertAction(title: "Sort by date",
                                   style: .default) { [self] (UIAlertAction) in
      self.dataToShow.sort { $0.creationDate < $1.creationDate }
      tableView.reloadData()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    optionMenu.addAction(deleteAction)
    optionMenu.addAction(saveAction)
    optionMenu.addAction(cancelAction)
    
    self.present(optionMenu, animated: true, completion: nil)
  }
}

//MARK: -UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    dataToShow = searchText.isEmpty ? controller.data : controller.data.filter { (item: Contact) -> Bool in
      return (item.name.range(of: searchText,
                              options: .caseInsensitive,
                              range: nil,
                              locale: nil) != nil
              || item.number.range(of: searchText,
                                   options: .caseInsensitive,
                                   range: nil,
                                   locale: nil) != nil)
    }
    tableView.reloadData()
  }
}

//MARK: -UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal,
                                    title: "Delete") { [weak self] (action, view, completionHandler) in
    guard let self = self else {
        return
      }
    let alert = UIAlertController(title: "Delete",
                                  message: "Are you sure about that?",
                                  preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Cansel",
                                  style: UIAlertAction.Style.default,
                                  handler: nil))
    alert.addAction(UIAlertAction(title: "Continue",
                                  style: UIAlertAction.Style.destructive,
                                  handler: { action in
      let id = (self.tableView.cellForRow(at: IndexPath(row: indexPath.row,
                                                        section: 0)) as! MyCell).contactId!
      controller.deleteContact(Id: id)
        tableView.reloadData()
      }))
      
      self.present(alert, animated: true, completion: nil)
      completionHandler(true)
    }
    action.backgroundColor = .black
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  //CELL CHOSEN
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    controller.currentContactId = (self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! MyCell).contactId!
    
    let vc = ContactViewController.getView(viewMode: .view, controller: controller)
    self.navigationController?.pushViewController(vc, animated: true)
    self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.isSelected = false
  }
}

//MARK: -
extension ViewController: Observer {
  func update(subject: ContactManager) {
    self.dataToShow = subject.data
    tableView.reloadData()
  }
}

class MyCell: UITableViewCell {
  var contactId: Int? = nil
}
