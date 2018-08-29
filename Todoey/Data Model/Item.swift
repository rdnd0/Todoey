//
//  Item.swift
//  Todoey
//
//  Created by David Redondo on 8/28/18.
//  Copyright © 2018 David Redondo. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") // property is linking to the fwd relationship
}
