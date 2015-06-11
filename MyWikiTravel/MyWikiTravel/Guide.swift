//
//  Guide.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 11-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//

import Foundation
import CoreData

class Guide: NSManagedObject {

    @NSManaged var title: String

    class func createInManagedObjectContext(moc: NSManagedObjectContext, title: String) -> Guide {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Guide", inManagedObjectContext: moc) as! Guide
        newItem.title = title
        
        return newItem
    }
}
