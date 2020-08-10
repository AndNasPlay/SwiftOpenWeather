//
//  CityCell.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class Frends: UITableViewCell {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var SurName: UILabel!
    @IBOutlet weak var imageLable: UIImageView!
    @IBOutlet weak var shadowView: UIImageView!
    

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
    
    @IBInspectable var shadowRadius: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageLable.layer.cornerRadius = 50
        //imageLable.contentMode = .scaleAspectFill
        //imageLable.layer.masksToBounds = true
        //imageLable.backgroundColor = .black
        imageLable.clipsToBounds = true
        
        shadowView.layer.shadowColor = shadowColorNew?.cgColor
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowRadius = shadowRadius
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.clipsToBounds = false
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 20).cgPath
        shadowView.addSubview(imageLable)
        //shadowView.backgroundColor = .black
        //shadowView.layer.shadowOffset = .zero
        
    }
    
}


