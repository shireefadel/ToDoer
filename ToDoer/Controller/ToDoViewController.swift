//
//  ViewController.swift
//  ToDoer
//
//  Created by Shk Jassim Bin Hamad Al Thani on 1/9/18.
//  Copyright © 2018 MotivationQa. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController{

    
    // MARK: Global Variables
    
    var itemsArray : [String] = ["Wake Up","Breakfast","Ride your car"]

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
                self.itemsArray.append(localTextField.text!)
                self.tableView.reloadData()
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
        cell.textLabel?.text = itemsArray[indexPath.row]
    
        
        return cell
        
    }
   
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
         if let cell = tableView.cellForRow(at: indexPath)
         {
        
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
            }
            else{
                cell.accessoryType = .checkmark
            }
            
            cell.setSelected(false, animated: true)
        }
    }
    
}

