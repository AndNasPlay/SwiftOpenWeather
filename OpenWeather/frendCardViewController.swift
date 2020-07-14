//
//  frendCardViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 14.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
class  frendCardViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var card = [
    FrendCardStart(age: 35, city: "Дима"),
    FrendCardStart(age: 22, city: "Аня"),
    FrendCardStart(age: 28, city: "Дима")]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
    
}
extension frendCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrendCell", for: indexPath) as? frendCardCell else { fatalError() }
        let name = card[indexPath.row]
        cell.age.text = String(age)
        cell.name.text = String(name)
        return cell
    }
}

