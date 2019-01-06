//
//  TBBooksViewModel.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import UIKit

class BooksViewModel{
    
    var serviceManager = ServiceManager()
    var booksRepository = BooksRepository()
    
    var booklist: Binder<[BookModel]> = Binder(nil)
    
    func openDatabase() throws{
        do {
            try booksRepository.openDatabase()
        }
        catch( let message) {
            throw message
        }
    }
    
    func getBookList(date:String, completion: @escaping (_ error: String?)->()) {
        
        serviceManager.getBookList(date: date) { (response, error) in
            
            if error != nil {
                completion(error)
            }
            
            guard let responseData = response else {
                completion("No books available on the selected date")
                return
            }
            
            
            self.deleteBooks()
            
            for list in responseData.results.lists{
                for book in list.books{
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
            
            completion(nil)
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
    
    private func deleteBooks(){
        do {
            try self.booksRepository.deleteBooks()
        }
        catch {
            
        }
    }
    
}
