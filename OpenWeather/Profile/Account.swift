//
//  Account.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 11.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation

class Account {
    private let someKey: String = "StandardValue"
    
    var Score: Int  {
        set {
            UserDefaults.standard.set(newValue, forKey: someKey)
        }
        get {
            UserDefaults.standard.integer(forKey: someKey)
        }
    }
    var avatar: String = "man1.png"
    var name: String = "Andrey"
    
    static let shared = Account()
    private init() {}
}
