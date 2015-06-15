//
//  GuideViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 04-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Displays table of articles saved in selected guide.

import UIKit
import CoreData

class GuideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var guide = [Guide]()
    var articles = [Article]()
    let cellIdentifier = "guideArticleCell"
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var guideTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGuide()
    }
    
    // NB: Hij herlaadt nu steeds de hele table, maar moet anders met passen van allemaal variabelen.
    // Hij herlaadt ook als je geen nieuw artikel hebt gesaved, maar via de back knop terugkomt.
    override func viewWillAppear(animated: Bool) {
        self.fetchArticles()
        self.guideTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Show article titles of selected guide in tableview cells.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell!
        let article = articles[indexPath.row]
        cell.textLabel?.text = article.title
        return cell
    }
    
    // Allows table cells to be deleted by swiping.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            // Find the LogItem object the user is trying to delete
            let articleToDelete = articles[indexPath.row]
            
            // Delete it from the managedObjectContext
            managedObjectContext?.deleteObject(articleToDelete)
            
            // Refresh the table view to indicate that it's deleted
            self.fetchGuide()
            
            self.fetchArticles()
            
            // Tell the table view to animate out that row
            guideTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            save()
        }
    }
    
    func fetchGuide() {
        let fetchRequest = NSFetchRequest(entityName: "Guide")
        
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Create a new predicate that filters out any object that
        // doesn't have a title of "Best Language" exactly.
        let predicate = NSPredicate(format: "title == %@", self.title!)
        
        // Set the predicate on the fetch request
        fetchRequest.predicate = predicate
        
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Guide] {
            guide = fetchResults
        }
    }
    
    func fetchArticles() {
        self.articles = [Article]()
        for article in guide[0].guideContent.allObjects as! [Article] {
            articles.append(article)
        }
    }
    
    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let searchViewController: SearchViewController = segue.destinationViewController as? SearchViewController {
            searchViewController.guide = guide[0]
        }
        if let articleViewController: ArticleViewController = segue.destinationViewController as? ArticleViewController {
            var articleIndex = guideTableView!.indexPathForSelectedRow()!.row
            articleViewController.savedArticleText = articles[articleIndex].text
            articleViewController.onlineSource = false
        }
    }
}