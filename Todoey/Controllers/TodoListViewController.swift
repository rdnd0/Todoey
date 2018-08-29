//
//  ViewController.swift
//  Todoey
//
//  Created by David Redondo on 8/24/18.
//  Copyright © 2018 David Redondo. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
             loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    //MARK:1 - Tableview Datasource Methods

    
    //Declare numberOfRowsInSection here, how many cells do we want and how many do we want to be displayed, we could display sections as well with a different command:
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoItems?.count ?? 1
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
       if let item = todoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
       else {
        cell.textLabel?.text = "No Items Added"
        }
        
        
    
        
        return cell 
    }
    
    //MARK:2 - TableView Delegate Methods
    //telling the system a row is selected, we are saying what do we want to happen when the row is selected
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        //update cells based on done property
        if let item = todoItems? [indexPath.row] {
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        
      
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item to your list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks add new item button - create and save new item
            //in the categories we did this differently as we had it in 2 steps (save items function)
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)//as we are within a sub category (items) we append it to an existing category
                }
                }catch {
                    print("Error saving new items, \(error)")
                }
                self.tableView.reloadData()
            }
            
        
                
            
            
           
            
            
            
            
        }
        
        //create text field within the action
    
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"            //text that will appear in grey
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
   
   
    
    
    
}
    
    //MARK: - Model Manipulation Methods
    // func to save files to the nscoder
    
//    func saveFiles() {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//
//        } catch {
//            print("Error encoding item array, \(error)")
//        }
//        tableView.reloadData()
//    }
//
    func loadItems() {
  
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
}
    
//MARK: - Search bar methods
   //alternative to have a separate place to exend our functionality (so we do not need to have the uisearchbar delegate on top
    extension TodoListViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated" , ascending: false)
            
            tableView.reloadData()
        
        }
        
        //what should happen when we dismiss search bar
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



