//
//  ListsConstants.swift
//  Lists
//
//  Created by Ryan Grier on 8/26/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let itemAdded = Notification.Name(rawValue: "com.ryangrier.lists.item.added")
    static let itemDeleted = Notification.Name(rawValue: "com.ryangrier.lists.item.delete")
    static let listAdded = Notification.Name(rawValue: "com.ryangrier.lists.list.added")
    static let listDeleted = Notification.Name(rawValue: "com.ryangrier.lists.list.deleted")
}

enum NotificationKey: String {
    case listId, itemId
}
