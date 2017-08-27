//
//  ListsViewController.swift
//  Lists
//
//  Created by Ryan Grier on 7/24/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import UIKit

class ListsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addNewList(_:)))
        navigationItem.rightBarButtonItem = addButton
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? false
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "showItems" else { return }
        guard let itemsViewController = segue.destination as? ItemsViewController else { return }
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        itemsViewController.list = DataSource.shared.list(at: row)
    }

    // MARK: - User actions

    @objc internal func addNewList(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New List", message: "Enter a name for the new list", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
        let save = UIAlertAction(title: "Save", style: .default, handler: { (_) in
            guard let title = alert.textFields?.first?.text else { return }
            let list = List(title: title)
            DataSource.shared.add(list: list)

            self.tableView.reloadData()
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
        return DataSource.shared.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let list = DataSource.shared.list(at: indexPath.row)

        cell.textLabel?.text = list?.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        DataSource.shared.delete(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
