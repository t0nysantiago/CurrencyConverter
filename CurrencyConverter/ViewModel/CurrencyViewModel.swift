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
    
    private var currencyService = CurrencyService()
    
    func loadCurrencyRelations() {
        isLoading = true
        currencyService.fetchCurrencyRelations { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let (relations, names)):
                    self?.currencyRelations = relations
                    self?.currencyNames = names
                    if let firstBaseCurrency = relations.keys.sorted().first {
                        self?.selectedBaseCurrency = firstBaseCurrency
                        if let firstTargetCurrency = relations[firstBaseCurrency]?.sorted().first {
                            self?.selectedTargetCurrency = firstTargetCurrency
                        }
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func convertCurrency() {
        guard !amountToConvert.isEmpty, let amount = Double(amountToConvert) else {
            self.convertedAmount = "Invalid input"
            return
        }
        
        currencyService.fetchExchangeRate(from: selectedBaseCurrency, to: selectedTargetCurrency) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rate):
                    self?.convertedAmount = "\(Double(round(10000000 * amount * rate) / 10000000))"
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
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
