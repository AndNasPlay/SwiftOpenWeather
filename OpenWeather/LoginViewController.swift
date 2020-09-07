//
//  LoginViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 01.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class LoginViewController: UIViewController {
    private var tokenTry: String {
        Session.instanse.token
    }
    private var userIdTry: Int {
        Session.instanse.userId
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }
    @objc func keyboardShow(notification: Notification){
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func keyboardHide(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
//    private func checkLoginPass() -> Bool {
//        guard let loginText = loginField.text else { return false }
//        guard let passText = passwordField.text else { return false }
//        if loginText == "admin", passText == "1234" {
//            print("Добро пожаловать")
//            return true
//        }else {
//            print("Не верный логин/пароль")
//            return false
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @IBAction func goButtonTap(_ sender: Any){
        guard let login = loginField.text, let pass = passwordField.text else { return }
        webView.evaluateJavaScript("document.querySelector('input[name=email]').value = '\(login)';document.querySelector('input[name=pass]').value = '\(pass)';") { [weak self] (res, error) in
            self?.webView.isHidden = false
            print(res)
            print(error)
            
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       if identifier == "loginSegue" {
//            if checkLoginPass() {
//                return true
//            } else {
//                showLoginError()
//                return false
//            }
        return true
        }
        
        return true
    }
    
//    private func showLoginError() {
//        let alert = UIAlertController(title: "Ошубка", message: "Login / pass is not correct", preferredStyle: .actionSheet    )
//        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
//    }
}
extension LoginViewController: WKNavigationDelegate {
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
        performSegue(withIdentifier: "loginSegue", sender: nil)
//         NetworkService.shared.loadFriends(userId: userIdTry, token: tokenTry)
//        NetworkService.shared.loadGroups(token: tokenTry)
//        NetworkService.shared.loadPhoto(userId: userIdTry, token: tokenTry)
//        NetworkService.shared.groupsSearch(token: tokenTry, searchText: "THE DUMP")
        
        decisionHandler(.cancel)
    }
}
