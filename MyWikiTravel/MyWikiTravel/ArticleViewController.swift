//
//  ArticleViewController.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 08-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Displays selected article content, from online or offline source.

import UIKit
import CoreData

class ArticleViewController: UIViewController, MediaWikiAPIProtocol {
    
    var article: String!
    var savedArticleText: String!
    var onlineSource: Bool!
    var guide: Guide!
    var api: MediaWikiAPI!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var articleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = article
        api = MediaWikiAPI(delegate: self)
        
        // Display either article text from online article or from saved article in app.
        if onlineSource == true {
            // MediaWiki API requires "%20" instead of spaces.
            api.getArticleText(article.stringByReplacingOccurrencesOfString(" ", withString: "%20"))
        } else {
            self.articleTextView.text = savedArticleText
            self.self.navigationItem.rightBarButtonItems = []
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Set text of textview to be the article text as retrieved from wikitravel.org.
    func articleAPIResults(articleText: String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.articleTextView.text = articleText
        })
    }
    
    @IBAction func saveArticleBarButton(sender: AnyObject) {
        saveArticle(article, text: self.articleTextView.text, guide: guide)
        self.navigationController?.popToViewController(navigationController!.viewControllers[1] as! UIViewController, animated: true)
    }
    
    func saveArticle(title: String, text: String, guide: Guide) {
        // Create the new article.
        var newArticle = Article.createInManagedObjectContext(self.managedObjectContext!, title: title, text: text, guide: guide)
        save()
    }
    
    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
}
