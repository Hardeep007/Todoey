//
//  Category.swift
//  Todoey
//
//  Created by Hardeep on 17/02/19.
//  Copyright © 2019 Hardeep. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
     @objc dynamic var colour: String = ""
    
   let items = List<Item>()
}
