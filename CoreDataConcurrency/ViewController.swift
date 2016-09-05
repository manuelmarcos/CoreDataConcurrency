//
//  ViewController.swift
//  CoreDataConcurrency
//
//  Created by Manuel Marcos Regalado on 05/09/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var people = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Data Concurrency"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addNavButtonTapped))
    }

    func addNavButtonTapped() {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .Alert)

        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action: UIAlertAction) -> Void in
                                        let textField = alert.textFields!.first
                                        self.people.append((textField?.text)!)
                                        self.tableView.reloadData()
        })

        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }

        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.view.setNeedsLayout()
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }

    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(tableView: UITableView,
                   cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell!.textLabel!.text = people[indexPath.row]
        return cell!
    }
}
