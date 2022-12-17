//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdatePrice(_ coinManager: CoinManager, _ priceString: String)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "697F0CC4-F61C-46DE-976D-20367BAA2D8A"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(url: urlString)
    }
    
    func performRequest(url: String){
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                }
                
                if let safeData = data {
                    if let priceString = self.parseJSON(safeData){
                        self.delegate?.didUpdatePrice(self, priceString)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> String?{
        let decoder = JSONDecoder()
        do{
            let priceData = try decoder.decode(PriceData.self, from: data)
            return String(format: "%.2f", priceData.rate)
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}

