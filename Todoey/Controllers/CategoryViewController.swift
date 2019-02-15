//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hardeep on 15/02/19.
//  Copyright © 2019 Hardeep. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext//core data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadcategoties()

    }
    //MARK : -tableview datasourse methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        
        return cell
    }
    
    
    
    
    
    //MARK : - tableview delegates methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow{
            
            destination.selectedCategory = categories[indexpath.row]
            
            
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var  textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            
            let newcategory = Category(context: self.context)
            newcategory.name = textField.text!
            self.categories.append(newcategory)
            
            //self.defaults.set(self.itemArray, forKey: "TodoList")
            
            self.saveNewCategory()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present (alert,animated: true , completion: nil)
        
        
    }
    
    //MARKS : -data manipulation methods
    func saveNewCategory(){
        
        do{
            try context.save()
        }catch{
            print("Error saving Data \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadcategoties(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        
        do {
            categories = try context.fetch(request)
        }catch{
            print("Error in fetchinnd data \(error)")
        }
        tableView.reloadData()
    }
    
    
}
    

