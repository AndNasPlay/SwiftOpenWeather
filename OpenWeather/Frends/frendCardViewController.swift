//
//  frendCardViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 14.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
import SDWebImage
class frendCardViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var avatar: UIImageView!

    var frendName: String?
    var frendAvatar: String!
    var friendlastName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = frendName
        lastName.text = friendlastName
        avatar.sd_setImage(with: URL(string: frendAvatar)!)
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        avatar.layer.cornerRadius = 50
//        avatar.contentMode = .scaleAspectFill
//        avatar.layer.masksToBounds = true
//        avatar.backgroundColor = .black
//        avatar.clipsToBounds = true
//    }
}




