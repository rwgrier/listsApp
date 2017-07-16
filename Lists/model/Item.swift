//
//  Item.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation

class Item {
    var title: String
    var description: String?
    var dateCreated: Date = Date()
    var isCompleted: Bool = false

    init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }
}
