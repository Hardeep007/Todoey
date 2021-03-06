//
//  ViewController.swift
//  Todoey
//
//  Created by Hardeep on 16/01/19.
//  Copyright © 2019 Hardeep. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: swipeTableViewController {

   let realm = try! Realm()
    var todoitems: Results<Item>?
     let dataFilePath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
    
    @IBOutlet weak var searchBar: UISearchBar!
    
  
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
         tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colourHex = selectedCategory?.colour else { fatalError() }
        
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }

    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError()}
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
        
    }
    
    
    //MARK :- TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoitems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let items = todoitems?[indexPath.row]{
            cell.textLabel?.text = items.title
            cell.accessoryType = items.done ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoitems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
   
        }else {
            
            cell.textLabel?.text = "No items added "
        }
        
        return cell
    }

    //MARK :- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoitems?[indexPath.row]{
            do{
                try self.realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving Done marks \(error)")
            }
        }
     
       
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    //MARK :- Add New Item
    
    @IBAction func addIButtonPressed(_ sender: UIBarButtonItem) {
        
   var  textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
           
            if let currentCategory = self.selectedCategory{
                
                if textField.text != "" {
                        do{
                            try self.realm.write {
                                let newItem = Item()
                                newItem.title = textField.text!
                                newItem.dateCreated = Date()
                                currentCategory.items.append(newItem)
                            }
                        }catch{
                            print("error in saveing \(error)")
                        }
                    }
                  self.tableView.reloadData()
                }
            }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present (alert,animated: true , completion: nil)
        
    }
    
   
    
    func loadItems(){
        
        todoitems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let items = todoitems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(items)
                }
            } catch{
                print("error in Deleting category \(error) ")
            }
        }
    }
    
    
}


 //MARK : search bar methods
extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoitems = todoitems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
    tableView.reloadData()
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


