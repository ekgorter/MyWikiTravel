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
    var articleText: String!
    
    // Indicates if the article is to be loaded from Core Data or Wikitravel.org.
    var onlineSource: Bool!
    
    // Variable allows quick use of API methods.
    var api: MediaWikiAPI!
    
    // Required by Core Data to save data.
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var articleTextView: UITextView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = MediaWikiAPI(delegate: self)
        
        // Display either article text from online article or from saved article in app.
        if onlineSource == true {
            title = article.title
            // MediaWiki API requires "%20" instead of spaces.
            api.getArticleText(article.title.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
            api.getImage(article.title.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        } else {
//            self.articleTextView.text = articleText
            self.refactorArticleText(articleText)
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
            self.articleText = articleText
            self.refactorArticleText(articleText)
        })
    }
    
    func imageAPIResults(imageUrl: String) {
        dispatch_async(dispatch_get_main_queue(), {
            if let url = NSURL(string: imageUrl) {
                if let data = NSData(contentsOfURL: url){
                    
                    self.articleImageView.image = UIImage(data: data)
                }
            }
        })
    }
    
    // When "save" button is pressed, article is saved to guide and view pops to guide.
    @IBAction func saveArticleBarButton(sender: AnyObject) {
        saveArticle(article.title, text: self.articleText, guide: article.guide)
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
    
    func refactorArticleText(articleText: String) {
        
        let formattedText = self.formatString(articleText)
        
        self.articleTextView.attributedText = formattedText
    }
    
    func formatString(articleText: String) -> NSMutableAttributedString {
        
        var attributedString = addArticleTextAttributes(articleText)
        
        // remove all "=" characters from main string
        attributedString.mutableString.replaceOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedString.length))
        
        // remove all "Edit" substrings from headers
        attributedString.mutableString.replaceOccurrencesOfString("Edit", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    func addArticleTextAttributes(articleText: String) -> NSMutableAttributedString {
        
        // Create attributed string
        var attributedString = NSMutableAttributedString(string: articleText)
        
        // Separate string into array
        var myArray : [String] = articleText.componentsSeparatedByString("==")
        
        // Iterate over string parts in array
        for i in 0...(myArray.count - 1) {
            // every uneven array item is a header
            if i % 2 != 0 {
                // select header string
                let textToEdit = myArray[i]
                
                // select header in main string and change attribute
                var range = (articleText as NSString).rangeOfString(textToEdit)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(20) , range: range)
            }
        }
        return attributedString
    }
}