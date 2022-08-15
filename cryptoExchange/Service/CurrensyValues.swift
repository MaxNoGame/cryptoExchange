//
//  CurrensyValues.swift
//  cryptoExchange
//
//  Created by Maksym Ponomarchuk on 14.07.2022.
//

import Foundation


struct CurrensyValues {
    
    private struct Constants {
        static let keyForValue: String = "values"
    }
    
    static var currencyText = "BTC, ETH, USDT, USDC, BNB, -, USD, EUR, GBP, PLN, UAH,"
    static var currencyArray : [String]? {
        get {
            var newArray = [String]()
            let defaults = UserDefaults.standard
            if let newString = defaults.string(forKey: Constants.keyForValue) {
                
                var currentWord = ""
                for i in newString {
                    switch i {
                    case ",": newArray.append(currentWord)
                    case " ": currentWord = ""
                    default: currentWord += String(i)
                    }
                }
            }
            return newArray
        } set {
            print(newValue!)
        }
    }
    
    static func setDefaults(values: String) {
        let defaults = UserDefaults.standard
        defaults.set(values, forKey: Constants.keyForValue)
    }
    
    static func getDefaults() -> String? {
        let defaults = UserDefaults.standard
        if let getValues = defaults.string(forKey: Constants.keyForValue) {
            return getValues
        }
        return nil
    }
    
    func buildArray(newString: String) -> [String] {

        var newArray = [String]()
        var currentWord = ""
        for i in newString {
            switch i {
            case ",": newArray.append(currentWord)
            case " ": currentWord = ""
            default: currentWord += String(i)
            }
        }
        return newArray
    }
    
}
