//
//  Item.swift
//  ToDoer
//
//  Created by Shk Jassim Bin Hamad Al Thani on 1/15/18.
//  Copyright © 2018 MotivationQa. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var createDate:Date = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
