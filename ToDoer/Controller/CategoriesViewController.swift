//
//  CategoriesViewController.swift
//  ToDoer
//
//  Created by Shk Jassim Bin Hamad Al Thani on 1/11/18.
//  Copyright © 2018 MotivationQa. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UITableViewController {

    
    var categoriesArray = [Category]()
    let context  = ((UIApplication.shared.delegate) as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()
    }

    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style:.default, handler: { _ in
            
            if !localTextField.text!.isEmpty {
                
                let item  = Category(context: self.context!)
                item.title = localTextField.text!
                self.categoriesArray.append(item)
                
                self.saveData()
            }
            
        }))
        
        alert.addTextField { (innerTextField) in
            
            innerTextField.placeholder = "Add New Category"
            localTextField = innerTextField
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        // cell.detailTextLabel? returns nil
        cell.detailTextLabel?.text = "\(categoriesArray[indexPath.row].childItems!.count)"
        
        return cell
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
    
    func  loadData(with request:NSFetchRequest<Category> = Category.fetchRequest())  {
        do{
            try categoriesArray = (context?.fetch(request))!
            tableView.reloadData()
        }catch{
            print("Can't retreive from the DB because: \(error)")
        }
    }
    
    
    //MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let itemsVC = segue.destination as? ToDoViewController{
            itemsVC.selectedCategory = self.categoriesArray[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    

}
