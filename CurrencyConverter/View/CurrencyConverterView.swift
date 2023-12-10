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
        ZStack {
            Color(hex: "#132A13").ignoresSafeArea()
            
            VStack {
                Text("Conversor de Moedas")
                    .foregroundStyle(Color(hex: "#ECF39E")).bold().font(.title2)
                
                Spacer()
                
                ZStack {
                    DashedRectangle(dashedWidth: .constant(350), dashedHeight: .constant(50), dashedColor: .constant("#ECF39E"))
                    Picker("Moeda Base", selection: $viewModel.selectedBaseCurrency) {
                        ForEach(viewModel.currencyRelations.keys.sorted(), id: \.self) { key in
                            Text("\(key) - \(viewModel.currencyNames[key] ?? "")").tag(key)
                        }
                    }
                    .accentColor(Color(hex: "#ECF39E"))
                }
                
                Spacer()
                
                ZStack {
                    DashedRectangle(dashedWidth: .constant(350), dashedHeight: .constant(50), dashedColor: .constant("#ECF39E"))
                    Picker("Moeda Esperada", selection: $viewModel.selectedTargetCurrency) {
                        ForEach(Array(viewModel.currencyRelations[viewModel.selectedBaseCurrency] ?? []).sorted(), id: \.self) { key in
                            Text("\(key) - \(viewModel.currencyNames[key] ?? "")").tag(key)
                        }
                    }
                    .accentColor(Color(hex: "#ECF39E"))
                }
                
                Spacer()
                
                ZStack {
                    DashedRectangle(dashedWidth: .constant(350), dashedHeight: .constant(60), dashedColor: .constant("#ECF39E"))

                    if viewModel.amountToConvert.isEmpty {
                        Text("Valor")
                            .foregroundColor(Color(hex: "#ECF39E"))
                            .padding(.leading, 10)
                    }

                    TextField("", text: $viewModel.amountToConvert)
                        .keyboardType(.decimalPad)
                        .foregroundColor(Color(hex: "#ECF39E"))
                        .font(.title2)
                        .padding()
                }

                Spacer()
                
                Text(viewModel.convertedAmount)
                    .font(.title)
                    .foregroundStyle(Color(hex: "#ECF39E"))

                Spacer()

                Button(action: viewModel.convertCurrency) {
                    Text("Converter")
                        .font(.title2)
                        .foregroundStyle(Color(hex: "#ECF39E"))
                }
                .padding()
                .background(Color(hex: "#31572C"))
                .cornerRadius(20)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            viewModel.loadCurrencyRelations(showConvert: false)
        }
    }
}


#Preview {
    CurrencyConverterView()
}
