//
//  Realm.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 30.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import Foundation
import RealmSwift

class FriendsRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    
    convenience init(id: Int, firstName: String, lastName: String) {
        self.init()
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}


