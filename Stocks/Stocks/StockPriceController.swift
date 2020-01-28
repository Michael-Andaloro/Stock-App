//
//  StockPriceController.swift
//  Stocks
//
//  Created by Michael on 12/16/19.
//  Copyright © 2019 Michael. All rights reserved.
//

// This file gets the prices of the stocks based on the return of the StockNameController Function.
import UIKit

protocol StockPriceDelegate: class {
    func stockUpdated ()
}

// JSON decoder for the stock price
class StockPriceObject: NSObject {
    var companyName = ""
    var symbolName = ""
    var tableViewCellText = ""
    var lastPrice = ""
    var lastPriceDownloaded = false
    weak var delegate: StockPriceDelegate?
    
    init(stockDictionary:Dictionary<String, String>, delegate: StockPriceDelegate ) {
        super.init()
        
        if stockDictionary["symbolName"] != nil {self.symbolName = stockDictionary["symbolName"]!}
        if stockDictionary["companyName"] != nil {self.companyName = stockDictionary["companyName"]!}
        
        self.tableViewCellText = self.symbolName
        self.delegate = delegate
    }
    
    // Function to retreive the JSON of the stock and filter out the price. Called recursively until all stocks have been matched up with their prices
    func downloadStockPrice(){
        self.lastPriceDownloaded = true
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: "https://quote.cnbc.com/quote-html-webservice/quote.htm?symbols=\(self.symbolName)&output=json"){
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else {
                        print("Error")
                        return
                    }
                    
                    // Finds the last price reported before the site was accessed
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonDict = json as? Dictionary<String, Any>{
                        if let quickQuoteResult = jsonDict["QuickQuoteResult"] as? Dictionary<String, Any>{
                            if let quickQuote = quickQuoteResult["QuickQuote"] as? Dictionary<String, Any>{
                                if let p = quickQuote["last"]{
                                    self.lastPrice = p as! String
                                    self.tableViewCellText.append(": $\(self.lastPrice)")
                                    self.delegate?.stockUpdated()
                                }
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
