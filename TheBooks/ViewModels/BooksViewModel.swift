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
    var keyWordIndexer = KeywordIndexer()
    
    var booklist: Binder<[BookModel]> = Binder(nil)
    
    /**
     This method retrieves book data from service and update the view using the binder
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
            //Using an integer based identifier
            var identifier:UInt = 1
            
            //clear existing search result and its indexes
            self.keyWordIndexer.clearAll()
            
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
                    
                    self.keyWordIndexer.addBookToIndexSet(book: bookData)
                }
            }
            
            self.booklist.value = self.keyWordIndexer.getResultsetAll();
            completion(nil)
        }
    }
    
    /**
     Implements search functionality using an in memory search mechanism and return booklist
     
    */
    func searchInBooks(searchString: String){
        if searchString.isEmpty {
            self.booklist.value = self.keyWordIndexer.getResultsetAll();
        }else{
            let resultSet = self.keyWordIndexer.getResultSet(searchString: searchString.lowercased())
            if !resultSet.isEmpty {
                self.booklist.value = resultSet
            }else{
                self.booklist.value = [nil] as? [BookModel]
            }
        }
    }
    /**
     Retreives all book data from local cache
    */
    func fetchAllBooks(){
        self.booklist.value = self.keyWordIndexer.getResultsetAll();
    }
    
}
