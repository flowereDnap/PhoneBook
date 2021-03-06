
import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase




protocol Observer: AnyObject {
  
  func update(subject: DataManager)
}

enum SortType: String , Decodable, CaseIterable{
  case alph = "Alph"
  case reAlph = "Re-alph"
  case date = "Date"
  case reDate = "Re-date"
}




class ViewController: UIViewController {

  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
  @IBOutlet var searchFooter: SearchFooter!
  
  
  
  var sortMode:SortType = .alph
  
  var contacts: [Contact] {
    get{
      let data = DataManager.data
      return data
    }
    set {
      DataManager.data = newValue
      filteredContacts = newValue
      self.reloadTableViewData(with: "")
    }
  }
  
  var filteredContacts: [Contact]!
  var searchFoundInField: [Int]!
  var dataToShow: [Contact]! {
    if isFiltering {
      return filteredContacts
    } else {
      return contacts
    }
  }
  var isFilteringBySearchBar: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  var isFiltering: Bool {
    return isFilteringBySearchBar
  }
  
  let searchController = UISearchController(searchResultsController: nil)
  
   func setUpView() {
     let rightBtt = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
    rightBtt.tintColor = .black
    let menuBtn = UIButton(type: .custom)
    menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
    menuBtn.setImage(UIImage(named:"sort_icon"), for: .normal)
    
    menuBtn.showsMenuAsPrimaryAction = true
    menuBtn.menu = makeFiltersMenu()
    
    let leftBarItem = UIBarButtonItem(customView: menuBtn)
    let currWidth = leftBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
    currWidth?.isActive = true
    let currHeight = leftBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
    currHeight?.isActive = true
    
    let menuBtn2 = UIButton(type: .custom)
    menuBtn2.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
    menuBtn2.setImage(UIImage(named:"settingsIcon"), for: .normal)
    menuBtn2.showsMenuAsPrimaryAction = true
    menuBtn2.contentMode = .scaleAspectFill
    menuBtn2.menu = makeSettingsMenu()
    
    let leftBarItem2 = UIBarButtonItem(customView: menuBtn2)
    let currWidth2 = leftBarItem2.customView?.widthAnchor.constraint(equalToConstant: 44)
    currWidth2?.isActive = true
    let currHeight2 = leftBarItem2.customView?.heightAnchor.constraint(equalToConstant: 44)
    currHeight2?.isActive = true
    
    self.navigationItem.rightBarButtonItems = [rightBtt, leftBarItem]
    self.navigationItem.leftBarButtonItems = [leftBarItem2]
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Contacts"
    self.navigationItem.searchController = searchController
    
    sortContacts(sorter: sortMode)
    reloadTableViewData(with: "No contacts yet")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    LoadingViewController.parentView = self
    setUpView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    LoadingViewController.parentView = self as UIViewController
    setUpView()
    
    tableView?.register(ContactTableViewCell.nib, forCellReuseIdentifier: ContactTableViewCell.identifier)
    tableView?.rowHeight = UITableView.automaticDimension
    tableView?.estimatedRowHeight = 80
    
    title = "Phone Book"
    filteredContacts = contacts
    searchFoundInField = []
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundView = nil
    //searchBar.delegate = self
    DataManager.contactsView = self
    
    
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Contacts"
    //searchController.searchBar.scopeButtonTitles = Filters.allCases.map{$0.rawValue}
    //searchController.searchBar.delegate = self
    
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
    
    let keyboardHeight = keyboardFrame.cgRectValue.size.height
    UIView.animate(withDuration: 0.1, animations: { () -> Void in
      self.searchFooterBottomConstraint.constant = keyboardHeight
      self.view.layoutIfNeeded()
    })
  }
  
  @IBAction func addButton(_ sender: UIButton) {
    let newContact = DataManager.addContact()
    let vc = ContactViewController.getView(viewMode: .create, currentContact: newContact)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  @objc func settingsButtonPressed(_ sender: UIBarButtonItem) {
    
  }
  
  //MARK: -search
  func filterContentForSearchText(_ searchText: String) {
    filteredContacts = contacts.filter{ (contact: Contact) -> Bool in
      for field in contact.mainFields.filter({$0.type == .name}) {
        
        guard let text = field.value as? String else {
          break
        }
        if !text.contains(searchText.lowercased()) {
          continue
        }
        
        let attributeTxt = NSMutableAttributedString(string: text)
        let range: NSRange = attributeTxt.mutableString.range(of: searchText,
                                                              options: .caseInsensitive)
        let color: UIColor = .red
        attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor,
                                  value: color,
                                  range: range)
        contact.searchFoundIn = attributeTxt
        return true
        
      }
      for field in contact.mainFields.filter({$0.type == .number}) {
        guard let text = field.value as? String else {
          break
        }
        if !text.contains(searchText.lowercased()) {
          continue
        }
        
        let attributeTxt = NSMutableAttributedString(string: text)
        let range: NSRange = attributeTxt.mutableString.range(of: searchText,
                                                              options: .caseInsensitive)
        let color: UIColor = .red
        attributeTxt.addAttribute(NSAttributedString.Key.foregroundColor,
                                  value: color,
                                  range: range)
        contact.searchFoundIn = attributeTxt
        return true
      }
      return false
    }
    self.reloadTableViewData(with: "-")
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
      print(dataToShow.count)
      return dataToShow.count
    }
    
    searchFooter.setNotFiltering()
    return dataToShow.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //new cell
    let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
    print(dataToShow.count)
    let contact = dataToShow[indexPath.row]
    cell.setUpCell(contact: contact, isFilteringBySearchBar: self.isFilteringBySearchBar)
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
        DataManager.deleteContact(id: id)
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
    let vc = ContactViewController.getView(viewMode: .view,
                                           currentContact: contacts.first{$0.id == currentContactId}!)
    self.navigationController?.pushViewController(vc, animated: true)
    self.tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.isSelected = false
  }
}

//MARK: -Observer

//MARK: -Custom UITableViewCell
class MyCell: UITableViewCell {
  var contactId: String? = nil
}

extension ViewController {
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

extension ViewController {
  
  func makeSettingsMenu()-> UIMenu{
    let settingsButtonTitles = ["Data provider", "User", "Logaout"]
    var actions: [UIAction] = []
    let action1 =  UIAction(title: settingsButtonTitles[0]) { _ in
      let optionMenu = UIAlertController(title: nil,
                                         message: "Choose Option",
                                         preferredStyle: .actionSheet)
      
      for type in DataProv.allCases {
        
        var title = "Save to \(type.rawValue)"
        var isEnabled = true
        var titleColor = UIColor.black
        if type == DataManager.dataProvType{
          title = "Saved to \(type.rawValue)"
          titleColor = .gray
          isEnabled = false
        }
        
        let action = UIAlertAction(title: title,
                                   style: .default) { [self] (UIAlertAction) in
          
          
          if type == .server {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc: LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginScene") as! LoginViewController
            vc.parentView = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc , animated: true, completion: nil)
          } else {
            DataManager.dataProvType = type
            setUpView()
            self.showToast(message: "Loaded with \(type.rawValue)")
          }
        }
        action.titleTextColor = titleColor
        action.isEnabled = isEnabled
        optionMenu.addAction(action)
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      optionMenu.addAction(cancelAction)
      
      self.present(optionMenu, animated: true, completion: nil)
    }
    actions.append(action1)
    
    if DataManager.dataProvType == .server {
      let action2 = UIAction(title: settingsButtonTitles[1]) { _ in
        let vc = UserSettingsViewController().getView()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc , animated: true, completion: nil)
      }
      actions.append(action2)
      let action3 = UIAction(title: settingsButtonTitles[2]) { _ in
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          ApiClient.user = nil
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: LoginViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginScene") as! LoginViewController
        vc.parentView = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc , animated: true, completion: nil)
      }
      actions.append(action3)
    }
    
    return UIMenu(title: "Settings",
                  options: .displayInline,
                  children: actions)
  }
  
  
  func makeFiltersMenu()
  -> UIMenu {
    
    let filterButtonTitles = SortType.allCases.map{$0.rawValue}
    let filterActions = filterButtonTitles
      .enumerated()
      .map { (index, title) -> UIAction in
        
        
        
        let action = UIAction(title: title,
                              identifier: UIAction.Identifier(title),
                              handler: self.filterHandler)
        if title == self.sortMode.rawValue {
          action.title = "Sorted by " + title
          action.state = .on
        } else {
          action.title = title
          action.state = .off
        }
        
        return action
      }
    
    return UIMenu(title: "Sorts",
                  options: .displayInline,
                  children: filterActions)
  }
  
  func filterHandler(from action: UIAction) {
    guard let filter = SortType(rawValue: action.identifier.rawValue) else {
      return
    }
    
    self.sortMode = filter
    var toastText: String
    switch filter {
    case .alph:
      toastText = "Sorted by alphabet"
    case .date:
      toastText = "Sorted by date"
      
    case .reAlph:
      toastText = "Reverse sorted by alphabet"
    case .reDate:
      toastText = "Reverse sorted by date"
    }
    sortContacts(sorter: filter)
    let rightBtt = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
    let menuBtn = UIButton(type: .custom)
    menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
    menuBtn.setImage(UIImage(named:"sort_icon"), for: .normal)
    menuBtn.showsMenuAsPrimaryAction = true
    menuBtn.menu = makeFiltersMenu()
    
    let leftBarItem = UIBarButtonItem(customView: menuBtn)
    let currWidth = leftBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
    currWidth?.isActive = true
    let currHeight = leftBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
    currHeight?.isActive = true
    
    self.navigationItem.rightBarButtonItems = [rightBtt, leftBarItem]
    showToast(message: toastText)
    
  }
  func sortContacts(sorter:SortType){
    switch sorter {
    case .alph:
      self.contacts.sort {
        let val1 = $0.mainFields.first{$0.type == .name}?.value as? String ?? ""
        let val2 = $1.mainFields.first{$0.type == .name}?.value as? String ?? ""
        return val1 < val2
      }
    case .date:
      self.contacts.sort {
        let val1 = $0.dateOfCreation
        let val2 = $1.dateOfCreation
        return val1 < val2
      }
    case .reAlph:
      self.contacts.sort {
        let val1 = $0.mainFields.first{$0.type == .name}?.value as? String ?? ""
        let val2 = $1.mainFields.first{$0.type == .name}?.value as? String ?? ""
        return val1 > val2
      }
    case .reDate:
      self.contacts.sort {
        let val1 = $0.dateOfCreation
        let val2 = $1.dateOfCreation
        return val1 > val2
      }
    }
    reloadTableViewData(with: "")
  }
}

