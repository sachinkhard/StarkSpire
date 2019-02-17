//
//  SimpleListViewController.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

protocol SimpleListVCDelegate: class {
    func selectedListOption(_ selectedOption: NSInteger)
}

class SimpleListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var listArray: [String]!
    var headerTitle: String!
    var selectedIndex: Int!
    weak var delegate: SimpleListVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = self.headerTitle
        self.view.backgroundColor = .white
        tableView.tableFooterView = UIView.init()
    }
}


extension SimpleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
            cell?.backgroundColor = .clear
            cell?.backgroundView = nil
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textAlignment = .left
        cell?.textLabel?.text = self.listArray[indexPath.row]
        
        if let idx = selectedIndex, idx == indexPath.row {
           cell?.accessoryType = .checkmark
        }
        else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        self.delegate?.selectedListOption(indexPath.row)
    }
}

