//
//  Searchresult.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 17-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//

import Foundation

struct Searchresult {
    let title: String
    let guide: Guide
    
    init(title: String, guide: Guide) {
        self.title = title
        self.guide = guide
    }
    
    // Retrieves the requested data from the JSON file returned by the API.    
    static func searchresultsFromJson(searchResult: NSArray, guide: Guide) -> [Searchresult] {
        var articles = [Searchresult]()
        if searchResult.count>0 {
            for result in searchResult {
                let title = result["title"] as? String
                
                var article = Searchresult(title: title!, guide: guide)
                articles.append(article)
            }
        }
        return articles
    }
}