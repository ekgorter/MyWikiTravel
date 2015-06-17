//
//  Article.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 12-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Description of Article entity in Core Data.

import Foundation
import CoreData

class Article: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var text: String
    
    // One to one relation with Guide entity. Contains guide entity this article belongs to.
    @NSManaged var belongsToGuide: Guide

    // Method allows creation of new article.
    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String, text: String, guide: Guide) -> Article {
        let newArticle = NSEntityDescription.insertNewObjectForEntityForName("Article", inManagedObjectContext: moc) as! Article
        newArticle.title = title
        newArticle.text = text
        newArticle.belongsToGuide = guide
        return newArticle
    }
}
