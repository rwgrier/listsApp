//
//  RealmDataSource.swift
//  Lists
//
//  Created by Ryan Grier on 9/19/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataSource {
    static let shared = RealmDataSource()

    init() {
        defer { printRealmLocation() }
        migrateIfNeeded()

        guard !_hasData() else { return }
        _generateSampleData()
    }

    @discardableResult
    func createList(with title: String) throws -> List {
        let list = List(title: title)
        let realm = try Realm()

        try realm.write {
            realm.add(list)
        }

        return list
    }

    @discardableResult
    func createItem(with title: String, description: String? = nil, inList list: List) throws -> Item {
        let item = Item(title: title, description: description)
        item.list = list
        let realm = try Realm()

        try realm.write {
            realm.add(item)
        }

        return item
    }

    func delete(list: List) throws {
        let realm = try Realm()

        try realm.write {
            realm.delete(list.items)
            realm.delete(list)
        }
    }

    func delete(item: Item) throws {
        let realm = try Realm()

        try realm.write {
            realm.delete(item)
        }
    }

    func getItems() throws -> Results<List> {
        let realm = try Realm()

        return realm.objects(List.self)
    }

    func mark(item: Item, asCompleted completed: Bool) throws {
        let realm = try Realm()

        try realm.write {
            item.isCompleted = completed
        }
    }

    private func migrateIfNeeded() {
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        _ = try? Realm()
    }

    private func printRealmLocation() {
        let realm = try? Realm()

        guard let filePath = realm?.configuration.fileURL?.absoluteString else { return }
        print("Realm path = \(filePath)")
    }
}

// MARK: - Sample Data

extension RealmDataSource {
    private func _hasData() -> Bool {
        let realm = try? Realm()
        let items = realm?.objects(Item.self)

        return (items?.count ?? 0 > 0)
    }

    private func _generateSampleData() {
        _generateTodoList()
        _generateGroceryList()
        _generateBucketList()
        _generateEmptyList()
    }

    private func _generateTodoList() {
        do {
            let list = try createList(with: "Things to do...")

            try createItem(with: "Watch Game of Thrones", inList: list)
            try createItem(with: "Clean the Gutters", inList: list)
        } catch let error {
            print("Failed to write data: \(error)")
        }
    }

    private func _generateGroceryList() {
        do {
            let list = try createList(with: "Grocery List")

            try createItem(with: "Milk", inList: list)
            try createItem(with: "Bread", inList: list)
            try createItem(with: "1 dozen eggs", inList: list)
        } catch let error {
            print("Failed to write data: \(error)")
        }
    }

    private func _generateBucketList() {
        do {
            let list = try createList(with: "Bucket List")

            try createItem(with: "Learn to Sail", description: "Because it sounds like fun", inList: list)
            try createItem(with: "Drive Cross-Country", inList: list)
            try createItem(with: "Finish this app", inList: list)

            try createItem(with: "Sleep until noon", inList: list)
            try createItem(with: "Travel to Europe", inList: list)
            let fiveK = try createItem(with: "Run a 5k", inList: list)

            let realm = try Realm()
            try realm.write {
                fiveK.isCompleted = true
            }
        } catch let error {
            print("Failed to write data: \(error)")
        }
    }

    private func _generateEmptyList() {
        do {
            try createList(with: "Empty list. I like 🌮s.")
        } catch let error {
            print("Failed to write data: \(error)")
        }
    }
}
