//
//  ContactViewController.swift
//  Phone Book
//
//  Created by User on 02.01.2022.
//

import Foundation
import UIKit


class ContactViewController: UIViewController{
    
    typealias ViewMode =  ContactTableViewController.ViewMode
    
    var viewMode: ViewMode = .view
    weak var controller:ContactManager?
    
    enum Segues {
        static let toContactTableView = "toContactTableView"
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    static func getView(viewMode:ViewMode,controller:ContactManager)-> ContactViewController{
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : ContactViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactScene") as! ContactViewController
        vc.viewMode = viewMode
        vc.controller = controller
        return vc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toContactTableView {
            /*let vc = segue.destination as! ContactTableViewController
            vc.viewMode = viewMode
            vc.controller = controller*/
        }
    }
    
    
}
