//
//  CityViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 13.07.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
import RealmSwift

class FrendsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var allFrends = [
        frendProfile(name: "Андрей", surname: "Андреев", age: "27", avatar: UIImage(named: "man1.png")!, gender: .man ),
        frendProfile(name: "Артем", surname: "Борисов", age: "30", avatar: UIImage(named: "man2.png")!, gender: .man),
        frendProfile(name: "Борис", surname: "Ваганов", age: "33", avatar: UIImage(named: "man3.png")!, gender: .man),
        frendProfile(name: "Татьяна", surname: "Герасимова", age: "21", avatar: UIImage(named: "girl1.png")!, gender: .woman),
        frendProfile(name: "Мария",surname: "Димова", age: "28", avatar: UIImage(named: "girl2.png")!, gender: .woman),
        frendProfile(name: "Эльза",surname: "Шекелева", age: "32", avatar: UIImage(named: "girl3.png")!, gender: .woman)
    ]
    
    let contacts = ["Андреев", "Борисов", "Ваганов", "Герасимова", "Димова", "Шекелева"]
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        var friendsNewAll: [FriendsItems] = NetworkService.shared.loadFriends(userId: Session.instanse.userId, token: Session.instanse.token)
        tableView.dataSource = self
        
        //let groupedDictionary = Dictionary(grouping: allFrends, by: {$0.surname.first!})
        //let keys = groupedDictionary.keys.sorted()
        // Не знаю как реализовать используя один массив allFrends
        let groupedDictionary = Dictionary(grouping: contacts, by: {String($0.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted())}
        self.tableView.reloadData()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "frendSegue",
            let frend = sender as? Frends,
            let destination = segue.destination as? frendCardViewController {
            destination.frendName = frend.titleLable.text
            destination.frendAvatar = frend.imageLable
            for i in 0...5 {
                if frend.titleLable.text == allFrends[i].name {
                    destination.frendGender = allFrends[i].gender.rawValue
                    destination.frendAge = allFrends[i].age
                    break
                }
                else {
                    print("Ошибка")
                }
            }
        }
        
    }
    
}

extension FrendsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].names.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections.map{$0.letter}
        
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section].letter
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let frend = tableView.dequeueReusableCell(withIdentifier: "Frends") as? Frends else { fatalError() }
        
        let friendsNewAll: [FriendsItems] = NetworkService.shared.loadFriends(userId: Session.instanse.userId, token: Session.instanse.token)
        frend.imageLable.image = allFrends[indexPath.section].avatar
        frend.titleLable.text = friendsNewAll[indexPath.section].lastName
        frend.titleLable.text = friendsNewAll[indexPath.section].firstName
            //friendsNewAll[indexPath.section].firstName
//            + friendsNewAll[indexPath.section].lastName
        frend.SurName.text = allFrends[indexPath.section].surname
        return frend
        
        
    }
    
}

