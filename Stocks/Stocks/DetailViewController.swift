//
//  DetailViewController.swift
//  Stocks
//
//  Created by Michael on 12/18/19.
//  Copyright © 2019 Michael. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    struct Details: Codable{
        var symbol: String
        var open: String
        var high: String
        var low: String
        var price: String
        var volume: String
        var latesttradingday: String
        var previousclose: String
        var change: String
        var changepercent: String
    }


}
