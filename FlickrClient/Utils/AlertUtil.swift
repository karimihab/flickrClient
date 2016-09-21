//
//  AlertUtil.swift
//  FlickrClient
//
//  Created by Karim Ihab on 20/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import UIKit

//This util seprates the way we show alerts all over the app, it helps is chaning how alert works, shows, ...etc
//without affecting our code

//for instance the a better looking error message or alerts than the default alertController.
class AlertUtil {
    
    static func showAlert(title: String, message: String, buttonText: String, viewController:UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: buttonText, style: .default) { (action) in
            
        }
        alertController.addAction(OKAction)
        viewController.present(alertController, animated: true) {}
    }
}
