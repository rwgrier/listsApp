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
    open static let shared = DataSource()

    init() {
        _generateSampleData()
    }

    func list(at index: Int) -> List? {
        guard index >= 0 && index < lists.count else { return nil }
        return lists[index]
    }

    func index(of list: List) -> Int? {
        return lists.index(of: list)
    }

    func add(list: List) {
        lists.append(list)
        NotificationCenter.default.post(name: .listAdded, object: nil, userInfo: [NotificationKey.listId: list.id])
    }

    func delete(list: List) {
        guard let index = index(of: list) else { return }
        lists.remove(at: index)
        NotificationCenter.default.post(name: .listDeleted, object: nil, userInfo: [NotificationKey.listId: list.id])
    }

    func delete(at index: Int) {
        guard let list = list(at: index) else { return }
        lists.remove(at: index)
        NotificationCenter.default.post(name: .listDeleted, object: nil, userInfo: [NotificationKey.listId: list.id])
    }
}

// MARK: - Private Methods (Sample Data)

extension DataSource {
    private var _todoList: List {
        let list = List(title: "Things to do...")
        let watch = Item(title: "Watch Game of Thrones")
        let gutters = Item(title: "Clean the Gutters")

        list.add(item: watch)
        list.add(item: gutters)

        return list
    }

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

    private var _bucketList: List {
        let list = List(title: "Bucket List")
        let sail = Item(title: "Learn to Sail", description: "Because it sounds like fun")
        let drive = Item(title: "Drive Cross-Country")
        let app = Item(title: "Finish this app")
        let sleep = Item(title: "Sleep until noon")
        let europe = Item(title: "Travel to Europe")
        let fiveK = Item(title: "Run a 5k")

        fiveK.isCompleted = true

        list.add(item: sail)
        list.add(item: drive)
        list.add(item: app)
        list.add(item: sleep)
        list.add(item: europe)
        list.add(item: fiveK)

        return list
    }

    private var _emptyList: List {
        return List(title: "Empty list. I like 🌮s.")
    }

    private func _generateSampleData() {
        lists.append(_groceryList)
        lists.append(_todoList)
        lists.append(_bucketList)
        lists.append(_emptyList)
    }
}
