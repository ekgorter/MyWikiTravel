//
//  Article.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 24-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//

import Foundation
import CoreData

class Article: NSManagedObject {

    @NSManaged var text: NSAttributedString
    @NSManaged var title: String
    @NSManaged var belongsToGuide: Guide
    
    // Method allows creation of new article.
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String, text: NSAttributedString, guide: Guide) -> Article {
        let newArticle = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: moc) as! Article
        newArticle.title = title
        newArticle.text = text
        newArticle.belongsToGuide = guide
        return newArticle
    }
}
