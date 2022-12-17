//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        coinManager.getCoinPrice(for: currencyLabel.text!)
    }


}

extension ViewController: UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
        
    }
    
    
}

extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //titleForRow: When the PickerView is loading up, it will ask its delegate for a row title and call the above method once for every row.
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //didSelectRow: will get called every time when the user scrolls the picker.
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        currencyLabel.text = selectedCurrency
    }
}

extension ViewController: CoinManagerDelegate{
    func didUpdatePrice(_ coinManager: CoinManager, _ priceString: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = priceString
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    
}
