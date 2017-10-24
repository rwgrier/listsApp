//
//  ItemsViewController.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsViewController: UITableViewController {
    private var notificationToken: NotificationToken?
    var list: List? {
        didSet { title = list?.title }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem(_:)))
        navigationItem.rightBarButtonItem = addButton
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
        super.viewWillAppear(animated)
        setupObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownObservers()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            guard let controller = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController else { return }

            controller.item = list?.items[row]
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        } else if segue.identifier == "showAddEdit" {
            guard let controller = (segue.destination as? UINavigationController)?.topViewController as? AddItemViewController else { return }
            controller.owningList = list
        }
    }

    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAddEdit", sender: self)
    }
}

// MARK: - UITableViewDelegate

extension ItemsViewController {
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction]? = nil

        let isCompleted = list?.items[indexPath.row].isCompleted ?? false
        let actionTitle = NSLocalizedString(isCompleted ? "Mark not completed" : "Mark completed", comment: "")
        let completedAction = UITableViewRowAction(style: .default, title: actionTitle, handler: { (_, indexPath) -> Void in
            guard let item = self.list?.items[indexPath.row] else { return }
            try? RealmDataSource.shared.mark(item: item, asCompleted: !item.isCompleted)
        })
        completedAction.backgroundColor = view.tintColor

        let deleteTitle = NSLocalizedString("Delete", comment: "")
        let deleteAction = UITableViewRowAction(style: .destructive, title: deleteTitle, handler: { (_, indexPath) -> Void in
            guard let item = self.list?.items[indexPath.row] else { return }

            try? RealmDataSource.shared.delete(item: item)
        })

        actions = [deleteAction, completedAction]

        return actions
    }
}

// MARK: - UITableViewDataSource

extension ItemsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.itemCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

        cell.textLabel?.text = list?.items[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, let item = list?.items[indexPath.row] else { return }

        try? RealmDataSource.shared.delete(item: item)
    }
}

// MARK: Notifications

extension ItemsViewController {
    private func setupObservers() {
        notificationToken = list?.items.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let strongSelf = self else { return }
            switch changes {
            case .initial:
                strongSelf.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                strongSelf.tableView.beginUpdates()
                strongSelf.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                strongSelf.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                strongSelf.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                strongSelf.tableView.endUpdates()
            case .error(let error):
                print("ERROR: \(error)")
            }
        })
    }

    private func tearDownObservers() {
        notificationToken?.invalidate()
        notificationToken = nil
    }
}
