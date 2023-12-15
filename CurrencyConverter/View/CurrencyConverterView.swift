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
                
                HStack {
                    VStack(alignment: .center) {
                        Text("Moeda Base")
                            .foregroundStyle(Color(hex: "#ECF39E"))
                            .padding(.bottom, 30)
                        Picker("Moeda Base", selection: $viewModel.selectedBaseCurrency) {
                            ForEach(viewModel.currencyRelations.keys.sorted(), id: \.self) { key in
                                    Text("\(key) ").tag(key)
                            }
                        }
                        .accentColor(Color(hex: "#ECF39E"))
                    }.fixedSize()

                    Spacer()

                    VStack(alignment: .center) {
                        Text("Moeda Esperada")
                            .foregroundStyle(Color(hex: "#ECF39E"))
                            .padding(.bottom, 30)
                        Picker("Moeda Esperada", selection: $viewModel.selectedTargetCurrency) {
                            ForEach(Array(viewModel.currencyRelations[viewModel.selectedBaseCurrency] ?? []).sorted(), id: \.self) { key in
                                    Text("\(key) ").tag(key)
                            }
                        }
                        .accentColor(Color(hex: "#ECF39E"))
                    }.fixedSize()
                }

                Spacer()
                
                VStack (alignment: .leading){
                    Text("Valor para Conversão")
                        .foregroundStyle((Color(hex: "#ECF39E")))
                    
                    TextField("", text: $viewModel.amountToConvert)
                        .keyboardType(.decimalPad)
                        .font(.title3)
                        .foregroundStyle(Color(hex: "#ECF39E"))
                        .padding()
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .offset(y: 5),
                            alignment: .bottom
                        )
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
            }
            .padding()
            .padding(.horizontal, 30)
        }
        .onAppear {
            viewModel.loadCurrencyRelations(showConvert: false)
        }
    }
}


#Preview {
    CurrencyConverterView()
}
