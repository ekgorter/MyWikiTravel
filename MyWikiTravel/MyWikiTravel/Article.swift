//
//  Article.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 05-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//

import Foundation

struct Article {
    let title: String
    
    init(title: String) {
        self.title = title
    }

    static func articlesFromJson(search: NSArray) -> [Article] {
        var articles = [Article]()
        
        if search.count>0 {
            for result in search {
                let title = result["title"] as? String
                
                var newArticle = Article(title: title!)
                articles.append(newArticle)
            }
        }
        return articles
    }
}