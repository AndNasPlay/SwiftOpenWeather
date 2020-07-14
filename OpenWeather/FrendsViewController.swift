//
//  CityViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class FrendsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var frends = [
        "Влад",
        "Дима",
        "Павел",
        "Лера",
        "Таня",
        "Маша",
        "Саша",
        "Катя",
        "Алина",
        "Мытищи",
        "Аня"
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension FrendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let frend = tableView.dequeueReusableCell(withIdentifier: "Frends") as? Frends else { fatalError() }
        frend.titleLable.text = frends[indexPath.row]
        return frend
    }
        
    
}
