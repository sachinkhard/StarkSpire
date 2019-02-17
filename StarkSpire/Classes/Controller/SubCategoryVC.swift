//
//  SubCategoryVC.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class SubCategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var categoryArray: [Category] = []
    var model: RecordModel!
    var parentCategory: Category!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = parentCategory.name
        tableView.tableFooterView = UIView.init()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ProductListVC" {
            let controller = segue.destination as! ProductListVC
            controller.parentCategory = sender as? Category
            controller.model = self.model
        }
    }
}


extension SubCategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentCategory.child_categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            fatalError("Unexpected Index Path")
        }
        
        let category = self.model.categories.filter({ (category) -> Bool in
            return category.id == parentCategory.child_categories[indexPath.row]
        })
        
        if category.count > 0 {
            cell.setCatData(category[0])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.model.categories.filter({ (category) -> Bool in
            return category.id == parentCategory.child_categories[indexPath.row]
        })[0]
        
        if category.child_categories.count > 0 {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SubCategoryVC") as! SubCategoryVC
            controller.parentCategory = category
            controller.model = self.model
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else {
            //Show Product Listing
            self.performSegue(withIdentifier: "ProductListVC", sender: category)
        }
    }
}


