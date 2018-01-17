//
//  ViewController.swift
//  ToDoer
//
//  Created by Shk Jassim Bin Hamad Al Thani on 1/9/18.
//  Copyright © 2018 MotivationQa. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoViewController: UITableViewController{

    
    // MARK: Global Variables
    
    var todoItems : Results<ToDoItem>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            self.navigationItem.title = selectedCategory?.name
            loadData()
        }
    }

    // MARK: Event handlers and LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // TODO: Add Task Adding process here
        
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style:.default, handler: { _ in
            
            if !localTextField.text!.isEmpty {
                

                
                do{
                    try self.realm.write {
                        let item  = ToDoItem()
                        item.title = localTextField.text!
                        item.done = false
                        
                        self.selectedCategory?.items.append(item)
                    }
                    
                   self.tableView.reloadData()
                }catch{
                    
                }
            }
            
        }))
        
        alert.addTextField { (innerTextField) in
            
                innerTextField.placeholder = "Add New Item"
                localTextField = innerTextField
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    // MARK: TableView DataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let _numberOfRowsInSection = todoItems?.count == 0 ? 1 : todoItems?.count ?? 1
        return _numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if   (todoItems?.count)! > 0 {
            if let item  = todoItems?[indexPath.row]{
                cell.textLabel?.text = item.title
                cell.accessoryType = item.done ? .checkmark : .none
                
            }
        }
        else{
             cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
   
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                
            }
        }
         tableView.reloadData()
    }
    
    
    // MARK: Data Maipulation
    
    
    
    func  loadData()  {
            todoItems = selectedCategory?.items.sorted(byKeyPath: "createDate", ascending: false)
    }
}

extension ToDoViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchBar.text?.isEmpty)! {
            
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else{
            
            search(withTextIn: searchBar)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        search(withTextIn: searchBar)
    }
    
    func search(withTextIn searchBar: UISearchBar)  {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", (searchBar.text)!).sorted(byKeyPath: "createDate", ascending: false)
        
    }
}

