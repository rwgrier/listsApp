//
//  Item.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation

class Item: Equatable {
    let id: String = UUID().uuidString
    private (set) var title: String
    private (set) var description: String?
    private (set) var dateCreated: Date = Date()
    var isCompleted: Bool = false

    init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }
}

func == (lhs: Item, rhs: Item) -> Bool { return lhs.id == rhs.id }
func < (lhs: Item, rhs: Item) -> Bool { return lhs.id < rhs.id }
