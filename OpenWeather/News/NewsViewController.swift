//
//  NewsViewController.swift
//  OpenWeather
//
//  Created by Андрей Щекатунов on 05.08.2020.
//  Copyright © 2020 Andrey Shchekatunov. All rights reserved.
//

import UIKit
import SDWebImage

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
    
    private var newsAllItem: [NewsItem]?
    private var newsAllProfiles: [FriendNews]?
    private var newsAllGroups: [GroupNews]?
    private var nextForm: String?
    private var newsAllArray: NewsAllFeed?
    
    
    private func loadData() {
        networkManager.loadVKNewsFeed{ [weak self] result in
            switch result {
            case let .success(newsALL):
                self?.newsAllItem = newsALL.newsItems
                print(self?.newsAllItem?.count)
                self?.newsAllProfiles = newsALL.friendsNews
                self?.newsAllGroups = newsALL.groupNews
                self?.newsAllArray = newsALL
                self!.NewsTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
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
        return newsAllArray?.newsItems.count ?? 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let news = NewsTableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsCell else { return UITableViewCell?.none!  }
        
        let NewsItemModel = newsAllItem?[indexPath.item]
        news.NewsItemModel = NewsItemModel
        
        //        let imageUrl = newsAllArray?.newsItems[indexPath.item].photos.first?.url
        //        news.NewsTitleimage.sd_setImage(with: imageUrl)
        //        news.likeCounts.text = String(newsAllArray?.newsItems[indexPath.item].likesCount ?? 99 )
        //        news.eyeCount.text = String(newsAllArray?.newsItems[indexPath.item].viewsCount ?? 99)
        //        news.NewsText.text = newsAllArray?.newsItems[indexPath.item].text
        //
        //
        ////                let dateTimeNews1 = newsAllArray?.newsItems[indexPath.item].date
        ////                let dateFormatter = DateFormatter()
        ////                dateFormatter.dateFormat = "dd MMM в H:mm"
        ////                let dateSting = dateFormatter.string(from: dateTimeNews1!)
        //        news.dateTimeNews.text = "dd MMM в H:mm"
        //        news.autorName.text = "Сеня"
        
        return news
    }
}




