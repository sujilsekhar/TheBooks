//
//  BookTableViewCell.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    static let identifier = "BookCell"
    
    @IBOutlet weak var posterImage: URLImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var contributor: UILabel!
    @IBOutlet weak var descr: UILabel!
    
    override func awakeFromNib() {
        descr.sizeToFit();
    }
    
    func setup(_ book: BookModel) {
        posterImage.image = UIImage(named: "BookCoverPlaceHolder")
        posterImage.from(link: book.bookUrl)
        title.text = book.title
        author.text = book.author
        publisher.text = book.publisher
        contributor.text = book.contributor
        descr.text = book.description
    }
    

}
