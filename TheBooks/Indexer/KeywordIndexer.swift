//
//  TokenIndexer.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 08/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation

class IndexItem : Hashable{
    var identifier:Int
    var rank:Int
    
    init(id: Int, rank: Int) {
        self.identifier = id
        self.rank = rank
    }
    
    var hashValue: Int{
        return identifier.hashValue
    }
    
    static func == (lhs: IndexItem, rhs: IndexItem) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.rank == rhs.rank
    }
    
    static func < (lhs: IndexItem, rhs: IndexItem) -> Bool{
        return lhs.identifier < rhs.identifier
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
/**
 Implements a keyword indexing mechanism where each keyword will be mapped to the list Index item where each index item represent
    a record using an identifier with rank
 **/
class KeywordIndexer{
    
    /***
    Keyword Index Set
    {
    "keyword1" -> [[1,3], [2,2], [5, 1].........],
    "keyword2" -> [[6,3], [3,2], [8, 1].........]
    }
    **/
    var keywordIndexSet = [String:Set<IndexItem>]()
    
    /**
    Data Model
    {
    "1" : {BookModel}
    "2" : {BookModel}
    .
    .
    .
    .
    }
    **/
    var dataModel = [String:BookModel]()
    
    
    var searchResultSet : Set<IndexItem> = Set<IndexItem>()
    
    //Process the book data so that keywords of book gets added to index
    //set
    func addBookToIndexSet( book: BookModel){
        
        //Add the incoming book data to data model
        self.addBookToDataModel(book: book)
        
        //Tokenize and add title keywords to index with a rank of 1
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.title),
                         bookIdentifier: Int(book.bookIdentifier),
                         rank: SearchWeights.Title.weightage())
        
        //Tokenize and add author keywords to index with a rank of 2
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.author),
                         bookIdentifier: Int(book.bookIdentifier),
                         rank: SearchWeights.Author.weightage())
        
        //Tokenize and add publisher keywords to index with a rank of 2
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.publisher),
                         bookIdentifier: Int(book.bookIdentifier),
                         rank: SearchWeights.Publisher.weightage())
        
        //Tokenize and add contributor keywords to index with a rank of 2
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.contributor),
                         bookIdentifier: Int(book.bookIdentifier),
                         rank: SearchWeights.contributor.weightage())
        
        //Tokenize and add contributor keywords to index with a rank of 3, Also
        //enable stop words all stop words in the description will be discarded
        self.updateIndex(tokens: Tokenizer.getTokenizedString(string:book.description,
                                                              useStopWords: true),
                         bookIdentifier: Int(book.bookIdentifier),
                         rank: SearchWeights.description.weightage())
    }
    
    //add book data to model
    private func addBookToDataModel(book:BookModel){
        dataModel[String(book.bookIdentifier)] = book
    }
    
    func updateIndex(tokens:[String.SubSequence], bookIdentifier: Int, rank: Int){
        
        //For each word on tokens
        for word in tokens {
            let keyword = String(word)
            //Checked if keyword already indexed
            if var indexedRecords  = keywordIndexSet[keyword] {
                //check if the incmoing record is already indexed
                if let record = indexedRecords.index(where: {$0.identifier == bookIdentifier}){
                    let existingRecord = indexedRecords[record]
                    //if the incoming rank is higher, replace it with new item
                    if rank < existingRecord.rank {
                        let item = IndexItem(id: bookIdentifier, rank: rank)
                        indexedRecords.insert(item)
                        keywordIndexSet.updateValue(indexedRecords, forKey: keyword)
                    }
                }else{ // add incoming record to index records
                    let item = IndexItem(id: bookIdentifier, rank: rank)
                    indexedRecords.insert(item)
                    keywordIndexSet.updateValue(indexedRecords, forKey: keyword)
                }
            }else{ // add keyword as new item
                let item = IndexItem(id: bookIdentifier, rank: rank)
                keywordIndexSet[keyword] = [item]
            }
        }
    }
    
    func getResultsetAll()->[BookModel]{
        
        //sort using keys and return complete set
        let sorted = self.dataModel.sorted { $0.key < $1.key }
        return Array(sorted.map({ $0.value }))
    }
    
    func getResultSet(searchString : String) -> [BookModel]{
        
        var resultSet = [BookModel]()
        var searchSet : Set<String> = Set<String>()
        
        //preprocess the search string
        let searchQuery = Tokenizer.preprocessString(string: searchString)
        
        //Split search string into words
        let searchStrings = searchQuery.lowercased().split{ $0 == " "}
        for searchKey in searchStrings {
            //get all the keywords starting with search key
            let resultSetKeys = keywordIndexSet.filter {
                let item = $0
                return item.key.hasPrefix(String(searchKey))
            }
            
            //insert keywords to a set
            for (resultKey, _) in resultSetKeys{
                searchSet.insert(resultKey)
            }
            //End of the this loop will produce all the keywords that are matching to
            //all the wprds present in the search string
        }
        
        //clear existing search result
        searchResultSet.removeAll()
        
        // prepare result set for each keyword identfied above
        for keyword in searchSet {
            self.prepareResultSet(key: keyword)
        }//end of this loop will produce a set with IndexItems covering all the keywords
        
        
        //Sort the result set based on rank so that the result set will be aligned accoring to
        //the weightage set
        let sortedSearchResultSet = self.searchResultSet.sorted { $0.rank < $1.rank}
        for record in sortedSearchResultSet{
            //retreive the book data from the data model using identifier as key
            if let recordItem = dataModel[String(record.identifier)]{
                resultSet.append(recordItem)
            }
        }
        
        return resultSet
    }
    
    func clearAll(){
        self.keywordIndexSet = [:]
        self.dataModel = [:]
        self.searchResultSet = []
    }
    
    private func prepareResultSet(key: String){
        if let recordSet = keywordIndexSet[key] {
            //using set here will automatically remove all duplicate IndexItem
            //retrevied because of multiple keyword search
            searchResultSet = searchResultSet.union(recordSet.map{ $0 })
        }
    }
    
    func printCurrentIndex(){
        for (key,value) in self.keywordIndexSet {
            Log.d("----------\(key)----------")
            for indexItem in value{
                Log.d("id: \(indexItem.identifier) rank:\(indexItem.rank)")
            }
        }
    }
    
    func printDataIndex(){
        for (key,value) in self.dataModel {
            Log.d("----------\(key)----------")
            Log.d("title: \(value.title) author:\(value.author) publisher: \(value.publisher) contribted:\(value.contributor) desc: \(value.description)")
        }
    }
    
}

