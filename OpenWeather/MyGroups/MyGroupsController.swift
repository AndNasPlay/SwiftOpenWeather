//
//  MyGroupsController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 03.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class MyGroupController: UIViewController {
    @IBOutlet weak var MygroupTableView: UITableView!
    var MyGroupsInfo = [groupProfile]()
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        if segue.identifier == "addGroup" {
            guard let groupViewController = segue.source as? GroupViewController else { return }
            if let indexPath = groupViewController.groupTableView.indexPathForSelectedRow {
                let group = groupViewController.ALLGroupsInfo[indexPath.row]
                if MyGroupsInfo.isEmpty {
                    MyGroupsInfo.append(group)
                } else {
                    let test = MyGroupsInfo.filter{ $0.name == group.name}.first
                    if test == nil {
                        MyGroupsInfo.append(group)
                    }
                }
            }
            MygroupTableView?.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MygroupTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "MyGroupSegue",
            let cell = sender as? MyGroupsCell,
            let destination = segue.destination as? MyGroupCardViewController
        {
            destination.groupName = cell.titleLable.text
            destination.groupImage = cell.imageGroupTitle
            var needType: String = "Ошибка Type"
            var needCategory: String = "Ошибка Category"
            for i in 0...MyGroupsInfo.count {
                if cell.titleLable.text == MyGroupsInfo[i].name {
                    needType = MyGroupsInfo[i].type.rawValue
                    needCategory = MyGroupsInfo[i].category
                    break
                }
                else {
                    needType = "Ошибка2"
                }
            }
            destination.groupType = needType
            destination.groupCategory = needCategory
        }


    }
}

extension MyGroupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyGroupsInfo.count
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MyGroupsInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let group = MygroupTableView.dequeueReusableCell(withIdentifier: "MyGroupsCell") as? MyGroupsCell else { fatalError() }
        group.titleLable.text = MyGroupsInfo[indexPath.row].name
        group.imageGroupTitle.image = MyGroupsInfo[indexPath.row].groupImg
        
        return group
        
    }
}


