//
//  Item.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var isCompleted: Bool = false

    @objc dynamic var list: List?

    convenience init(title: String, description: String? = nil) {
        self.init()
        self.title = title
        self.desc = description
    }
}
