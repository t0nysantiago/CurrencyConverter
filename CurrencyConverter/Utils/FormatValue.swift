//
//  File.swift
//  CurrencyConverter
//
//  Created by Tony Santiago on 08/12/23.
//

import Foundation

func formatAsCurrency(_ number: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.currencySymbol = ""
    numberFormatter.currencyGroupingSeparator = "."
    numberFormatter.currencyDecimalSeparator = ","
    numberFormatter.minimumFractionDigits = 2
    numberFormatter.maximumFractionDigits = 2

    if let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) {
        return formattedNumber
    } else {
        return "Formato inválido"
    }
}

func convertToDecimalFormat(_ numberString: String) -> String {
    return numberString.replacingOccurrences(of: ",", with: ".")
}
