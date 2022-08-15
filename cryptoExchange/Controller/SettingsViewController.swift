//
//  SettingsViewController.swift
//  cryptoExchange
//
//  Created by Maksym Ponomarchuk on 14.07.2022.
//

import UIKit

protocol SettingsDelegate {
    func updateScreen()
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var delegate: SettingsDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = unpackCurrencyArray()

    }
    
    @IBAction func savePushed(_ sender: UIButton) {
        packCurrencyArray()
        delegate?.updateScreen()
        dismiss(animated: true)
        
    }
    /*
    func unpackCurrencyArray() -> String {
        var outString = ""
        for i in 0..<CurrensyValues.currencyArray!.count {
            if i < CurrensyValues.currencyArray!.count {
                outString += "\(CurrensyValues.currencyArray![i]), "
            } else {
                outString += CurrensyValues.currencyArray![i]
            }
            
        }
        return outString
    }
     */
    
    func unpackCurrencyArray() -> String? {
        let defaults = UserDefaults.standard
        if let getValues = defaults.string(forKey: "values"){
            return getValues
        }
        return nil
    }
    
    func packCurrencyArray(){
        CurrensyValues.setDefaults(values: textView.text)
        let newString = textView.text
        var newArray = [String]()
        var currentWord = ""
        for i in newString! {
            switch i {
            case ",": newArray.append(currentWord)
            case " ": currentWord = ""
            default: currentWord += String(i)
            }
        }
        CurrensyValues.currencyArray = newArray
    }
    
}

// Hide keyboard when return is pushed
extension SettingsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
