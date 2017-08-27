//
//  File.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation

class List: Equatable {
    let id: String = UUID().uuidString
    private (set) var title: String
    private (set) var dateCreated: Date = Date()
    private (set) var items: [Item] = []

    var itemCount: Int {
        return items.count
    }

    init(title: String) {
        self.title = title
    }

    func item(at index: Int) -> Item? {
        guard index < items.count else { return nil }
        return items[index]
    }

    func index(of item: Item) -> Int? {
        return items.index(of: item)
    }

    func add(item: Item) {
        items.append(item)
        NotificationCenter.default.post(name: .itemAdded, object: nil, userInfo: [NotificationKey.itemId: item.id, NotificationKey.listId: id])
    }

    func markAllAsCompleted() {
        items.forEach { (each) in
            each.isCompleted = true
        }
    }

    func delete(item: Item) {
        guard let index = index(of: item) else { return }
        items.remove(at: index)
        NotificationCenter.default.post(name: .itemDeleted, object: nil, userInfo: [NotificationKey.itemId: item.id, NotificationKey.listId: id])
    }

    func delete(at index: Int) {
        guard let item = item(at: index) else { return }
        items.remove(at: index)
        NotificationCenter.default.post(name: .itemDeleted, object: nil, userInfo: [NotificationKey.itemId: item.id, NotificationKey.listId: id])
    }
}

func == (lhs: List, rhs: List) -> Bool { return lhs.id == rhs.id }
func < (lhs: List, rhs: List) -> Bool { return lhs.id < rhs.id }
