//
//  ViewController.swift
//  Todoey
//
//  Created by Hardeep on 16/01/19.
//  Copyright © 2019 Hardeep. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
  //  let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        
        print(dataFilePath)
        
        let newItem = Item()
        newItem.title = "First"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "First"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "First"
        itemArray.append(newItem3)
      
        loadItems()
//        if let item = defaults.array(forKey: "TodoList") as? [Item]{
//            itemArray = item
//        }
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
            
            let newItem = Item()
            newItem.title = textField.text!
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
        let encode = PropertyListEncoder()
        do{
            let data = try encode.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error in encodeing ");
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error in decodeing \(error)")
            }
        }
    }
    
    
}

