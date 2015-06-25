//
//  Article.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 25-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Description of Article entity in Core Data.

import Foundation
import CoreData

class Article: NSManagedObject {

    @NSManaged var text: String
    @NSManaged var title: String
    @NSManaged var image: NSData
    @NSManaged var belongsToGuide: Guide
    
    // Method allows creation of new article.
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String, text: String, image: NSData, guide: Guide) -> Article {
        let newArticle = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: moc) as! Article
        
        newArticle.title = title
        newArticle.text = text
        newArticle.image = image
        newArticle.belongsToGuide = guide
        
        return newArticle
    }

}
