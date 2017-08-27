//
//  ItemsViewController.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var list: List? {
        didSet { title = list?.title }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addNewItem(_:)))
        navigationItem.rightBarButtonItem = addButton
        setupObservers()
    }

    deinit {
        tearDownObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            guard let controller = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController else { return }

            controller.item = list?.item(at: row)
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
            item.isCompleted = !item.isCompleted
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        })
        completedAction.backgroundColor = view.tintColor

        let deleteTitle = NSLocalizedString("Delete", comment: "")
        let deleteAction = UITableViewRowAction(style: .destructive, title: deleteTitle, handler: { (_, indexPath) -> Void in
            guard let list = self.list else { return }
            list.delete(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
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
        let item = list?.item(at: indexPath.row)

        cell.textLabel?.text = item?.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, let list = list else { return }
        list.delete(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

// MARK: Notifications

extension ItemsViewController {
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: .itemAdded, object: nil, queue: .main) { [weak self] (notification: Notification) in
            guard let strongSelf = self else { return }
            guard let list = strongSelf.list else { return }
            guard let listId = notification.userInfo?[NotificationKey.listId] as? String  else { return }
            guard list.id == listId else { return }

            strongSelf.tableView.reloadData()
        }
    }

    private func tearDownObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
