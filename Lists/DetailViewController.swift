//
//  DetailViewController.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var createdLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var completedSwitch: UISwitch!
    @IBOutlet private var descriptionTextView: UITextView!

    @IBOutlet private var emptyView: UIView!

    var item: Item? { didSet { title = item?.title } }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEmptyView()
        configureView()
        setupObservers()
    }

    deinit {
        tearDownObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }

    @IBAction func completedSwitchChanged(_ sender: UISwitch) {
        guard completedSwitch == sender else { return }
        item?.isCompleted = sender.isOn
    }

    func configureView() {
        if item == nil {
            configureEmptyView()
        } else {
            configureViewWithItem()
        }
    }

    private func configureEmptyView() {
        title = ""
        view.bringSubview(toFront: emptyView)
    }

    private func configureViewWithItem() {
        title = item?.title
        idLabel.text = item?.id
        createdLabel.text = item?.dateCreated.description
        titleLabel.text = item?.title
        completedSwitch.isOn = (item?.isCompleted ?? false)
        descriptionTextView.text = item?.description
        view.sendSubview(toBack: emptyView)
    }

    private func setupEmptyView() {
        view.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: Notifications

extension DetailViewController {
    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: .itemDeleted, object: nil, queue: .main) { [weak self] (notification: Notification) in
            guard let strongSelf = self else { return }
            guard let item = strongSelf.item else { return }
            guard let itemId = notification.userInfo?[NotificationKey.itemId] as? String  else { return }
            guard item.id == itemId else { return }

            strongSelf.item = nil
            strongSelf.configureView()
        }
    }

    private func tearDownObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
