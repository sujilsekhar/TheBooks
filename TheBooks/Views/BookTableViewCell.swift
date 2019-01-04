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
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var contributor: UILabel!
    @IBOutlet weak var descr: UILabel!
    
    override func awakeFromNib() {
        descr.sizeToFit();
    }
    
    func setup(_ book: TBBook) {
        title.text = book.title
        author.text = book.author
        publisher.text = book.publisher
        contributor.text = book.contributor
        descr.text = book.description
    }
    

}
