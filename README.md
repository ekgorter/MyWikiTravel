#Personal Travel Guide *(title pending)*

##IOS App Proposal

###Problem

When travelling, bringing a travelguide in some form (book, ebook, flyer, tourguide) can greatly enhance the travelling experience. It informs the users about what sights to see, what hotels to sleep in, where to eat and many other things. Each medium used for a travelguide brings its own advantages and disadvantages. A book does not require a battery or internet connection but it may be out of date, can be a heavy thing to bring along and many times it contains more information than is needed for your specific trip. A digital means for getting travel information (for example looking up information on the web) is light, easier to keep up to date and you can look up only the information you need, when you need it. But looking up this information may require a internet connection, which is not always readily available abroad due to extra provider costs or remote locations. Also, having to continuously look up information on the internet may be a nuisance. The goal of this app will be to remove some of the disadvantages of current travelguide media and combine some of their advantages into a useful personal travelguide app to bring along on your trips.

###App description

This app aims to allow the user to create a personal travelguide, containing informative articles on all locations to be visited on a certain trip. These articles can be selected and downloaded in advance so they are accessible offline. The source of all travel information articles will be [wikitravel.org](www.wikitravel.org/en). This is a community driven website containing a very large database on countries and locations around the world, with information ranging from transportation and safety instructions to attractions and (historical) background information. The information on this website is licensed with a creative commons license, so it may be used by third parties when conforming to some guidelines. 

In this app, the user will be able to create a "trip" which can then be filled with articles from wikitravel about all locations that are to be visited during this trip. The articles can be sorted, for example on a day to day basis. This provides the user with a travelguide that contains only the information needed by the user and accessible offline. The collection of downloaded articles is to be presented in a clear, visually attractive and easily navigable way. This removes the problems of requiring a internet connection during use and being presented with more information than needed.

Additionally, some other features useful for travellers may be added, such as packing lists, bookkeeping, local maps, weather, etc. depending on available time for development. Also, wikitravel is available in a wide range of languages. Initially only the English articles are to be used, since they make up the largest database. A function to choose the desired language may be added later.

###Data & Structure

This app will be developed for iPhones using iOS, in XCode using the language Swift. The two main parts of the app will be:

* Searching through the contents of [wikitravel.org](www.wikitravel.org/en) and downloading the selected articles.
* Presenting the saved articles in a easily navigable, clear and visually attractive way.

The main source of data for this app will be the articles on [wikitravel.org](www.wikitravel.org/en). Searching and downloading articles from [wikitravel.org](www.wikitravel.org/en) may be done using the [wikitravel API](http://wikitravel.org/wiki/en/api.php). The functionality of the search and download portion of the app will depend largely on succesfully integrating the API in the app. The downloaded articles will need to be stored inside the app, perhaps `NSUserDefaults` will suffice, since most data will be text. 

Once the desired articles have been downloaded and saved within the app, they need to be presented in a intuitive and clear way. XCode provides all required building blocks for creating a user interface that allows the users to sort and navigate a collection of articles, such as a `navigation controller`, `tab bar` or `table view`. 

###Potential Difficulties

The most difficult portion of making this app will be integrating the wikitravel API with the app, allowing the user to both navigate the wikitravel contents and saving the selected articles inside the app. Also converting the format/data structure of the articles on the wikitravel website to a format used inside the app may provide some challenges. 

The second part of making a functional user interface should be more straightforward. 

###Similar Apps

There is currently one app in the App Store that allows the user to browse the contents of [wikitravel.org](www.wikitravel.org/en): *Turdus*. Besides searching and reading the articles, the app also allows the user to save articles (bookmarks). The saved articles are however not ordered or presented in any particular way that would resemble something like a personal travelguide. The aim of this app will be to provide most or all functionality of *Turdus*, while additionally ordering and presenting the saved articles in a more attractive and clear way allowing the user to use this app as a personal travelguide. 

###Early Sketches User Interface

###Planning

1. Week 1
   * App Proposal
   * Development Plan
   * UI Prototype
2. Week 2
   * Implementing Wikitravel API
   * User should be able to browse and save Wikitravel              articles in the app.
3. Week 3
   * Implementing user interface for representation and ordering of wikitravel articles in app.
   * Additional features if time allows it.
4. Week 4
   * Finishing touches.
   * Writing final project reports.
   * Presentation of working app.





