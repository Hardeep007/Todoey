//
//  swipeTableViewController.swift
//  Todoey
//
//  Created by Hardeep on 17/02/19.
//  Copyright © 2019 Hardeep. All rights reserved.
//

import UIKit
import SwipeCellKit

class swipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 64.0
    }
    //MARK:- tableview methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
         cell.delegate = self as? SwipeTableViewCellDelegate
        
        
        return cell
    }
   
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                print("delete cell ")
               self.updateModel(at: indexPath)

            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            
            return [deleteAction]
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }
        
    func updateModel(at indexPath: IndexPath){
        //update the data
        
    }
    
}
