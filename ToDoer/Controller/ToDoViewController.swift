//
//  ViewController.swift
//  ToDoer
//
//  Created by Shk Jassim Bin Hamad Al Thani on 1/9/18.
//  Copyright © 2018 MotivationQa. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController{

    
    // MARK: Global Variables
    
    var itemsArray = [ToDoItem]()
    let context  = ((UIApplication.shared.delegate) as? AppDelegate)?.persistentContainer.viewContext

    // MARK: Event handlers and LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // TODO: Add Task Adding process here
        
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style:.default, handler: { _ in
            
            if !localTextField.text!.isEmpty {
                
                let item  = ToDoItem(context: self.context!)
                item.title = localTextField.text!
                self.itemsArray.append(item)
                
               self.saveData()
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
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemsArray[indexPath.row].title
        cell.accessoryType = itemsArray[indexPath.row].done ? .checkmark : .none
        
        return cell
        
    }
   
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
         if let cell = tableView.cellForRow(at: indexPath){
        
            itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done

             self.saveData()
            cell.setSelected(false, animated: true)
        }
    }
    
    
    // MARK: Data Maipulation
    
    func  saveData()  {

        do{
            try context?.save()
            
        }catch{
            print("Can't save to the DB because: \(error)")
        }
       
        self.tableView.reloadData()
    }
    
    func  loadData(with request:NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest())  {
            do{
                try itemsArray = (context?.fetch(request))!
                tableView.reloadData()
            }catch{
                print("Can't retreive from the DB because: \(error)")
            }
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
            
            let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadData(with: request)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request)
    }
}

