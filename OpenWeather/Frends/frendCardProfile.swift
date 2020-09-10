//
//  frendCardProfile.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 21.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

struct frendProfile {
    var name: String
    var surname: String
    var avatar: UIImage
    
}

struct Section {
    let letter : String
    let names : [String]
}

enum gender: String {
    case man = "Man"
    case woman = "Woman"
}
