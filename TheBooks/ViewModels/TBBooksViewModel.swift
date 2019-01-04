//
//  TBBooksViewModel.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import UIKit

class TBBooksViewModel{
    
    var bookslist = [TBBook]()
    
    init() {
        
        var book = TBBook()
        book.author = "Test1"
        book.contributor = "contri1"
        book.publisher = "publish1"
        book.title = "title1"
        book.description = "desc1"
        
        bookslist.append(book)
        
        book = TBBook()
        book.author = "Test2"
        book.contributor = "contri2"
        book.publisher = "publish2"
        book.title = "title2"
        book.description = "desc2"
        
        bookslist.append(book)
    }
    
}
