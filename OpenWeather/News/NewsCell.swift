//
//  News.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 05.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var NewsTitleimage: UIImageView!
    @IBOutlet weak var NewsText: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var likeCounts: UILabel!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var shear: UIButton!
    @IBOutlet weak var eyeCount: UILabel!
    
    var switcher: Int = 0
    var countLike: Int = 0
    
    
    @IBAction func likeControll(_ sender: UIButton) {
        if like.isTouchInside  && switcher == 0 {
            countLike += 1
            switcher += 1
            print(countLike)
            like.setImage(#imageLiteral(resourceName: "heartfill"), for: .normal)
        } else {
            countLike -= 1
            switcher -= 1
            print(countLike)
            like.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        }

    }
}





