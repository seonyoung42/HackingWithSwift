//
//  WebViewController.swift
//  Project16
//
//  Created by 장선영 on 2021/11/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var cityName: String?
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cityName = cityName {
            let url = URL(string: "https://wikipedia.org/wiki/\(cityName)")!
            webView.load(URLRequest(url: url))
        }

    }
    
}
