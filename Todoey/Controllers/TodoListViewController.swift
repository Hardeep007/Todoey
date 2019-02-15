//
//  ViewController.swift
//  Todoey
//
//  Created by Hardeep on 16/01/19.
//  Copyright © 2019 Hardeep. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
     let dataFilePath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext//core data
  
    //  let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
       
        loadItems()

    }

    
    //MARK :- TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }else {
             cell.accessoryType = .none
        }
        
        return cell
    }

    //MARK :- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
       
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveNewItem()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    //MARK :- Add New Item
    
    @IBAction func addIButtonPressed(_ sender: UIBarButtonItem) {
        
   var  textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
           
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done=false
            self.itemArray.append(newItem)
            
           //self.defaults.set(self.itemArray, forKey: "TodoList")
            
           self.saveNewItem()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present (alert,animated: true , completion: nil)
        
    }
    
    func saveNewItem(){
        
        do{
          try context.save()
        }catch{
            print("Error saving Data \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){

       
        do {
             itemArray = try context.fetch(request)
        }catch{
            print("Error in fetchinnd data \(error)")
        }
        tableView.reloadData()
    }
    
    
}


// MARK : search bar methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       request.predicate  = NSPredicate.init(format: "title CONTSINS[cd] %@", searchBar.text!)
     
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        
        }
    }
        
}


