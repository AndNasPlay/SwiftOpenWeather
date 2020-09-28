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
    
    private let realmManager = RealmManager.shared
    private let networkManager = NetworkService.shared
    
    private var tokenTry: String {
        Session.instanse.token
    }
    private var userIdTry: Int {
        Session.instanse.userId
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkManager.loadNews(userId: userIdTry, token: tokenTry) { [weak self] result in
            switch result {
            case let .success(newsGroups):
                DispatchQueue.main.async {
                    try? self?.realmManager?.add(objects: newsGroups)
                    completion?()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    var AllNews = [
        newsStruct(category: .moto, newsLable: "KAWASAKI 2020", newsImg: UIImage(named: "KAWASAKI2020.jpg")!, newsText: "Спортивно-туристический KAWASAKI ZZR1400 в модельном ряде 2020 остался без изменений в техническом плане, но получил эффектное обновление образа в виде новой цветовой схемы Metallic Diablo Black / Golden Blazed Green («дьявольский черный металлик» / «сияющий золотом зеленый») в дополнение к стильной расцветке получит золотистый глушитель от Akrapovič.", likes: 3, eyeCount: 10),
        newsStruct(category: .business, newsLable: "Успешный успех ", newsImg: UIImage(named: "successfulsuccess.png")!, newsText: "Успешный успех опыть обогнал успешный не успех!", likes: 10, eyeCount:  12)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsTableView.dataSource = self
        loadData()
        
        
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
        
        guard let news = NewsTableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsCell else { return UITableViewCell?.none!  }
        if news.countLike == 0 {
            news.countLike = AllNews[indexPath.row].likes
        }
        news.NewsText.text = AllNews[indexPath.row].newsText
        news.NewsTitleimage.image = AllNews[indexPath.row].newsImg
        AllNews[indexPath.row].likes = news.countLike
        news.likeCounts.text = String(AllNews[indexPath.row].likes)
        news.eyeCount.text = String(AllNews[indexPath.row].eyeCount)

        return news
    }
}




