//
//  Category.swift
//  ToDoer
//
//  Created by Shk Jassim Bin Hamad Al Thani on 1/15/18.
//  Copyright © 2018 MotivationQa. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    let items = List<ToDoItem>()
}
