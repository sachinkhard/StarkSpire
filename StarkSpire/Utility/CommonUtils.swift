//
//  CommonUtils.swift
//  StarkSpire
//
//  Created by Mac on 17/02/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

class CommonUtils: NSObject {
    
    class func showAlert(withMessage message : String, withController viewController: UIViewController) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func printAnyResponse(string : String) {
        if DEBUG_MODE { print(string) }
    }
}
