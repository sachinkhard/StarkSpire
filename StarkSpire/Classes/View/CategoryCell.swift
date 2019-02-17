//
//  ViewController.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCatData(_ category: Category) {
        self.titleLabel.text = category.name
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func setProdData(_ product: Product) {
        self.titleLabel.text = product.name
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        if let size = product.variants?[0].size {
            self.priceLabel.text = String(format: "Rs. %.0f, Size : %.0f, Color : %@", product.variants?[0].price ?? 0, size, product.variants?[0].color ?? "")
        }
        else {
            self.priceLabel.text = String(format: "Rs. %.0f, Color : %@", product.variants?[0].price ?? 0, product.variants?[0].color ?? "")
        }
        
        self.priceLabel.font = UIFont.systemFont(ofSize: 15)
    }
}
