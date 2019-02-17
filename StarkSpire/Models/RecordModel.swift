//
//  RecordModel.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

struct RecordModel: Decodable {
    var categories : [Category]
    var rankings : [Rank]

}

struct Category: Decodable {
    var id : Int
    var name : String?
    var products : [Product]
    var child_categories : [Int]

}

struct Rank: Decodable {
    var ranking : String?
    var products : [Product]?

}

struct Product: Decodable {
    var id : Int
    var name : String?
    var date_added : String?
    var variants : [Variant]?
    var tax : Tax?
    var view_count : Double?
    var order_count : Double?
    var shares : Double?

}

struct Tax: Decodable {
    var name : String
    var value : Double?

}

struct Variant: Decodable {
    var id : Int
    var color : String?
    var size : Double?
    var price : Double?

}
