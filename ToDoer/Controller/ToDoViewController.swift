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
    
    var itemsArray = [ToDoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")

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
                
                let item  = ToDoItem()
                item.Text = localTextField.text!
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
        
        cell.textLabel?.text = itemsArray[indexPath.row].Text
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
        
        let encoder = PropertyListEncoder()
        
        do{
            let encodedData = try encoder.encode(itemsArray)
            try encodedData.write(to: dataFilePath!)
            
        }catch{
            print("Can't encode the current list because: \(error)")
        }
       
        self.tableView.reloadData()
    }
    
    func  loadData()  {
        
        if let decodedData = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            
            do{
                itemsArray = try  decoder.decode([ToDoItem].self, from: decodedData)
            }catch{
                print("Can't decode the current list because: \(error)")
            }
        }
        
    }
    
}

