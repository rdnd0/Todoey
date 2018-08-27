//
//  ViewController.swift
//  Todoey
//
//  Created by David Redondo on 8/24/18.
//  Copyright © 2018 David Redondo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    //saving data to the local files
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(dataFilePath)
        //the manual way of creating items
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
 //new function so items come from the saved directory
        loadItems()
        
        // So our locally saved info shows here whenever the app comes back we need to specify here which item array should be used

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
    }

    //MARK1 - Tableview Datasource Methods

    
    //Declare numberOfRowsInSection here, how many cells do we want and how many do we want to be displayed, we could display sections as well with a different command:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // called initially
        //let cell = tableView.dequeueReusableCell(withIdentifier: the identifier we gave to our prototypecell table view identifier, for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row] //create new constant to make our coding simpler
        
        cell.textLabel?.text = item.title
        
//        //current alternative, before using ternary
//        if item.picked == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        

        //ternary operator as an alternative to shorten code, when should the cell be marked with what
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.picked ? .checkmark : .none
    
        
        return cell 
    }
    
    //MARK2 - TableView Delegate Methods
    //telling the system a row is selected, we are saying what do we want to happen when the row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
//get a check mark in the row
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
   //remove the check mark when clicking again, use an if statement to check if it has it already to take it out when clicking again
    
        //sets the current property to the opposite of what it is right now
    itemArray[indexPath.row].picked = !itemArray[indexPath.row].picked
        
        saveFiles()
        
        
      
//        tableView.reloadData() //so it takes into consideration the logic for marked/unmarked from the above code, commented out as it is already part of the function save files
        
   //original code before using class to create items
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        //deselect row when unclicking, it does not stay grey all the time
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
  //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Item to your list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks add new item button
            
            let newItem = Item() //creating a local constant out of our class
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            self.tableView.reloadData() //we need to reload the table so the new item in the array is considered
         
            //NSCoder, saving files locally
            self.saveFiles()
            
            
            
            
            
        }
        
        //create text field within the action
    
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"            //text that will appear in grey
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
   
   
    
    
    
}
    
    //MARK - Model Manipulation Methods
    // func to save files to the nscoder
    
    func saveFiles() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Error encoding item array, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do { itemArray = try decoder.decode([Item].self , from: data)
            } catch {
                print("Error decoding the array \(error)")
            }
        }
    }

}
