//MIT License
//
//Copyright © 2019 Sujil Chandresekharan
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation

/**
 Binder class used by model view to update the UI elements
 */
class Binder<T> {
    typealias Listener = (T?) -> Void
    var listener: Listener?
    
    /**
     To retreive the value. Used by listener to fetch the values and update the UI
     */
    var value: T? {
        didSet {
            if let value = value {
                listener?(value)
            }else{
                listener?(nil)
            }
        }
    }
    
    init(_ value: T?) {
        if let value = value {
            self.value = value
        }
    }
    
    /**
     Method to bind a listener
    */
    func bind(_ listener: Listener?) {
        self.listener = listener
        
        if let value = value {
            listener?(value)
        }
    }
}
