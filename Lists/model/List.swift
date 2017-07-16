//
//  File.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation

class List {
    var title: String
    var dateCreated: Date = Date()
    var items: [Item] = []

    init(title: String) {
        self.title = title
    }

    func add(item: Item) {
        items.append(item)
    }

    func markAllAsCompleted() {
        items.forEach { (each) in
            each.isCompleted = true
        }
    }
}
