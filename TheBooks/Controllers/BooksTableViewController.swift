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

import UIKit

class BooksTableViewController: UIViewController {
    
    @IBOutlet var booksListView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noBooksLabel: UILabel!
    
    
    let booksViewModel = BooksViewModel()
    var bookslist = [BookModel]()
    
    let datePicker  = UIDatePicker()
    let dateFormatter = DateFormatter()
    var isNetworkCallActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up button for search
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(addTapped))
        
        //Initial visibility of UI elements
        booksListView.isHidden = true
        searchBar.showsCancelButton = true
        
        //Add a datepicker to select a date
        self.addDatePicker()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Bind a closure so that UI can be updated when the underlying view model updates data
        self.booksViewModel.booklist.bind{ [unowned self] in
            self.bookslist  = $0
            
            DispatchQueue.main.async {
                if self.isNetworkCallActive {
                    self.view.activityStopAnimating()
                    self.isNetworkCallActive = false
                }
                
                if self.bookslist.count > 0 {
                    self.booksListView.isHidden = false
                    self.booksListView.reloadData()
                    self.booksListView.scroll(to: .top, animated: true)
                }else{
                    self.booksListView.isHidden = true
                }
            }
        }
        
        //Fetch the data for tpday to stary with
        self.getBookListForToday()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTapped(){
        self.showDatePicker()
    }

}

//MARK: - View Model 

extension BooksTableViewController{
    
    /**
        Query view model to fetch the data.
        This method only handles the error condition in the completion closure as
        sucess is handled through binder call back
    */
    func getBookListFromViewModel(date:Date){
        
        self.isNetworkCallActive = true
        self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        self.booksViewModel.getBookList(date: self.dateFormatter.string(from: date), completion: { error in
            if error != nil{
                
                DispatchQueue.main.async {
                    if self.isNetworkCallActive {
                        self.view.activityStopAnimating()
                        self.isNetworkCallActive = false
                    }
                    self.showAlert(message: error!)
                }
            }
        })
    }
    /**
       Query view model to fetch the data for today
    */
    func getBookListForToday(){
        do{
            try self.booksViewModel.openDatabase()
            getBookListFromViewModel(date: Date())
        }catch( _){
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.showAlert(message: "Error in initializing resources")
        }
    }
    
    
}

//MARK: - TableView

extension BooksTableViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookslist.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else {
            return BookTableViewCell()
        }
        
        let book = self.bookslist[indexPath.row]
        cell.setup(book)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
    
    
}

//MARK: - TableView

extension BooksTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.booksViewModel.searchInBooks(searchString: searchText);
        }else{
            self.booksViewModel.fetchAllBooks()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.booksViewModel.fetchAllBooks()
    }
    
}

//MARK: - Date Picker

extension BooksTableViewController{
    
    private func addDatePicker(){
        
        // Position the date picker
        var frame = CGRect.zero
        if DeviceType.IS_IPAD{
            frame = CGRect(x: 5, y: 20, width: 300, height: 250)
        }else{
            frame = CGRect(x: 5, y: 20, width: self.view.frame.width - 20, height: 250)
        }
        datePicker.frame = frame
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
    }
    
    func showDatePicker(){
        
        let dateChooserAlert = UIAlertController(title: "Choose date...",
                                                 message: nil,
                                                 preferredStyle: .actionSheet)
        
        if !DeviceType.IS_IPAD{
            datePicker.center.x = self.view.center.x
        }
        
        dateChooserAlert.view.addSubview(datePicker)
        if DeviceType.IS_IPAD{
            dateChooserAlert.popoverPresentationController?.sourceView = self.view
            dateChooserAlert.popoverPresentationController?.sourceRect = self.datePicker.bounds
        }
        
        dateChooserAlert.addAction(UIAlertAction(title: "Done",
                                                 style: .default,
                                                 handler: { action in
                                                    self.getBookListFromViewModel(date: self.datePicker.date)
        }))
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooserAlert.view.addConstraint(height)
        dateChooserAlert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
}


