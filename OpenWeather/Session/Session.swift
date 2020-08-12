//
//  Session.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 12.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
class Session {
    static let instanse = Session()
    private init() {}
    var token: String = ""
    var userId: Int = 0
}
