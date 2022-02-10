
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
  @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
  @IBOutlet var searchFooter: SearchFooter!

 
  lazy var contacts = controller.data
  var filteredContacts:[Contact]!
  var dataToShow: [Contact]! {
    if isFiltering {
      return filteredContacts
    } else {
      return contacts
    }
  }
  var filtersOn: Bool = false
  var isFilteringBySearchBar: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  var isFiltering: Bool {
    return isFilteringBySearchBar || filtersOn
  }
  
  let searchController = UISearchController(searchResultsController: nil)
  
  override func viewWillAppear(_ animated: Bool) {
    let rightBtt = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
    let menuBtn = UIButton(type: .custom)
    menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
    menuBtn.setImage(UIImage(named:"sort_icon"), for: .normal)
    menuBtn.addTarget(self, action: #selector(sortButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    
    let leftBarItem = UIBarButtonItem(customView: menuBtn)
    let currWidth = leftBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
    currWidth?.isActive = true
    let currHeight = leftBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
    currHeight?.isActive = true
    
    self.navigationItem.rightBarButtonItems = [rightBtt, leftBarItem]
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Contacts"
    self.navigationItem.searchController = searchController
    filtersOn = false
    reloadTableViewData(with: "No contacts yet")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Phone Book"
    filteredContacts = contacts
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundView = nil
    //searchBar.delegate = self
    controller.attach(self)
    
    
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Contacts"
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                   object: nil, queue: .main) { (notification) in
                                    self.handleKeyboard(notification: notification) }
    notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                   object: nil, queue: .main) { (notification) in
                                    self.handleKeyboard(notification: notification) }
  }
  
  func handleKeyboard(notification: Notification) {
    // 1
    guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
      searchFooterBottomConstraint.constant = 0
      view.layoutIfNeeded()
      return
    }

    guard
      let info = notification.userInfo,
      let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
      else {
        return
    }

    // 2
    let keyboardHeight = keyboardFrame.cgRectValue.size.height
    UIView.animate(withDuration: 0.1, animations: { () -> Void in
      self.searchFooterBottomConstraint.constant = keyboardHeight
      self.view.layoutIfNeeded()
    })
  }
  
  @IBAction func addButton(_ sender: UIButton) {
    let vc = ContactViewControllerV2.getView(viewMode: .create, controller: controller, currentContact: nil)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //MARK: -Sort
  @objc func sortButtonPressed(_ sender: UIBarButtonItem) {
    let optionMenu = UIAlertController(title: nil,
                                       message: "Choose Option",
                                       preferredStyle: .actionSheet)
    
    let action1 = UIAlertAction(title: "Sort by alf",
                                     style: .default) { [self] (UIAlertAction) in
      self.filteredContacts.sort { if case let .name(value) = $0.mainFields.first(where: {$0.type == .name})?.value {
        if case let .name(value2) = $1.mainFields.first(where: {$0.type == .name})?.value {
          return value < value2
        }
      }
        return false
      }
      filtersOn = true
      reloadTableViewData(with: "No contacts yet")
    }
    let action2 = UIAlertAction(title: "Sort by date",
                                   style: .default) { [self] (UIAlertAction) in
      self.filteredContacts.sort {  if case let .date(value) = $0.mainFields.first(where: {$0.type == .dateOfCreation})?.value {
        if case let .date(value2) = $1.mainFields.first(where: {$0.type == .dateOfCreation})?.value {
          return value < value2
        }
      }
        return false
      }
      filtersOn = true
      reloadTableViewData(with: "No contacts yet")
    }
    let action1_reversed = UIAlertAction(title: "Sort by alf reversed",
                                   style: .default) { [self] (UIAlertAction) in
      self.filteredContacts.sort {  if case let .name(value) = $0.mainFields.first(where: {$0.type == .name})?.value {
        if case let .name(value2) = $1.mainFields.first(where: {$0.type == .name})?.value {
          return value > value2
        }
      }
        return false
      }
      filtersOn = true
      reloadTableViewData(with: "No contacts yet")
    }
    let action2_reversed = UIAlertAction(title: "Sort by date reversed",
                                   style: .default) { [self] (UIAlertAction) in
      self.filteredContacts.sort {  if case let .date(value) = $0.mainFields.first(where: {$0.type == .dateOfCreation})?.value {
        if case let .date(value2) = $1.mainFields.first(where: {$0.type == .dateOfCreation})?.value {
          return value > value2
        }
      }
        return false
        
      }
      filtersOn = true
      reloadTableViewData(with: "No contacts yet")
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    optionMenu.addAction(action1)
    optionMenu.addAction(action1_reversed)
    optionMenu.addAction(action2)
    optionMenu.addAction(action2_reversed)
    optionMenu.addAction(cancelAction)
    
    self.present(optionMenu, animated: true, completion: nil)
  }
  
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  //MARK: -search
  func filterContentForSearchText(_ searchText: String) {
    filteredContacts = contacts.filter { (contact: Contact) -> Bool in
      var result = false
      for field in contact.mainFields.filter{$0.type == .name} {
        if case let .name(myValue) = field.value {
          result = result || myValue.contains(searchText.lowercased())
        }
      }
      for field in contact.mainFields.filter{$0.type == .number} {
        if case let .number(myValue) = field.value {
          result = result || myValue.contains(searchText.lowercased())
        }
      }
      
      
        return result
    }
    
    reloadTableViewData(with: "-")
  }
}


//MARK: -UITableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFilteringBySearchBar {
        searchFooter.setIsFilteringToShow(filteredItemCount:
          filteredContacts.count, of: contacts.count)
        return dataToShow.count
      }
      
      searchFooter.setNotFiltering()
      return dataToShow.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyCell
    var name:String = ""
    if case let .name(text) = dataToShow[indexPath.row].mainFields.first(where: {$0.type == .name})?.value {
       name = text == "" ? "Unnamed" : text
    }
    cell.textLabel?.text = name
    if case let .number(text) = dataToShow[indexPath.row].mainFields.first(where: {$0.type == .number})?.value {
      if name == "Unnamed" && text != "" {
        cell.detailTextLabel?.text = "Number: " + text
      } else {
        cell.detailTextLabel?.text = nil
      }
    }
    cell.contactId = dataToShow[indexPath.row].mainFields.first{$0.type == .id}?.value?.value() as! String
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
    alert.addAction(UIAlertAction(title: "Cancel",
                                  style: UIAlertAction.Style.default,
                                  handler: nil))
    alert.addAction(UIAlertAction(title: "Yes",
                                  style: UIAlertAction.Style.destructive,
                                  handler: { action in
      let id = (self.tableView.cellForRow(at: IndexPath(row: indexPath.row,
                                                        section: 0)) as! MyCell).contactId!
      controller.deleteContact(Id: id)
      self.reloadTableViewData(with: "No contacts yet")
      }))
      
      self.present(alert, animated: true, completion: nil)
      completionHandler(true)
    }
    action.backgroundColor = .black
    return UISwipeActionsConfiguration(actions: [action])
  }
  
  //CELL CHOSEN
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentContactId = (self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! MyCell).contactId!
    
    let vc = ContactViewControllerV2.getView(viewMode: .view,
                                           controller: controller,
                                           currentContact: controller.getContact(Id: currentContactId))
    self.navigationController?.pushViewController(vc, animated: true)
    self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.isSelected = false
  }
}

//MARK: -Observer
extension ViewController: Observer {
  func update(subject: ContactManager) {
    self.contacts = subject.data
    if isFiltering{
    self.filteredContacts = Array(Set(self.filteredContacts).intersection(Set(self.contacts)))
    }
    else {
      self.filteredContacts = contacts
    }
    reloadTableViewData(with: "No contacts yet")
  }
}

//MARK: -Custom UITableViewCell
class MyCell: UITableViewCell {
  var contactId: String? = nil
}

extension ViewController{
  func reloadTableViewData(with massage:String){
    if dataToShow.count == 0{
      let text = UITextView()
      text.text = massage
      text.textAlignment = .center
      text.isEditable = false
      tableView.backgroundView = text
      tableView.separatorStyle = .none
    }
    else{
      tableView.backgroundView = nil
    }
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

extension ViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

/*extension ViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category = Candy.Category(rawValue:
      searchBar.scopeButtonTitles![selectedScope])
    filterContentForSearchText(searchBar.text!, category: category)
  }
}
*/
