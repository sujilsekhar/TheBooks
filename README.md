# The Books

The Books is an iOS Application that allows user to browse through the books information available through https://api.nytimes.com. 

![alt text](https://github.com/sujilsekhar/TheBooks/blob/master/AppSnapshot.png?raw=true)


# Development  Note

The Book application is developed using MVVM design pattern and below are the detials some of the high level modules 

| Modules | Details |
| ------ | ------ |
| **_BooksTableViewController_** | The controller which manages user interface of the application |
| **_BooksViewModel_** | The view model which encapsulates the buisiness rules of the application |
| **_BookModel_** | Object representation of  a book item |
| **_ServiceManager_** | The manager which handles the service api interactions and retreival of data |
| **_BooksApi_** | Defines the end point attributes of the books api |
| **_EndPointRouter_** | Wraps underlying network infrastructure and provides methods for interacting with api's |
| **_KeywordIndexer_** |  Implements an indexed based data structure that facilitates an in memory search mechanism. Please refer to code comments for more details* |





License
----

MIT


