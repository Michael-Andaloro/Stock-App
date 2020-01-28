//
//  StockPriceManager.swift
//  Stocks
//
//  Created by Michael on 12/16/19.
//  Copyright © 2019 Michael. All rights reserved.
//

// This file gets the input from the user and uses it to get data from CNBC
// Once data is retreived, it sorts the data and sends it to the tableview
import UIKit

class StockNameController: NSObject {
    var stocks: Array<StockPriceObject> = []
    var jsonDataTask: URLSessionDataTask?
    weak var delegate: StockPriceDelegate?
    
    var queryText = ""
    var lastSearch = ""
    var queryTimer : Timer?
    
    // This function controls the search field. When the user types, there is a delay before it is sent to CNBC. The reason for this is because without the delay, there would just be an insane amount of data coming from the server as each character change prompted another data transfer and the app would crash
    func queryTextChange (text:String){
        self.lastSearch = text
        if self.lastSearch.hasPrefix(self.queryText) && stocks.count == 0 && self.queryText != ""{
        }
        else if text.count>1{
            if self.queryText != text{
                self.queryTimer?.invalidate()
                self.queryText = text
                queryTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(downloadStockSymbols), userInfo: nil, repeats: false)
            }
        }
        else{
            self.queryText = ""
            self.stocks.removeAll()
            self.delegate?.stockUpdated()
        }
    }
    
    // This function sends the search input to CNBC and parses through the returned JSON file. The results are then sent to the stockpriceviewcontroller which then gets the prices and posts them
    @objc func downloadStockSymbols() {
        DispatchQueue.global(qos: .background).async {
           self.jsonDataTask?.cancel()
            
            if let url = URL(string: "https://symlookup.cnbc.com/symservice/symlookup.do?prefix=\(self.queryText)&partnerid=20064&pgok=1&pgsize=50"){
                self.jsonDataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data else {
                        print("Error")
                        return
                    }
                    
                    self.stocks.removeAll()
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonArray = json as? [Dictionary<String, String>]{
                        for stockDict in jsonArray{
                            var duplicates = [String: String]()
                            if let stockName = stockDict["symbolName"]{
                                if duplicates[stockName] == nil{
                                    let stock = StockPriceObject.init(stockDictionary: stockDict, delegate: self.delegate!)
                                    self.stocks.append(stock);
                                    duplicates[stockName] = "EXISTS!"
                                }
                            }
                        }
                    }
                    self.delegate?.stockUpdated()
                }
                self.jsonDataTask?.resume()
            }
        }
    }
}
