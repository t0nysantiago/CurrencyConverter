//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Tony Santiago on 07/12/23.
//

import Foundation

class CurrencyViewModel: ObservableObject {
    @Published var currencyRelations: [String: Set<String>] = [:]
    @Published var currencyNames: [String: String] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedBaseCurrency: String = ""
    @Published var selectedTargetCurrency: String = ""
    @Published var amountToConvert: String = ""
    @Published var convertedAmount: String = ""
    @Published var convertedAmounts: [String: String] = [:]
    
    private var currencyService = CurrencyService()
    
    func loadCurrencyRelations(showConvert: Bool) {
        isLoading = true
        currencyService.fetchCurrencyRelations { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let (relations, names)):
                    self?.currencyRelations = relations
                    self?.currencyNames = names
                    if let selectedBase = self?.selectedBaseCurrency, !selectedBase.isEmpty, relations.keys.contains(selectedBase) {
                    } else {
                        if relations.keys.contains("BRL") {
                            self?.selectedBaseCurrency = "BRL"
                        } else if let firstBaseCurrency = relations.keys.sorted().first {
                            self?.selectedBaseCurrency = firstBaseCurrency
                        }
                    }
                    if let firstTargetCurrency = relations[self?.selectedBaseCurrency ?? ""]?.sorted().first {
                        self?.selectedTargetCurrency = firstTargetCurrency
                    }
                    
                    if(showConvert) {
                        self?.autoConvertCurrency()
                    }

                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }


    
    func convertCurrency() {
        guard !amountToConvert.isEmpty, let amount = Double(convertNumberStringToDouble(amountToConvert)) else {
            self.convertedAmount = "Valor Inválido"
            return
        }
        
        currencyService.fetchExchangeRate(from: selectedBaseCurrency, to: selectedTargetCurrency) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rate):
                    self?.convertedAmount = formatAsCurrency(amount * rate)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func autoConvertCurrency() {
        guard !amountToConvert.isEmpty, let amount = Double(amountToConvert) else {
            self.convertedAmounts = [:]
            return
        }
        
        guard let relatedCurrencies = currencyRelations[selectedBaseCurrency] else {
            return
        }

        for targetCurrency in relatedCurrencies {
            currencyService.fetchExchangeRate(from: selectedBaseCurrency, to: targetCurrency) { [weak self] result in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }

                    let key = strongSelf.selectedBaseCurrency + targetCurrency
                    switch result {
                    case .success(let rate):
                        strongSelf.convertedAmounts[key] = formatAsCurrency(amount * rate)
                    case .failure(let error):
                        strongSelf.convertedAmounts[key] = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
    }


    
    func updateTargetCurrencyForBaseCurrency() {
        if let targetCurrencies = currencyRelations[selectedBaseCurrency],
           !targetCurrencies.contains(selectedTargetCurrency),
           let firstTargetCurrency = targetCurrencies.sorted().first {
            DispatchQueue.main.async {
                self.selectedTargetCurrency = firstTargetCurrency
            }
        }
    }
}
