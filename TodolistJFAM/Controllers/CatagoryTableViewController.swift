//
//  CatagoryTableViewController.swift
//  TodolistJFAM
//
//  Created by Fiseha Gezahegn on 3/28/19.
//  Copyright © 2019 Fiseha Gezahegn. All rights reserved.
//

import UIKit
import CoreData

class CatagoryTableViewController: UITableViewController {
    
    var catagoryArray = [Catagory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCatagories()

        
    }


    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Catagor Name", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Catagory", style: .default) { (action) in
            
        let newCatagory = Catagory(context: self.context)
        newCatagory.name = textField.text!
        self.catagoryArray.append(newCatagory)
        //self.tableView.reloadData()
        self.saveCatagory()
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Catagory Name"
            textField = alertTextField
            self.tableView.reloadData()
        }
        
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
  
    //MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        cell.textLabel?.text = catagoryArray[indexPath.row].name
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "gotoItems", sender: self)
    
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this method needs to triggred before we perform the method defiend in the did select row delegate method
        
        let destinationVC = segue.destination as! TodoListViewController
        // grap the catagory that corospionds to the selected cell
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = catagoryArray[indexPath.row]
            
        }
    }
    
    //MARK: - Data Manipulations
    
    func saveCatagory () {
        
        do {
            
            try context.save()
            
            
        } catch {
            
            print("Erro saving the context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCatagories (with request: NSFetchRequest<Catagory> = Catagory.fetchRequest()) {
        
        do {
            
            catagoryArray = try context.fetch(request)
            
            
        } catch {
            print("Error fetching data from the context: \(error)")
        }
        tableView.reloadData()
    }
    
    

}


//MARK: Searh Delegate Methods

extension CatagoryTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Catagory> = Catagory.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        loadCatagories(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadCatagories()
           
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
