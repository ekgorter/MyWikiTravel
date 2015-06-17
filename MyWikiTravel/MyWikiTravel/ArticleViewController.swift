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
    
    // Contains selected searchresult.
    var article: Searchresult!
    
    // If the source is a saved article, contains the text of the saved article.
    var savedArticleText: String!
    
    // Indicates if the article is to be loaded from Core Data or Wikitravel.org.
    var onlineSource: Bool!
    
    // Variable allows quick use of API methods.
    var api: MediaWikiAPI!
    
    // Required by Core Data to save data.
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var articleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = MediaWikiAPI(delegate: self)
        
        // Display either article text from online article or from saved article in app.
        if onlineSource == true {
            title = article.title
            // MediaWiki API requires "%20" instead of spaces.
            api.getArticleText(article.title.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        } else {
            self.articleTextView.text = savedArticleText
            
            // Removes save button.
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
    
    // When "save" button is pressed, article is saved to guide and view pops to guide.
    @IBAction func saveArticleBarButton(sender: AnyObject) {
        saveArticle(article.title, text: self.articleTextView.text, guide: article.guide)
        self.navigationController?.popToViewController(navigationController!.viewControllers[1] as! UIViewController, animated: true)
    }
    
    // Save the currently displayed article.
    func saveArticle(title: String, text: String, guide: Guide) {
        var newArticle = Article.createInManagedObjectContext(self.managedObjectContext!, title: title, text: text, guide: guide)
        save()
    }
    
    // Save data to Core Data.
    func save() {
        var error : NSError?
        if(managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
}
