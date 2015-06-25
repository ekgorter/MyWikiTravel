//
//  MediaWikiAPI.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 04-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// All methods for communicating with MediaWiki API are defined here.

import Foundation

// Protocol defining methods for retrieving MediaWiki API results.
@objc protocol MediaWikiAPIProtocol {
    optional func searchAPIResults(search: NSArray)
    optional func articleAPIResults(articleText: String)
    optional func imageAPIResults(imageUrl: String)
}

class MediaWikiAPI {
    var delegate: MediaWikiAPIProtocol
    
    init(delegate: MediaWikiAPIProtocol) {
        self.delegate = delegate
    }
    
    // Searches wikitravel.org with the inputted search term. Returns an array of article titles from JSON.    
    func searchWikiTravel(searchTerm: String) {
        let urlPath = "http://wikitravel.org/wiki/en/api.php?action=opensearch&search=\(searchTerm)&format=json&limit=50"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray {
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                self.delegate.searchAPIResults!(jsonResult[1] as! NSArray)
            }
        })
        task.resume()
    }
    
    // Gets the text content of defined article from wikitravel.org.
    func getArticleText(articleTitle: String) {
        let urlPath = "http://wikitravel.org/wiki/en/api.php?format=json&action=query&prop=extracts&explaintext=true&titles=\(articleTitle)"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let pages: NSDictionary = jsonResult["query"]?["pages"] as? NSDictionary {
                    if let id: String = pages.allKeys.first! as? String {
                        if let text: String = pages[id]!["extract"] as? String {
                            self.delegate.articleAPIResults!(text)
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    // ::TEST AREA::
    func getImage(articleTitle: String) {
        let urlPath = "http://wikitravel.org/wiki/en/api.php?action=query&prop=images&titles=\(articleTitle)&format=json&imlimit=500&imdir=descending"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let pages: NSDictionary = jsonResult["query"]?["pages"] as? NSDictionary {
                    if let id: String = pages.allKeys.first! as? String {
                        if let images: NSArray = pages[id]!["images"] as? NSArray {
                            
                            for image in images {
                                if let imageLocation: String = image["title"] as? String {
                                    if imageLocation.lowercaseString.rangeOfString(articleTitle.lowercaseString) != nil {
                                        self.getImageUrl(imageLocation.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    func getImageUrl(imageLocation: String) {
        let urlPath = "http://wikitravel.org/wiki/en/api.php?action=query&titles=\(imageLocation)&prop=imageinfo&iiprop=url&format=json"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let pages: NSDictionary = jsonResult["query"]?["pages"] as? NSDictionary {
                    if let imageInfo: NSArray = pages["-1"]?["imageinfo"] as? NSArray {
                        if let imageUrl: String = imageInfo[0]["url"] as? String {
                            self.delegate.imageAPIResults!(imageUrl)
                        }
                    }
                }
            }
        })
        task.resume()
    }
}