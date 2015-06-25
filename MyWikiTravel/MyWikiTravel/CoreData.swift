//
//  CoreData.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 25-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// All Core Data functionality used in app is defined here.

import Foundation
import UIKit
import CoreData

class CoreData {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    // Retrieve all existing guides from Core Data.
    func fetchGuides() -> [Guide] {
        var guides = [Guide]()
        let fetchRequest = NSFetchRequest(entityName: "Guide")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Guide] {
            guides = fetchResults
        }
        
        return guides
    }
    
    // Retrieves the selected guide from Core Data.
    func fetchGuide(title: String) -> [Guide] {
        var guide = [Guide]()
        let fetchRequest = NSFetchRequest(entityName: "Guide")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let predicate = NSPredicate(format: "title == %@", title)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Guide] {
            guide = fetchResults
        }
        
        return guide
    }
    
    // Retrieves the articles belonging to this guide from Core Data.
    func fetchArticles(guide: [Guide]) -> [Article] {
        var articles = [Article]()
        
        for article in guide[0].guideContent.allObjects as! [Article] {
            articles.append(article)
        }
        
        return articles
    }
    
    // Creates a new Guide entity.
    func createNewGuide(title: String) -> Guide {
        let newGuide = Guide.createInManagedObjectContext(self.managedObjectContext!, title: title)
        
        return newGuide
    }
    
    // Creates a new Article entity
    func createNewArticle(title: String, text: String, image: NSData, guide: Guide) {
        Article.createInManagedObjectContext(self.managedObjectContext!, title: title, text: text, image: image, guide: guide)
    }
    
    // Saves data to Core Data.
    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    // Deletes guide from Core Data.
    func delete(objectToDelete: Guide) {
        managedObjectContext?.deleteObject(objectToDelete)
    }
    
    // Deletes article from Core Data.
    func delete(objectToDelete: Article) {
        managedObjectContext?.deleteObject(objectToDelete)
    }
}
