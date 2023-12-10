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
    numberFormatter.currencySymbol = "" // Remover o símbolo de moeda se necessário
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

func convertNumberStringToDouble(_ numberString: String) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "pt_BR")
    formatter.numberStyle = .decimal

    if let number = formatter.number(from: numberString) {
        return "\(number.doubleValue)"
    } else {
        return ""
    }
}


