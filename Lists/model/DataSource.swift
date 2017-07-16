//
//  DataSource.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation

class DataSource {
    var lists: [List] = []
    let shared = DataSource()

    init() {
        _generateSampleData()
    }
}

// MARK: - Private Methods (Sample Data)

extension DataSource {

    private var _groceryList: List {
        let list = List(title: "Grocery List")
        let milk = Item(title: "Milk")
        let bread = Item(title: "Bread")
        let eggs = Item(title: "1 dozen eggs")

        list.add(item: milk)
        list.add(item: bread)
        list.add(item: eggs)

        return list
    }

    private func _generateSampleData() {
        lists.append(_groceryList)
    }
}
