//
//  CityCell.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class Groups: UITableViewCell {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var imageGroupTitle: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var append: UIButton!
        
    var groupsModel: GroupsItems? {
        didSet {
            setup()
        }
    }
    private func setup() {
        guard let groupsModel = groupsModel else { return }
        let id = groupsModel.id.hashValue
        let name = groupsModel.name
        let typeOfGroup = groupsModel.type
        let groupImgUrl = groupsModel.groupImg

        titleLable.text = name
        type.text = typeOfGroup
        imageGroupTitle.sd_setImage(with: URL(string: groupImgUrl))
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageGroupTitle.layer.cornerRadius = 50
        imageGroupTitle.contentMode = .scaleAspectFill
        imageGroupTitle.layer.masksToBounds = true
        imageGroupTitle.backgroundColor = .clear
    }
}
