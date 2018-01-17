//
//  CategoriesViewController.swift
//  ToDoer
//
//  Created by Shk Jassim Bin Hamad Al Thani on 1/11/18.
//  Copyright © 2018 MotivationQa. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoriesViewController: UITableViewController {

    
    var categories : Results<Category>?
    
    let realm = try! Realm()
    
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
                
                let item  = Category()
                item.name = localTextField.text!
                
                self.saveData(newCategory: item)
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
        let _numberOfRowsInSection = categories?.count == 0 ? 1 : categories?.count ?? 1
        return _numberOfRowsInSection
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if   (categories?.count)! > 0 {
            let cat = categories?[indexPath.row]
            cell.textLabel?.text = cat?.name
            cell.accessoryType = .disclosureIndicator
        }else{
            cell.textLabel?.text =  "No cateegories added yet!"
        }
        
        return cell
    }
    
    
    // MARK: Data Maipulation
    
    func  saveData(newCategory: Category)  {
        
        do{
            try realm.write {
                realm.add(newCategory)
            }
        }catch{
            print("Can't save to the DB because: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func  loadData()  {
        
            categories = realm.objects( Category.self)
            tableView.reloadData()
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
            itemsVC.selectedCategory = self.categories?[(tableView.indexPathForSelectedRow?.row)!] 
        }
    }
    
    
    

}
