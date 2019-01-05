//
//  TBBooksViewModel.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import UIKit

class BooksViewModel{
    
    var bookslist = [BookModel]()
    var serviceManager = ServiceManager()
    
    init() {
    }
    
    func getBoolList(date:String, completion: @escaping (_ error: String?)->()) {
        
        self.bookslist.removeAll()
        serviceManager.getBookList(date: date) { (response, error) in
            guard let responseData = response else {
                print("Error/Null response data")
                completion("Error/Null response data")
                return
            }
            
            
            for list in responseData.results.lists{
                for bookData in list.books{
                    let book = BookModel()
                    book.title = bookData.title
                    book.author = bookData.author
                    book.contributor = bookData.contributor
                    book.publisher = bookData.publisher
                    book.description = bookData.description
                    book.bookUrl = bookData.bookUrl
                    self.bookslist.append(book)
                }
            }
            
            completion("")
        }
    }
    
}
