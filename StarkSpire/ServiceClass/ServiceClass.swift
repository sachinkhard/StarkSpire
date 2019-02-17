//
//  ServiceClass.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import Alamofire

class ServiceClass: NSObject {
    
    static func fetchAllRecordsFromURL(url: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        AF.request(url)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    CommonUtils.printAnyResponse(string: "Error while fetching records: \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }
                
                completion(response.data)
        }
    }
}
