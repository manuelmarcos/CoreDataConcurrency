//
//  ViewController.swift
//  CoreDataConcurrency
//
//  Created by Manuel Marcos Regalado on 05/09/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
    }

    func addTapped() {

    }

}
