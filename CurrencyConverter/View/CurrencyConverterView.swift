//
//  CurrencyConverterView.swift
//  CurrencyConverter
//
//  Created by Tony Santiago on 07/12/23.
//

import SwiftUI

struct CurrencyConverterView: View {
    @ObservedObject private var viewModel = CurrencyViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Selecionar Moedas")) {
                    Picker("Moeda Base", selection: $viewModel.selectedBaseCurrency) {
                        ForEach(viewModel.currencyRelations.keys.sorted(), id: \.self) { key in
                            Text("\(key) - \(viewModel.currencyNames[key] ?? "")")
                                .tag(key)
                        }
                    }.onChange(of: viewModel.selectedBaseCurrency) {
                        viewModel.updateTargetCurrencyForBaseCurrency()
                    }
                    
                    Picker("Moeda Esperada", selection: $viewModel.selectedTargetCurrency) {
                        ForEach(Array(viewModel.currencyRelations[viewModel.selectedBaseCurrency] ?? []).sorted(), id: \.self) { key in
                            Text("\(key) - \(viewModel.currencyNames[key] ?? "")")
                                .tag(key)
                        }
                    }
                }
                
                Section(header: Text("Quantidade para Converter")) {
                    TextField("Quantidade", text: $viewModel.amountToConvert)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Total")) {
                    Text(viewModel.convertedAmount)
                }
                
                Button("Converter") {
                    viewModel.convertCurrency()
                }
                
                Section {
                    NavigationLink(destination: ListCurrencyConverterView()) {
                        Text("Possíveis Conversões")
                    }
                }
                
            }
            .onAppear {
                viewModel.loadCurrencyRelations()
            }
            .navigationTitle("Conversor De Moedas")
        }
    }
}



#Preview {
    CurrencyConverterView()
}
