//
//  ViewController.swift
//  Todoey
//
//  Created by David Redondo on 8/24/18.
//  Copyright © 2018 David Redondo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // So our locally saved info shows here whenever the app comes back we need to specify here which item array shoudl be used
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }

    //MARK1 - Tableview Datasource Methods

    
    //Declare numberOfRowsInSection here, how many cells do we want and how many do we want to be displayed, we could display sections as well with a different command:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: the identifier we gave to our prototypecell table view identifier, for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell 
    }
    
    //MARK2 - TableView Delegate Methods
    //telling the system a row is selected, we are saying what do we want to happen when the row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        //deselect row when unclicking, it does not stay grey all the time
        tableView.deselectRow(at: indexPath, animated: true)
//get a check mark in the row
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
   //remove the check mark when clicking again, use an if statement to check if it has it already to take it out when clicking again
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    
        
    }
    
  //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Item to your list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks add new item button
            self.itemArray.append(textField.text!)
            
            self.tableView.reloadData() //we need to reload the table so the new item in the array is considered
            //where we add the item array to our defaults, so we do not lose info
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        
        //create text field within the action
    
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"            //text that will appear in grey
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
   
   
    
    
    
}

}
