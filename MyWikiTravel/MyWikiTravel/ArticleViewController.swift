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
    
    let coreData = CoreData()
    var article: Searchresult!
    var articleText: String!
    var imageData: NSData!
    var onlineSource: Bool!
    var api: MediaWikiAPI!
    
    @IBOutlet weak var articleTextView: UITextView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = MediaWikiAPI(delegate: self)
        
        // Display either article text from online article or from saved article in app.
        if onlineSource == true {
            title = article.title
            api.getArticleText(article.title.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
            api.getImage(article.title.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
        } else {
            self.refactorArticleText(articleText)
            articleImageView.image = UIImage(data: imageData)
            // Removes save button.
            self.navigationItem.rightBarButtonItems = []
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
    
    // Set imageview image to be the image as retrieved from wikitravel.org (if any).
    func imageAPIResults(imageUrl: String) {
        dispatch_async(dispatch_get_main_queue(), {
            if let url = NSURL(string: imageUrl) {
                if let data = NSData(contentsOfURL: url) {
                    self.articleImageView.image = UIImage(data: data)
                }
            }
        })
    }
    
    // When "save" button is pressed, article is saved to guide and view pops to guide.
    @IBAction func saveArticleBarButton(sender: AnyObject) {
        saveArticle(article.title, text: self.articleText, image: UIImagePNGRepresentation(self.articleImageView.image), guide: article.guide)
        self.navigationController?.popToViewController(navigationController!.viewControllers[1] as! UIViewController, animated: true)
    }
    
    // Save the currently displayed article.
    func saveArticle(title: String, text: String, image: NSData, guide: Guide) {
        coreData.createNewArticle(title, text: text, image: image, guide: guide)
        coreData.save()
    }
    
    // Performs operations required to improve text retrieved from API.
    func refactorArticleText(articleText: String) {
        let formattedText = self.formatString(articleText)
        self.articleTextView.attributedText = formattedText
    }
    
    // Removes unwanted symbols and patterns from text.
    func formatString(articleText: String) -> NSMutableAttributedString {
        var attributedString = addTextAttributes(articleText)
        
        // remove all "=" characters from main string.
        attributedString.mutableString.replaceOccurrencesOfString("=", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedString.length))
        
        // remove all "Edit" substrings from headers.
        attributedString.mutableString.replaceOccurrencesOfString("Edit", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    // Find headers in text and increase their font size.
    func addTextAttributes(articleText: String) -> NSMutableAttributedString {
        var attributedString = NSMutableAttributedString(string: articleText)
        
        // Separate text into array of strings, where every uneven item is a header.
        var separatedText: [String] = articleText.componentsSeparatedByString("==")
        
        // Iterate over each string in array.
        for stringItem in 0...(separatedText.count - 1) {
            
            // every uneven string item is a header.
            if stringItem % 2 != 0 {
                
                // select header string.
                let textToEdit = separatedText[stringItem]
                
                // select header in main string and increase font size.
                var range = (articleText as NSString).rangeOfString(textToEdit)
                attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(20) , range: range)
            }
        }
        return attributedString
    }
}