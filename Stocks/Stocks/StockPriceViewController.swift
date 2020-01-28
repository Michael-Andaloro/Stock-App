//
//  StockPriceViewController.swift
//  Stocks
//
//  Created by Michael on 12/15/19.
//  Copyright © 2019 Michael. All rights reserved.
//


// This file handles the storyboard tablecell creations
import UIKit

class StockPriceViewController: UITableViewController, UISearchBarDelegate, StockPriceDelegate {
   
    // Add the search bar to the controls
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Calls the StockNameController file
    var stockNameController = StockNameController()
    
    // Loads the view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stockNameController.delegate = self
    }

    // Sets the number of rows to add to the view as 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Sets the number of rows equal to the number of stocks found
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stockNameController.stocks.count
    }
    
    // Controlls search bar, when text changes, modify text and send to stock name controller to update results
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var newText = searchText.replacingOccurrences(of: " ", with: "")
        newText = newText.lowercased()
        self.stockNameController.queryTextChange(text: newText)
    }
    
    // Simply updates the table once the results have been sorted
    func stockUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // Function to control the actual rows of the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath)
        let stock = self.stockNameController.stocks[indexPath.row]
        if !stock.lastPriceDownloaded {stock.downloadStockPrice()}
        cell.textLabel?.text = stock.tableViewCellText
        cell.textLabel?.textAlignment = .center
        return cell
    }
}
