//
//  ViewController.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var model: RecordModel?
    var parentCategoryArray: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        self.title = "Choose Category"
        tableView.tableFooterView = UIView.init()

        SVProgressHUD.show(withStatus: "Loading Categories")
        
        ServiceClass.fetchAllRecordsFromURL(url: DOWNLOAD_URL) { (responseData) in
            if let data = responseData {
                do {
                    //Decode JSON Response Data to RecordModel
                    self.model = try JSONDecoder().decode(RecordModel.self, from:data)
                    
                    CoreDataStack.sharedInstance.saveDataInCoreData(model: self.model)
                    self.setTableData()
                    
                    CommonUtils.printAnyResponse(string: "\(self.parentCategoryArray.count)")
                    
                } catch let parsingError {
                    CommonUtils.showAlert(withMessage: "Error while parsing records : \(parsingError)", withController: self)
                }
            }
            else {
                CommonUtils.showAlert(withMessage: "Error while fetching records", withController: self)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    private func setTableData() {
        if let array = self.model?.categories {
            for mCategory in array {
                if array.filter({ (category) -> Bool in
                    category.child_categories.contains(mCategory.id)
                }).count == 0 {
                    self.parentCategoryArray.append(mCategory)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SubCategoryVC" {
            let controller = segue.destination as! SubCategoryVC
            controller.parentCategory = sender as? Category
            controller.model = self.model
        }
        else if segue.identifier == "ProductListVC" {
            let controller = segue.destination as! ProductListVC
            controller.parentCategory = sender as? Category
            controller.model = self.model
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parentCategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            fatalError("Unexpected Index Path")
        }
        
        cell.setCatData(self.parentCategoryArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.parentCategoryArray[indexPath.row]
        
        if category.child_categories.count > 0 {
            self.performSegue(withIdentifier: "SubCategoryVC", sender: category)
        }
        else {
            //Show Product Listing
            self.performSegue(withIdentifier: "ProductListVC", sender: category)
        }
    }
}


