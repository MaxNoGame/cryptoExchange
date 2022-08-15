//
//  ViewController.swift
//  cryptoExchange
//
//  Created by Maksym Ponomarchuk on 12.07.2022.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    @IBOutlet weak var cryptoLabelTop: UITextField!
    @IBOutlet weak var cryptoPickerTop: UIPickerView!
    @IBOutlet weak var cryptoLabelBottom: UITextField!
    @IBOutlet weak var cryptoPickerBottom: UIPickerView!
    @IBOutlet weak var infoLabel: UILabel!

    private var currencyManager = CurrencyManager()
    private var settings = SettingsViewController()
    private var firstCurrency: Double = 1
    private var pickerTop = "BTC"
    private var pickerBottom = "BTC"
    private var currentRate: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setups()
    }

    @IBAction func currencySettings(_ sender: UIButton) {
        performSegue(withIdentifier: "settings", sender: nil)
    }
    
    private func setups() {
        cryptoLabelTop.delegate = self
        cryptoLabelBottom.delegate = self
        cryptoPickerTop.delegate = self
        cryptoPickerTop.dataSource = self
        cryptoPickerBottom.delegate = self
        cryptoPickerBottom.dataSource = self
        cryptoLabelTop.text = String(firstCurrency)
        cryptoLabelBottom.isEnabled = false
        infoLabel.isEnabled = false
        currencyManager.delegate = self
        settings.delegate = self
    }
    
    private func showResult() {
        let outRate = firstCurrency * currentRate
        cryptoLabelBottom.text = String(format: "%.3f", outRate)
    }
}

extension ExchangeViewController: CurrencyManagerDelegate {
    func errorMessage(text: String) {
        DispatchQueue.main.async {
            self.infoLabel.text = text
        }
        
    }
    
    func updateRates(rate: Double) {
        DispatchQueue.main.async {
            self.currentRate = rate
            self.showResult()
            //self.cryptoLabel2.text = String(format: "%.3f", rate)
        }
    }
}


// MARK: Delegates and DataSources

extension ExchangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CurrensyValues.currencyArray?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CurrensyValues.currencyArray?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateScreen()
        switch pickerView.tag {
        case 1: guard CurrensyValues.currencyArray?[row] != "-" else {return}
            pickerTop = (CurrensyValues.currencyArray?[row])!
        case 2: guard CurrensyValues.currencyArray?[row] != "-" else {return}
            pickerBottom = (CurrensyValues.currencyArray?[row])!
        default: break
        }
        currencyManager.setupLink(picker1: pickerTop, picker2: pickerBottom)
    }
}

extension ExchangeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstCurrency = Double(cryptoLabelTop.text!)!
        showResult()
        cryptoLabelTop.resignFirstResponder()
        return true
    }
}

extension ExchangeViewController: SettingsDelegate {
    
    func updateScreen() {
        DispatchQueue.main.async {
            self.cryptoPickerTop.reloadAllComponents()
            self.cryptoPickerBottom.reloadAllComponents()
        }
    }
    
}


