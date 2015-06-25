//
//  GuideViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 04-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Displays table of articles saved in selected guide.

import UIKit

class GuideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let coreData = CoreData()
    var guide = [Guide]()
    var articles = [Article]()
    let cellIdentifier = "guideArticleCell"
    
    @IBOutlet weak var guideTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Retrieves the currently selected guide entity.
        self.guide = coreData.fetchGuide(self.title!)
    }
    
    // Reloads the table every time this view is presented, to show any updates.
    override func viewWillAppear(animated: Bool) {
        self.articles = coreData.fetchArticles(self.guide)
        self.guideTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    // Show article titles of selected guide in tableview cells.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell!
        let article = articles[indexPath.row]
        
        cell.textLabel?.text = article.title
        cell.imageView?.image = UIImage(named: "Article")
        
        return cell
    }
    
    // Allows table cells to be deleted by swiping.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Deletes table cell and the article it contains.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == .Delete ) {
            let articleToDelete = articles[indexPath.row]
            
            coreData.delete(articleToDelete)
            coreData.fetchGuide(self.title!)
            self.articles = coreData.fetchArticles(self.guide)
            guideTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            coreData.save()
        }
    }
    
    // Passes required data to next viewcontroller.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let searchViewController: SearchViewController = segue.destinationViewController as? SearchViewController {
            searchViewController.guide = guide[0]
        }
        if let articleViewController: ArticleViewController = segue.destinationViewController as? ArticleViewController {
            var articleIndex = guideTableView!.indexPathForSelectedRow()!.row
            articleViewController.title = articles[articleIndex].title
            articleViewController.articleText = articles[articleIndex].text
            articleViewController.imageData = articles[articleIndex].image
            articleViewController.onlineSource = false
        }
    }
}