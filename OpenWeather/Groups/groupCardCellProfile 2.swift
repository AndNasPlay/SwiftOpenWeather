//
//  groupCardCellProfile.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 29.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

struct groupProfile {
    var type: typeOfGroup
    var category: String
    var name: String
    var groupImg: UIImage
    var addGroup: typeAdd
}

enum typeOfGroup: String {
    case moto = "Moto"
    case auto = "Auto"
    case business = "Business"
}

enum typeAdd: String {
    case append = "Add"
    case notAppend = "NotAdd"
}
