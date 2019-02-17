//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hardeep on 15/02/19.
//  Copyright © 2019 Hardeep. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadcategoties()

    }
    //MARK : -tableview datasourse methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added"
        
        
        return cell
    }
    
    
    
    
    
    //MARK : - tableview delegates methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow{
            
            destination.selectedCategory = categories?[indexpath.row]
            
            
        }
    }
    
    // MARK : - Add category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var  textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            
            let newcategory = Category()
            newcategory.name = textField.text!
            
            
            //self.defaults.set(self.itemArray, forKey: "TodoList")
            
            self.save(category: newcategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present (alert,animated: true , completion: nil)
        
        
    }
    
    //MARKS : -data manipulation methods
    func save(category: Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving Data \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadcategoties(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
}
    

