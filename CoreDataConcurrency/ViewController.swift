//
//  ViewController.swift
//  CoreDataConcurrency
//
//  Created by Manuel Marcos Regalado on 05/09/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    var people = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Core Data Concurrency"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNavButtonTapped))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")

        do {
            let results = try managedContext.fetch(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    // MARK: Actions
    func addNavButtonTapped() {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) -> Void in
                let textField = alert.textFields!.first
                self.saveNamePrivateQueue(textField!.text!, completionHandler: {
                    DispatchQueue.main.async { [unowned self] in
                        self.tableView.reloadData()
                    }
                })
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            (action: UIAlertAction) -> Void in
        }

        alert.addTextField {
            (textField: UITextField) -> Void in
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        alert.view.setNeedsLayout()
        present(alert, animated: true, completion: nil)
    }

    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let person = people[(indexPath as NSIndexPath).row]
        cell!.textLabel!.text = person.value(forKey: "name") as? String
        return cell!
    }

    // MARK: Helpers
    func saveNamePrivateQueue(_ name: String, completionHandler:@escaping () -> ()) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContextPrivateQueue

        managedContext.perform {
            let entity =  NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(name, forKey: "name")

            do {
                try managedContext.save()
                self.people.append(person)
                completionHandler()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}
