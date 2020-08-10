//
//  NewsViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 05.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    @IBOutlet weak var NewsTableView: UITableView!
    
    
    var AllNews = [
        newsStruct(category: .moto, newsLable: "KAWASAKI 2020", newsImg: UIImage(named: "KAWASAKI2020.jpg")!, newsText: "Спортивно-туристический KAWASAKI ZZR1400 в модельном ряде 2020 остался без изменений в техническом плане, но получил эффектное обновление образа в виде новой цветовой схемы Metallic Diablo Black / Golden Blazed Green («дьявольский черный металлик» / «сияющий золотом зеленый») в дополнение к стильной расцветке получит золотистый глушитель от Akrapovič.", likes: 3, eyeCount: 10),
        newsStruct(category: .business, newsLable: "Успешный успех ", newsImg: UIImage(named: "successfulsuccess.png")!, newsText: "Успешный успех опыть обогнал успешный не успех!", likes: 10, eyeCount:  12)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsTableView.dataSource = self
        
        
    }
    @IBAction func LikeChanged(_ sender: Any) {
        NewsTableView.reloadData()
        
    }

}


extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllNews.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let news = NewsTableView.dequeueReusableCell(withIdentifier: "NewsCell") as? News else { fatalError() }
        if news.countLike == 0 {
            news.countLike = AllNews[indexPath.row].likes
        }
        news.CategoryOfNews.text = AllNews[indexPath.row].category.rawValue
        news.NewsLable.text = AllNews[indexPath.row].newsLable
        news.NewsText.text = AllNews[indexPath.row].newsText
        news.NewsTitleimage.image = AllNews[indexPath.row].newsImg
        AllNews[indexPath.row].likes = news.countLike
        news.likeCounts.text = String(AllNews[indexPath.row].likes)
        news.eyeCount.text = String(AllNews[indexPath.row].eyeCount)

        
        return news
        
    }


}




