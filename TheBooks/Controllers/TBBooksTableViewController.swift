//
//  TBBooksTableViewController.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 03/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import UIKit

class TBBooksTableViewController: UITableViewController {
    
    let booksViewModel = TBBooksViewModel()
    
    let datePicker  = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        // Position the date picker
        let frame = CGRect(x: 5, y: 20, width: self.view.frame.width - 20, height: 200)
        datePicker.frame = frame
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()


        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTapped(){
        self.showDatePicker()
    }

}

extension TBBooksTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksViewModel.bookslist.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else {
            return BookTableViewCell()
        }
        
        let book = booksViewModel.bookslist[indexPath.row]
        cell.setup(book)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
    

}

extension TBBooksTableViewController{
    
    func showDatePicker(){
     
      let dateChooserAlert = UIAlertController(title: "Choose date...",
                                               message: nil,
                                               preferredStyle: .actionSheet)
      dateChooserAlert.view.addSubview(datePicker)
      dateChooserAlert.addAction(UIAlertAction(title: "Done",
                                               style: .cancel,
                                               handler: { action in
            // API call to get the updated list
      }))
      let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
      dateChooserAlert.view.addConstraint(height)
      self.present(dateChooserAlert, animated: true, completion: nil)
    }
    
}

