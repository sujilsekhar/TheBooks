//MIT License
//
//Copyright © 2019 Sujil Chandresekharan
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import UIKit

/**
 Plays the role of view model in MVVM design pattern
 
 Encapsulates following operations
    1. Fetch data from service
    2. Saving to local datbase
    3. Facilitates fetch, search and deletion of book data
    4. Updates the books list using a binder
 
 */
class BooksViewModel{
    
    var serviceManager = ServiceManager()
    var booksRepository = BooksRepository()
    var keyWordIndexer = KeywordIndexer()
    
    var booklist: Binder<[BookModel]> = Binder(nil)
    
    /**
     This method opens the local SQlite db and creates the required tables
 
    */
    func openDatabase() throws{
        do {
            try booksRepository.openDatabase()
        }
        catch( let message) {
            throw message
        }
    }
    
    /**
     This method retrieves book data from service and update the view using th binder
     Returns error through a completion block
     
     */
    func getBookList(date:String, completion: @escaping (_ error: String?)->()) {
        
        serviceManager.getBookList(date: date) { (response, error) in
            
            if error != nil {
                completion(error)
                return
            }
            
            guard let responseData = response else {
                completion("No books available on the selected date")
                return
            }
            
            //Currently we are deleting existing books when a new api call kicks in
            //TODO: Identify the delta and update the same only
            self.deleteBooks()
            
            var identifier:UInt = 1
            for list in responseData.results.lists{
                for book in list.books{
                    
                    let bookData = BookModel()
                    bookData.title = book.title
                    bookData.author =  book.author
                    bookData.publisher = book.publisher
                    bookData.contributor = book.contributor
                    bookData.description = book.description
                    bookData.bookUrl = book.bookUrl
                    bookData.bookIdentifier = identifier
                    
                    identifier += 1
                    
                    self.keyWordIndexer.indexBookData(book: bookData)
                    
                    
                    /*do {
                        try self.booksRepository.insertBook(book: book)
                    }
                    catch {
                        Log.e("Error while inserting data")
                    }*/
                }
            }
            
            /*do{
                if let booksList = try self.booksRepository.fetch(){
                    self.booklist.value = booksList
                }
            }catch( let message){
                completion(message.localizedDescription)
            }*/
            
            self.booklist.value = self.keyWordIndexer.getResultset();
            
            print(self.keyWordIndexer.printCurrentIndex())
            
            completion(nil)
        }
    }
    
    /**
     Implements search functionality using SQLLite FTS5 and return booklist
     
    */
    func searchInBooks(searchString: String){
        /*do{
            if let booksList = try self.booksRepository.search(text: searchString){
                self.booklist.value = booksList
            }
        }catch{
            Log.i("Search returned zero results")
        }*/
        
        print(searchString)
        if searchString.count == 0 {
            self.booklist.value = self.keyWordIndexer.getResultset();
        }else{
            let resultSet = self.keyWordIndexer.resultSet(searchString: searchString.lowercased())
            if resultSet.count > 0 {
                self.booklist.value = resultSet
            }else{
                self.booklist.value = [nil] as? [BookModel]
            }
        }
        
    }
    /**
     Retreives all book data from local db
    */
    func fetchAllBooks(){
        /*do{
            if let booksList = try self.booksRepository.fetch(){
                self.booklist.value = booksList
            }
        }catch{
            Log.e("Error while fetching data")
        }*/
        self.booklist.value = self.keyWordIndexer.getResultset();
    }
    
    /**
     deletes all book data from local db
     */
    func deleteBooks(){
        do {
            try self.booksRepository.deleteBooks()
        }
        catch {
            Log.e("Error while deleting data")
        }
    }
    
}
