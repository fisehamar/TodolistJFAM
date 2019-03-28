//
//  ViewController.swift
//  TodolistJFAM
//
//  Created by Fiseha Gezahegn on 3/25/19.
//  Copyright © 2019 Fiseha Gezahegn. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemsArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemPlist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) // check the path for the DB
        loadItems()
    

    }
    
    //MARK - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCellItem", for: indexPath)
        
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
    
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //print(itemArray[indexPath.row])
        
        // deleteing item from the context - first we need to handle from the context level and then from the temporary array
        
//        context.delete(itemsArray[indexPath.row])
//        itemsArray.remove(at: indexPath.row)
        
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
        // call saveItems method here to save bool type of data when we togglet the check mark
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK - Add new items
    
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happens when user tab on the Add icon
            
            // get the the persistanceStore container method forom the app delegate to work with manage object
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false // seting the valuse false to 'done' attributes because it defined as optional property in the database
            
            self.itemsArray.append(newItem)
            //self.defaults.setValue(self.itemsArray, forKey: "AddItem")
            
            self.saveItems()
            
        }
        // create a text field place holder as a local variable
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
            self.tableView.reloadData()
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK - Save Data
    func saveItems () {
        
        // let encoder =  PropertyListEncoder()
        
        do {
        
            try context.save()
        
            
        } catch {
            
            print("Error saving context\(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // MARK - laods data from the poroperty list
    
    func loadItems () {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            
            itemsArray = try context.fetch(request)
            
        } catch {
            
            print("Error fetchind data from the context \(error)")
        }
        
}

}


// MARK: - seatch delegate method

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        do {
            
            itemsArray = try context.fetch(request)
            
        } catch {
            
            print("Error fetching dat afrom the context \(error)")
        }
        
        tableView.reloadData()
    }
}
