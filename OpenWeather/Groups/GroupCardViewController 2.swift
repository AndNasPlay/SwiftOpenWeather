//
//  GroupCardViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 29.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class GroupCardViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var imageGroupTitle: UIImageView!
    @IBOutlet weak var typeOfgroup: UILabel!

    var groupName: String?
    var groupImage: UIImageView?
    var groupType: String?
    var groupCategory: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = groupName
        imageGroupTitle.image = groupImage?.image
        typeOfgroup.text = groupType
    }

    
}



