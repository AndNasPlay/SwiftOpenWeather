//
//  CityCell.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import SDWebImage
import UIKit

class Frends: UITableViewCell {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var SurName: UILabel!
    @IBOutlet weak var imageLable: UIImageView!
    @IBOutlet weak var shadowView: UIImageView!
    
    var friendsModel: FriendsItems? {
        didSet {
            setup()
        }
    }
    
    private func setup() {
        guard let friendsModel = friendsModel else { return }
        let id = friendsModel.id.hashValue
        let firstName = friendsModel.firstName
        let lastName = friendsModel.lastName
        let imageUrl = friendsModel.avatarFriend
        

        titleLable.text = firstName
        SurName.text = lastName
        imageLable.sd_setImage(with: URL(string: imageUrl))
        shadowView.sd_setImage(with: URL(string: imageUrl))
        
    }

    
    @IBInspectable var shadowOpacity: Float = 0.6 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowColorNew: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowRadius: CGFloat = 50 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageLable.layer.cornerRadius = 50
        imageLable.contentMode = .scaleAspectFill
        imageLable.layer.masksToBounds = true
        imageLable.backgroundColor = .black
        imageLable.clipsToBounds = true

        shadowView.layer.shadowColor = shadowColorNew?.cgColor
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.clipsToBounds = false
        //shadowView.layer.cornerRadius = 50
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 50).cgPath
        shadowView.addSubview(imageLable)
        shadowView.backgroundColor = .black
        shadowView.layer.shadowOffset = .zero

    }
    
}


