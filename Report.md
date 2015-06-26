#MyWikiTravel *Report*

*By Elias Gorter 6052274*

---
##1. App description

###Inspiration

When travelling, bringing a travelguide in some form (book, ebook, flyer, tourguide) can greatly enhance the travelling experience. It informs the users about what sights to see, what hotels to sleep in, where to eat and many other things. Each medium used for a travelguide brings its own advantages and disadvantages. A book does not require a battery or internet connection but it may be out of date, can be a heavy thing to bring along and many times it contains more information than is needed for your specific trip. A digital means for getting travel information (for example looking up information on the web) is light, easier to keep up to date and you can look up only the information you need, when you need it. But looking up this information may require an internet connection, which is not always readily available abroad due to extra provider costs or remote locations. Also, having to continuously look up information on the internet may be a nuisance. The goal of this app will be to remove some of the disadvantages of current travelguide media and combine some of their advantages into a useful personal travelguide app to bring along on your trips.

###App functionality

This app aims to allow the user to create a personal travelguide, containing informative articles on all locations to be visited on a certain trip. These articles can be selected and downloaded in advance so they are accessible offline. The source of all travel information articles will be [wikitravel.org](www.wikitravel.org/en). This is a community driven website containing a very large database on countries and locations around the world, with information ranging from transportation and safety instructions to attractions and (historical) background information.  

In this app, the user will be able to create a "guide" which can then be filled with articles from wikitravel about all locations that are to be visited during this trip. The articles can be sorted, for example on a day to day basis. This provides the user with a travelguide that contains only the information needed by the user and accessible offline. This removes the problems of requiring an internet connection during use and being presented with more information than needed.

---
##2. Technical design

###Overview

This app was written in the Swift language for iPhones using iOS 8 or higher, using Xcode version 6.3.

* View controllers:
  * MyGuidesViewController
  * GuideViewController
  * SearchViewController
  * ArticleViewController
  
* Classes and Structs
  * MediaWikiAPI
  * CoreData
  * Guide
  * Article
  * SearchResult
  * GuideCell
  
###Data management

All data used in the app is managed by Core Data. This allows both data persistence and easier data management. Two Core Data entities are used in the app: Guide and Article. The Guide entity consists of a title property, allowing users to create a guide with a name of their choice, and a one-to-many relationship with the Article entity, meaning that a guide may contain several articles. The Article entity has three properties, one for the article title, one for the article text and one for the article image. It has a one-to-one relationship with a Guide entity, meaning that it belongs to a certain guide.

All Core Data methods implemented in this app are defined in the CoreData.swift file. The NSManagedObject representations of the Guide and Article entities are found in Guide.swift and Article.swift.

###MediaWiki API

The title, text and images in the articles are retrieved from the english version of [wikitravel.org](www.wikitravel.org/en). This website makes use of a version of the MediaWiki API that is also used for Wikipedia amongst others. Four API requests are defined in MediaWikiAPI.swift: one for searching for articles, one for getting the text of an article, one for getting a list of images belonging to an article and one for getting the url of a specific image. All requests return an answer in the JSON format, which is then unpacked to retrieve the desired values.

###Miscellaneous

The two remaining files (not counting the view controllers) are GuideCell.swift and SearchResult.swift. GuideCell is a subclass of UITableViewCell, in which an outlet to a label has been added. This allows for the custom made cells used for displaying the guides in the tableview in MyGuidesViewController. SearchResult.swift contains the struct SearchResult, with which all article titles found by the MediaWiki API following a search are represented. A struct is used here, rather than just a string, with the plan in mind that it would also contain image thumbnails instead of just the string with the article title. After failed attempts to implement this, the struct still serves a special function since it also holds a reference to the guide the article will belong to if the user chooses to save it. 

###ViewControllers

This app uses four view controllers. The first (root) view is the MyGuidesViewController. Here all created guides are displayed in a tableview with custom tableview cells. A new guide may be added by pressing the *new* button in the top right corner. In the alert view the user may enter a name for the new guide and when *ok* is pressed the guide is added to the table and to Core Data. A guide can be deleted by swiping the cell from right to left and pressing *delete*. This also removes all articles belonging to this guide from Core Data.

When pressing a guide the GuideViewController is presented to the user. It shows all articles saved in the guide selected by the user in a tableview. A saved article may be deleted by swiping it's cell from right to left and pressing *delete*. Pressing an article cell will display the article contents in the ArticleViewController. Pressing *add* in the top right corner will segue to the SearchViewController.

In the SearchViewController a user may enter a string in the search bar, which is then used by the MediaWiki API to search for matches on the Wikitravel website. The resulting list of article titles is then displayed in the tableview. Pressing a search result will load this article in the ArticleViewController.

The ArticleViewController is used to display the articles, both from online or offline sources. It has a UIImageView on top in which an image belonging to the article is displayed. If no image was found, it displays a placeholder image. Below the UIImageView is a UITextView which is used to display the article text, after this text has been modified to make it more suitable for use (increasing the font size of headers etc.). When this viewcontroller is first loaded, it will first check if the content to display is from a saved article or from an online article. If the source is online it will use the MediaWiki API to fetch both the article text and image. If the source is a saved article, the text and image saved in the Article entity are displayed instead. If the article displayed is from an online source, the *save* button in the top right corner may be pressed. This creates a new Article entity loaded with the currently displayed article contents and adds it to the currently selected guide. The view is immediately segued to the GuideViewController.

---
##3. Challenges and design decisions

###Design goals result

All three essential design goals from the design document have been achieved as the user can search Wikitravel content, save it for offline use and organize it with guides. One of the optional features, a custom made UI, has also been implemented. Below follow some of the biggest challenges and design decisions during the making of this app.


###NSUserDefaults vs Core Data

Initially, the plan was to use NSUserDefaults for all data persistency in the app. Soon it was discovered however that saving class objects (in this case Guides and Articles) was not possible with NSUserDefaults without some data manipulation. Core Data seemed a difficult subject to master, but with the help of some excellent online tutorials it proved to be not that difficult as it seemed. It turned out to be the perfect way to manage data, as it allows all kinds of useful actions beyond just data persistence. For example, deleting a Guide will automatically delete all Articles belonging to that Guide from storage.

###Search function

The biggest struggle during the making of this app was working with the MediaWiki API. It was the first time I worked with an API so I followed a tutorial that explained how to use the iTunes API. This API was extremely easy to use, almost anything required could be obtained with a single query. The MediaWiki API however turned out to be very frustrating at times. Whether this was because of my inexperience as a programmer and working with web formats or because it was simply a bad API I am not sure, probably both. The first example of this is the fact that you are forced to choose between two types of search. You can use either opensearch or srsearch. Opensearch allows search with uncomplete search strings (eg. "amster" finds "amsterdam") but does not allow multiple search strings such as "new york". Srsearch is the opposite and does allow multiple search strings but does not recognize uncomplete search strings. I have decided to go with srsearch because it seemed more usefull to be able to type "new york" and actually find something. With more development time, these two search functions could probably have been combined,filtering out all double results.

###UITextView or UIWebView

The most frustrating thing during the making of this app was  displaying the articles from [wikitravel.org](www.wikitravel.org/en) in the app. The MediaWiki API had very many ways of retrieving page contents, but none seemed to be perfect. I tried displaying the mobile website of Wikitravel in a webview, but did not know how to save it for offline use and remove unwanted items such as advertisment banners. I also tried retrieving the html and then displaying the html string in the webview, this was somewhat succesful but I had some trouble working with the html since I am unfamiliar with it. I ended up retrieving the plain text of the article, applying any formatting such as increasing the font size of headers manually, and displaying it in a textview. This was the best I could do without more time to learn how to work with html, css, xml and other web formats properly. 

###Searchresult thumbnails

During the third week of development, a lot of time was lost trying to add thumbnails of article images to the searchresult cells. For this a multitude of queries was required. First the article titles had to be found with the normal search query. Then a list of images had to be requested for each article. From this list an image had to be selected, this was tricky because it also contained unwanted items such as banners or buttons. I decided to select the first image that contained the article title in it's title, as this seemed to be a suitable image most of the time. Then finally, the url for the selected image had to be requested. This had to be done for every searchresult, and because I was handeling all API requests asynchronously I had difficulties getting all requests to wait for each other until they were all finished. As it was costing too much time I decided to move on to other issues first. I did end up using the image search functionality for displaying an image in the ArticleViewController.

