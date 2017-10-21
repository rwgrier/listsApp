//
//  DetailViewController.swift
//  Lists
//
//  Created by Ryan Grier on 7/15/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var createdLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var completedSwitch: UISwitch!
    @IBOutlet private var descriptionTextView: UITextView!

    @IBOutlet private var emptyView: UIView!

    private var notificationToken: NotificationToken?
    var item: Item? {
        willSet { tearDownObservers() }
        didSet {
            title = item?.title
            setupObservers()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEmptyView()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupObservers()
        configureView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownObservers()
    }

    @IBAction func completedSwitchChanged(_ sender: UISwitch) {
        guard completedSwitch == sender, let item = item else { return }
        try? RealmDataSource.shared.mark(item: item, asCompleted: sender.isOn)
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
        guard notificationToken == nil else { return }
        notificationToken = item?.observe({ [weak self] (change: ObjectChange) in
            guard let strongSelf = self else { return }
            defer { strongSelf.configureView() }

            switch change {
            case .deleted:  strongSelf.item = nil
            default:        break
            }
        })
    }

    private func tearDownObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}
