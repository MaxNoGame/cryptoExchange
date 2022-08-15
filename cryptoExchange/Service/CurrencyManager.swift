//
//  CurrencyManager.swift
//  cryptoExchange
//
//  Created by Maksym Ponomarchuk on 13.07.2022.
//

import Foundation

protocol CurrencyManagerDelegate {
    func updateRates(rate: Double)
    func errorMessage(text: String)
}

class CurrencyManager {
    
    let baseLink = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "apikey=46DACEDE-5729-40BE-B72A-D4526E390500"
    var delegate: CurrencyManagerDelegate?
    
    func setupLink (picker1: String, picker2: String) {
        let readyLink = "\(baseLink)/\(picker1)/\(picker2)?\(apiKey)"
        performRequest(readyLink)
    }
    
    func performRequest(_ link: String) {
        
        if let url = URL(string: link) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {data, response, error in
                
                if let safeData = data,
                   let rates = self.parseJson(rates: safeData) {
                    self.delegate?.updateRates(rate: rates)
                } else {
                    self.delegate?.errorMessage(text: error?.localizedDescription ?? "Perform URL request error")
                }
                
//                if error != nil {
//                    self.delegate?.errorMessage(text: error?.localizedDescription ?? "Perform URL request error")
//                    return
//                }
//                if let safeData = data {
//                    if let rates = self.parseJson(rates: safeData) {
//                        self.delegate?.updateRates(rate: rates)
//                    }
//                }
            }
            task.resume()
        }
    }
    
    func parseJson(rates: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RatesData.self, from: rates)
            let rate = decodedData.rate
            return rate
        } catch {
            delegate?.errorMessage(text: "JSON parsing error")
        }
        return nil
    }
}
