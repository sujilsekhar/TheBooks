//
//  Box.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation

class Binder<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T? {
        didSet {
            listener?(value!)
        }
    }
    
    init(_ value: T?) {
        if let value = value {
            self.value = value
        }
        self.value = nil
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        
        if let value = value {
            listener?(value)
        }
    }
}
