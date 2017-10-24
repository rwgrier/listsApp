//
//  File.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation
import RealmSwift

class List: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String?
    @objc dynamic var dateCreated: Date = Date()

    var items = LinkingObjects(fromType: Item.self, property: "list")

    convenience init(title: String) {
        self.init()
        self.title = title
    }
}

// MARK: - Convenience

extension List {
    var itemCount: Int {
        return items.count
    }
}
