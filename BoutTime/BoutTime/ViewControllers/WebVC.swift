//
//  WebVC.swift
//  BoutTime
//
//  Created by Walter Allen on 3/25/19.
//  Copyright © 2019 Forty Something Nerd. All rights reserved.
//

import UIKit
import WebKit

/// The WebVC class represents the view controller that contains a WKWebView used to display a web page based on a given url.
class WebVC: UIViewController, WKUIDelegate {

    /// Property representing the url to load
    var urlToLoad: URL?
    
    /// Property representing the WKWebView that will display the web page
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Life Cycle Methods
    //**********************************************************************
    /// Once the view is loaded, the method will send a request to load url in the urlToLoad property, which should be set during the segue.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = urlToLoad {
            let urlRequest = URLRequest(url: url)
            self.webView.load(urlRequest)
        }
        
    }
}
