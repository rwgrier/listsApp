//
//  AddItemViewController.swift
//  Lists
//
//  Created by Ryan Grier on 8/3/17.
//  Copyright © 2017 Ryan Grier. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var descriptionTextView: UITextView!

    var owningList: List?

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIBarButtonItem) {
        do {
            try validate()
            let title = titleTextField.text ?? ""
            let description = descriptionTextView.text
            let item = Item(title: title, description: description)

            owningList?.add(item: item)
            dismiss(animated: true, completion: nil)
        } catch {
            // Since we only throw a missing title, we only need to deal with one error
            let alert = UIAlertController(title: "Error", message: "Please enter a title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            present(alert, animated: true, completion: nil)
        }
    }

    private func validate() throws {
        guard let text = titleTextField.text, !text.isEmpty else { throw ValidationError.missingTitle }
    }
}

private enum ValidationError: Error {
    case missingTitle
}
