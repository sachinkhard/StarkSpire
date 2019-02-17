//
//  ProductListVC.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class ProductListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var parentCategory: Category!
    var model: RecordModel!
    var selectedRanking: Int!
    var displayProductsArray : [Product] = []
    var obj : SimpleListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = parentCategory.name
        self.displayProductsArray = parentCategory.products
        
        tableView.tableFooterView = UIView.init()  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .done, target: self, action: #selector(filterButtonAction(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func filterButtonAction(_ sender: UIBarButtonItem) {
        
        if obj == nil {
            obj = SimpleListViewController(nibName: "SimpleListViewController", bundle: nil)
            obj.preferredContentSize = CGSize(width: 180, height: 190)
            obj.modalPresentationStyle = .popover
            obj.delegate = self
            obj.listArray = self.model.rankings.map { (mRank) -> String in
                return mRank.ranking ?? ""
            };
            obj.headerTitle = "Sort by";
        }
        
        let popoverC = obj.popoverPresentationController
        popoverC?.delegate = self
        popoverC?.barButtonItem = sender
        present(obj, animated: true, completion:nil)
    }
}

extension ProductListVC: UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, SimpleListVCDelegate {
    
    func selectedListOption(_ selectedOption: NSInteger) {
        let rank = self.model.rankings[selectedOption]

        self.displayProductsArray.sort { (p1, p2) -> Bool in
            
            let pp1 = rank.products?.first(where: { (product) -> Bool in
                product.id == p1.id
            })
            
            let pp2 = rank.products?.first(where: { (product) -> Bool in
                product.id == p2.id
            })
            
            if let vc1 = pp1?.view_count, let vc2 = pp2?.view_count {
                return vc2.isLess(than: vc1)
            }
            else if let vc1 = pp1?.order_count, let vc2 = pp2?.order_count {
                return vc2.isLess(than: vc1)
            }
            else if let vc1 = pp1?.shares, let vc2 = pp2?.shares {
                return vc2.isLess(than: vc1)
            }
            
            return false
        }

        tableView.reloadData()
        dismiss(self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayProductsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            fatalError("Unexpected Index Path")
        }
        
        cell.setProdData(self.displayProductsArray[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonUtils.showAlert(withMessage: "Hey! This is the demo appliation. kindly bear with us to know more.", withController: self)
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)

        navigationController.topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .done, target: self, action: #selector(reset(_:)))
        
        navigationController.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismiss(_:)))
        
        return navigationController
    }
    
    @objc func dismiss(_ : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func reset(_ : Any) {
        obj.selectedIndex = nil
        obj.tableView.reloadData()
        
        self.displayProductsArray = parentCategory.products
        tableView.reloadData()
        dismiss(self)
    }
}



