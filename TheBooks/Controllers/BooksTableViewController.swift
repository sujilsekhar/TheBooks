//
//  TBBooksTableViewController.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 03/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import UIKit

class BooksTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var booksListView: UITableView!
    
    @IBOutlet weak var noBooksLabel: UILabel!
    
    
    let booksViewModel = BooksViewModel()
    let datePicker  = UIDatePicker()
    let dateFormatter = DateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(addTapped))
        
        booksListView.isHidden = true
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Position the date picker
        let frame = CGRect(x: 5, y: 20, width: self.view.frame.width - 20, height: 200)
        datePicker.frame = frame
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()

        getBookListFromViewModel(date: Date())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTapped(){
        self.showDatePicker()
    }

}

extension BooksTableViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksViewModel.bookslist.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else {
            return BookTableViewCell()
        }
        
        let book = booksViewModel.bookslist[indexPath.row]
        cell.setup(book)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
    

}

extension BooksTableViewController{
    
    func showDatePicker(){
     
      let dateChooserAlert = UIAlertController(title: "Choose date...",
                                               message: nil,
                                               preferredStyle: .actionSheet)
      dateChooserAlert.view.addSubview(datePicker)
      dateChooserAlert.addAction(UIAlertAction(title: "Done",
                                               style: .cancel,
                                               handler: { action in
            self.getBookListFromViewModel(date: self.datePicker.date)
      }))
      let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
      dateChooserAlert.view.addConstraint(height)
      self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
    func getBookListFromViewModel(date:Date){
        
        
        self.booksViewModel.getBoolList(date: self.dateFormatter.string(from: date), completion: { error in
            
            DispatchQueue.main.async {
                if self.booksViewModel.bookslist.count > 0 {
                    self.booksListView.isHidden = false
                    self.booksListView.reloadData()
                }else{
                    self.booksListView.isHidden = true
                }
                
             }
            
        })
    }
    
    
}

