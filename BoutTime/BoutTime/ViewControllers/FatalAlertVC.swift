//
//  FatalAlertVC.swift
//  BoutTime
//
//  Created by Walter Allen on 4/9/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit

/// Extends the UIAlertController class to include a custom Fatal Error Alert that informs the user that a fatal error has occurred and that provides instructions should the error persist. Potential improvement: Provide use with a button to open an email message to report the error?
extension UIAlertController {
    static func fatalAlertController() -> UIAlertController {
        let title = "Fatal Error"
        let message = "A fatal error has occurred. Please force quit the app and then restart it. If you continue to encounter this error, please report it to wltrallen2@gmail.com, and we will do our best to patch it as soon as possible. Thank you!"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in fatalError() })
        alert.addAction(action)
        
        return alert
    }
}
