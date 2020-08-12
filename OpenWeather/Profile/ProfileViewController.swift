//
//  ProfileViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 11.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var addPoint: UIButton!
    
    
    @IBAction func addPoint(_ sender: UIButton) {
        guard let ScoreString = scoreTextField.text,
            let ScoreTest = Int(ScoreString) else { return }
        Account.shared.Score = ScoreTest
        if addPoint.isTouchInside {
            let resultInt: Int = Int(result.text!)!
            result.text = "\((Int(scoreTextField.text!)!) + resultInt)"
            scoreTextField.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileName.text = Account.shared.name
        profileAvatar.image = UIImage(named: Account.shared.avatar)
        scoreTextField.text = String(Account.shared.Score)
        result.text = String(Account.shared.Score)
    }
}
