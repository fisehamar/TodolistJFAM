//
//  ViewController.swift
//  TodolistJFAM
//
//  Created by Fiseha Gezahegn on 3/25/19.
//  Copyright © 2019 Fiseha Gezahegn. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemsArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemPlist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    
//        let newItem = Item()
//        newItem.itemName = "First Item"
//        itemsArray.append(newItem)
//
//        let otherItem = Item()
//        otherItem.itemName =  "SecondItem"
//        itemsArray.append(otherItem)
//
//        let thirdItem = Item()
//        thirdItem.itemName = "Buy grossory items"
//        itemsArray.append(thirdItem)
//
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: "AddItem") as? [Item] {
//
//           itemsArray = items
//        }
    }
    
    //MARK - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCellItem", for: indexPath)
        
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.itemName
        
        cell.accessoryType = item.done ? .checkmark : .none
        
    
        return cell
    }
    
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      //print(itemArray[indexPath.row])
        
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
            
            let newItem = Item()
            newItem.itemName = textField.text!
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
        
        let encoder =  PropertyListEncoder()
        
        do {
            
           let data = try encoder.encode(itemsArray)
            
            // write the data to the file path that specified
            
            try data.write(to: dataFilePath!)
        
            
        } catch {
            
            print("Error in encoding items arry \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // MARK - laods data from the poroperty list
    
    func loadItems () {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            
            do {
                
                itemsArray = try decoder.decode([Item].self, from: data)
                
                
            } catch {
                print("Error in decoding items array \(error)")
            }
        }
        
    }
    

}

