//
//  ListsViewController.swift
//  Lists
//
//  Created by Ryan Grier on 7/24/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import UIKit
import RealmSwift

class ListsViewController: UITableViewController {
    private var notificationToken: NotificationToken?
    private var lists: Results<List>?

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewList(_:)))
        navigationItem.rightBarButtonItem = addButton

        lists = try? RealmDataSource.shared.getItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false
        super.viewWillAppear(animated)

        setupObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownObservers()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "showItems" else { return }
        guard let itemsViewController = segue.destination as? ItemsViewController else { return }
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        itemsViewController.list = lists?[row]
    }

    // MARK: - User actions

    @objc internal func addNewList(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New List", message: "Enter a name for the new list", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        let save = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            guard let title = alert.textFields?.first?.text else { return }
            _ = try? RealmDataSource.shared.createList(with: title)

            self.dismiss(animated: true, completion: nil)
        })

        alert.addTextField { (textField) in
            textField.placeholder = "List Name"
        }

        alert.addAction(cancel)
        alert.addAction(save)

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ListsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)

        cell.textLabel?.text = lists?[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let list = lists?[indexPath.row] else { return }
        try? RealmDataSource.shared.delete(list: list)
    }
}

extension ListsViewController {
    private func setupObservers() {
        notificationToken = lists?.observe({ [weak self] (changes: RealmCollectionChange) in
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
