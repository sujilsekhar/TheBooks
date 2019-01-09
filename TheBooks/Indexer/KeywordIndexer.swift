//
//  TokenIndexer.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 08/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation

class IndexItem {
    var identifier:Int
    var rank:Int
    
    init(id: Int, rank: Int) {
        self.identifier = id
        self.rank = rank
    }
}

enum SearchWeights {
    
    case Title
    case Author
    case Publisher
    case contributor
    case description
    
    func weightage()-> Int {
        switch self {
        case .Title:
            return 1
        case .Author, .Publisher, .contributor:
            return 2
        case .description:
            return 3
        }
    }
    
}

class KeywordIndexer{
    
    var keywordIndex = [String:[IndexItem]]()
    
    var dataIndex = [String:BookModel]()
    
    
    func indexBookData( book: BookModel){
        
        dataIndex[String(book.bookIdentifier)] = book
        
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.title), bookIdentifier: Int(book.bookIdentifier), rank: SearchWeights.Title.weightage())
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.author), bookIdentifier: Int(book.bookIdentifier), rank: SearchWeights.Author.weightage())
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.publisher), bookIdentifier: Int(book.bookIdentifier), rank: SearchWeights.Publisher.weightage())
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.contributor), bookIdentifier: Int(book.bookIdentifier), rank: SearchWeights.contributor.weightage())
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.description, useStopWords: true), bookIdentifier: Int(book.bookIdentifier), rank: SearchWeights.description.weightage())
        
    }
    
    func updateIndex(tokens:[String.SubSequence], bookIdentifier: Int, rank: Int){
        for word in tokens {
            let keyword = String(word)
            if var indexedRecords  = keywordIndex[keyword] {
                if let record = indexedRecords.index(where: {$0.identifier == bookIdentifier}){
                    let existingRecord = indexedRecords[record]
                    if existingRecord.rank > rank {
                        indexedRecords[record] = IndexItem(id: bookIdentifier, rank: rank)
                        keywordIndex.updateValue(indexedRecords, forKey: keyword)
                    }
                }else{
                    let item = IndexItem(id: bookIdentifier, rank: rank)
                    indexedRecords.append(item)
                    keywordIndex.updateValue(indexedRecords, forKey: keyword)
                }
            }else{
                let item = IndexItem(id: bookIdentifier, rank: rank)
                keywordIndex[keyword] = [item]
            }
        }
        
        
    }
    
    func getResultset()->[BookModel]{
    
        let sorted = self.dataIndex.sorted { $0.key < $1.key }
        return Array(sorted.map({ $0.value }))
    }
    
    func resultSet(searchString : String) -> [BookModel]{
        
        var resultSet = [BookModel]()
        
        let searchStrings = searchString.lowercased().split{ $0 == " "}
        
        for searchKey in searchStrings {
            let resultSetKeys = keywordIndex.filter {
                let item = $0
                return item.key.contains(String(searchKey))
            }
            
            for (resultKey, _) in resultSetKeys{
                resultSet.append(contentsOf:(self.getResultSetforIndex(key: resultKey)))
            }
        }
        
        
        
        return resultSet
    }
    
    func getResultSetforIndex(key: String)->[BookModel]{
        var resultSet = [BookModel]()
        if let recordSet = keywordIndex[key] {
            let sortedRecordSet = recordSet.sorted{$0.rank < $1.rank}
            for record in sortedRecordSet{
                if let recordItem = dataIndex[String(record.identifier)]{
                    resultSet.append(recordItem)
                }
            }
        }
        
        return resultSet
    }
    
    func printCurrentIndex(){
        for (key,value) in self.keywordIndex {
            
            print("----------\(key)----------")
            for indexItem in value{
                print("id: \(indexItem.identifier) rank:\(indexItem.rank)")
            }
            
        }
    }

}

