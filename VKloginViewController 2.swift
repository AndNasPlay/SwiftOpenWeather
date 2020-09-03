//
//  VKloginViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 16.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class VkLoginViewController: UIViewController {
    private lazy var realm: Realm? = {
        return try? Realm()
    }()
    private var tokenTry: String {
        Session.instanse.token
    }
    private var userIdTry: Int {
        Session.instanse.userId
    }
    
    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "7568757"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.92")
            
        ]
        let request = URLRequest(url: components.url!)
        webView.load(request)
    }
}

extension VkLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else { decisionHandler(.allow); return }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        print(params)
        
        guard let token = params["access_token"],
            let userIdString = params["user_id"],
            let userIdInt = Int(userIdString) else {
                decisionHandler(.allow)
                return
        }
        
        Session.instanse.token = token
        Session.instanse.userId = userIdInt
        
        NetworkService.shared.loadFriends(userId: userIdTry, token: tokenTry)
        NetworkService.shared.loadGroups(token: tokenTry)
        NetworkService.shared.loadPhoto(userId: userIdTry, token: tokenTry)
        NetworkService.shared.groupsSearch(token: tokenTry, searchText: "THE DUMP")
        
        decisionHandler(.cancel)
    }
}
