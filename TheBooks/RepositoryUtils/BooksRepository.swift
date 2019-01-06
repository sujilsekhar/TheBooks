//
//  BooksRepository.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation
import SQLite3


class BooksRepository {
    
    var db:SQLiteDatabase?
    let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    private var titleWeight = 10.0
    private var authorWeight = 8.0
    private var publisherWeight = 6.0
    private var contributorWeight = 4.0
    private var descWeight = 1.0
    
    
    init() {
        db = nil
    }
    
    func openDatabase() throws{
        do {
            let fileManager = FileManager.default
            
            let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                in: .userDomainMask)
            
            guard documentsUrl.count != 0 else {
                return // Could not find documents URL
            }
            
            let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("Books.db")
            
            db = try SQLiteDatabase.open(path: finalDatabaseURL.absoluteString)
        
            do {
                try db?.createTable(table: BooksTable.self)
            } catch {
                throw SQLiteError.Step(message: db!.errorMessage)
            }
        } catch  {
            throw SQLiteError.OpenDatabase(message: db!.errorMessage)
        } 
    }
    
    func insertBook(book: Book) throws {
        let insertSql = "INSERT INTO Books (title, author, publisher, contributor, description, bookUrl) VALUES (?, ?, ?, ?, ?, ?);"
        let insertStatement = try db?.prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        guard sqlite3_bind_text(insertStatement, 1, book.title, -1, SQLITE_TRANSIENT) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 2, book.author, -1, SQLITE_TRANSIENT) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 3, book.publisher, -1, SQLITE_TRANSIENT) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 4, book.contributor, -1, SQLITE_TRANSIENT) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 5, book.description, -1, SQLITE_TRANSIENT) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 6, book.bookUrl, -1, SQLITE_TRANSIENT) == SQLITE_OK
            else {
                throw SQLiteError.Bind(message: db!.errorMessage)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: db!.errorMessage)
        }
    }
    
    func deleteBooks() throws {
        let deleteSql = "DELETE From Books;"
        let deleteStatement = try db?.prepareStatement(sql: deleteSql)
        defer {
            sqlite3_finalize(deleteStatement)
        }
        
        guard sqlite3_step(deleteStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: db!.errorMessage)
        }
    }
    
    func fetch() throws -> [BookModel]? {
        
        do{
            return try run(query: "SELECT title, author, publisher, contributor, description, bookUrl FROM books")
        }catch{
            throw SQLiteError.Step(message: db!.errorMessage)
        }
        
    }
    
    func search(text: String) throws -> [BookModel]? {
        do{
            return try run(query: "SELECT title, author, publisher, contributor, description, bookUrl FROM books WHERE books MATCH '\(text)*' AND rank MATCH 'bm25(\(titleWeight), \(authorWeight), \(publisherWeight), \(contributorWeight), \(descWeight) )' ORDER BY rank")
        }catch{
            throw SQLiteError.Step(message: db!.errorMessage)
        }
    }
    
    private func run(query: String) throws -> [BookModel] {
        
        var books: [BookModel] = []
        
        let runStatement = try db?.prepareStatement(sql: query)
        
        defer {
            sqlite3_finalize(runStatement)
        }
        
        
        while sqlite3_step(runStatement) == SQLITE_ROW {
            if
                let cTitle = sqlite3_column_text(runStatement, 0),
                let cAuthor = sqlite3_column_text(runStatement, 1),
                let cPublisher = sqlite3_column_text(runStatement, 2),
                let cContributor = sqlite3_column_text(runStatement, 3),
                let cDescription = sqlite3_column_text(runStatement, 4),
                let cBookUrl = sqlite3_column_text(runStatement, 5)
            {
                
                
                let bookModel = BookModel()
                
                bookModel.title = String(cString: cTitle)
                bookModel.author = String(cString: cAuthor)
                bookModel.publisher = String(cString: cPublisher)
                bookModel.contributor = String(cString: cContributor)
                bookModel.description = String(cString: cDescription)
                bookModel.bookUrl = String(cString: cBookUrl)
                
                books.append(bookModel)

            }
        }
        
        return books
    }
    
    

}

protocol SQLTable {
    static var createStatement: String { get }
}

struct BooksTable: SQLTable {
    static var createStatement: String {
        return """
        CREATE VIRTUAL TABLE IF NOT EXISTS books
        USING FTS5(title, author, publisher, contributor, description, bookUrl UNINDEXED);
        """
    }
}

