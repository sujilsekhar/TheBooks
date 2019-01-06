# The Books

The Books is an iOS Application that allows user to browse through the books information available through https://api.nytimes.com. 

![alt text](https://github.com/sujilsekhar/TheBooks/blob/master/AppSnapshot.png?raw=true)


# Development  Note

The Book application is developed using MVVM design pattern and below are the detials some of the high level modules 

| Modules | Details |
| ------ | ------ |
| **_BooksTableViewController_** | The controller which manages user interface of the application |
| **_BooksViewModel_** | The view model which encapsulates the buisiness logic of the application |
| **_BookModel_** | Object representation of  a book item |
| **_ServiceManager_** | The manager which handles the service api interactions and retreival of data |
| **_BooksApi_** | Defines the end point attributes of the books api |
| **_EndPointRouter_** | Wraps underlying network infrastructure and provides methods for interacting with api's |
| **_SQLiteDatabase_** | Swift wrapper for SQlite C Api's |
| **_BooksRepository_** |  Wraps various db related functionalities and provide  operations like *Open local db, Create tables, Insert book data, Fetch book data, Search book data( Uses FTS5 Sql lite feature for searching), Delete books* |





License
----

MIT


