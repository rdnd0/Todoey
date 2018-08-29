//
//  Category.swift
//  Todoey
//
//  Created by David Redondo on 8/28/18.
//  Copyright © 2018 David Redondo. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
