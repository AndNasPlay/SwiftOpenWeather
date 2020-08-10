//
//  myGroupsCell.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 03.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class MyGroupsCell: UITableViewCell {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var imageGroupTitle: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGroupTitle.layer.cornerRadius = 50
        imageGroupTitle.contentMode = .scaleAspectFill
        imageGroupTitle.layer.masksToBounds = true
        imageGroupTitle.backgroundColor = .clear
    }
    
}
 
