//
//  CityViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    @IBOutlet weak var groupTableView: UITableView!
    var groups = [
        "Ktm",
        "M1nsk",
        "Ducati",
        "Honda",
        "Ява",
        "УАЗ",
        "Suzuki",
        "BMW",
        "Yamaha",
        "Honda rebel",
        "KTM Duke"
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.dataSource = self
    }
}

extension GroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = groupTableView.dequeueReusableCell(withIdentifier: "Groups") as? Groups else { fatalError() }
        group.titleLable.text = groups[indexPath.row]
        return group
    }
}
