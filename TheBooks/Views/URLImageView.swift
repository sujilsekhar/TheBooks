//
//  URLImageView.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import UIKit

class URLImageView: UIImageView {

    private var imageURL: URL?
    
    func from(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        imageURL = url
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    print("Image \(url) not loaded")
                    return
            }
            DispatchQueue.main.async() {
                if self.imageURL! == url {
                    self.image = image
                }
            }
            }.resume()
    }
    
    func from(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            print("Image \(link) not loaded")
            return
        }
        from(url: url, contentMode: mode)
    }

}
