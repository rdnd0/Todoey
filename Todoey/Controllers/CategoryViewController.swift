//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Redondo on 8/28/18.
//  Copyright © 2018 David Redondo. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //initialize new realm
    
    let realm = try! Realm() //initialize realm
    
    var categories : Results<Category>? //collection of results
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
   
  

    

    // MARK: - Table view data source methods
    //2 mandatory functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) //the identifier categorycell needs to match with our mainstoryboard!
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    //what happens when we click in a cell
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }}
        catch {
         print("Error saving category \(error)")
        }
        
        
        tableView.reloadData()
    }
    //function used to load data from realm
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData() //calls data source methods
    
    }
    
    // MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category() //create new category
            
            newCategory.name = textField.text! //give category a name
            
            self.save(category: newCategory) //save method to save to our DB.. see function created for this
        }
            alert.addAction(action)
        
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "Add new category"
            }
                present(alert, animated: true, completion: nil)
    }
    

   
}
