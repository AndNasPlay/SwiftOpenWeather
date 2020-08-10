//
//  NewsCell.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 05.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

struct newsStruct {
    var category: categoryOfNews
    var newsLable: String
    var newsImg: UIImage
    var newsText: String
    var likes: Int
    var eyeCount: Int

}

enum categoryOfNews: String {
    case politics = "Politics"
    case humor = "Humor"
    case business = "Business"
    case auto = "Auto"
    case moto = "Moto"
}

