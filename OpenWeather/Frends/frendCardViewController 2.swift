//
//  frendCardViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 14.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
class frendCardViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    var frendName: String?
    var frendAvatar: UIImageView?
    var frendAge: String?
    var frendGender: String?
    var friendlastName: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = frendName
        lastName.text = friendlastName

        
    }
}

