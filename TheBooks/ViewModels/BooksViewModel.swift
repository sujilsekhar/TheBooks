//
//  TBBooksViewModel.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import UIKit

class BooksViewModel{
    
    //var bookslist = [BookModel]()
    var serviceManager = ServiceManager()
    var booksRepository = BooksRepository()
    
    var booklist: Binder<[BookModel]> = Binder(nil)
    
    init() {
        
        booksRepository.openDatabase()
    }
    
    func getBookList(date:String, completion: @escaping (_ error: String?)->()) {
        
        do {
            try self.booksRepository.deleteBooks()
        }
        catch {
            
        }
        
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
                    do {
                        try self.booksRepository.insertBook(book: book)
                    }
                    catch {
                        
                    }
                }
            }
            
            if let booksList = self.booksRepository.fetch(){
                self.booklist.value = booksList
            }
            
            completion("")
        }
    }
    
    func searchInBooks(searchString: String){
        if let booksList = self.booksRepository.search(text: searchString){
            self.booklist.value = booksList
        }
    }
    
    func fetchAllBooks(){
        if let booksList = self.booksRepository.fetch(){
            self.booklist.value = booksList
        }
    }
    
}
