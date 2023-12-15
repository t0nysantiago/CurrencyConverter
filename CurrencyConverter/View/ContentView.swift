//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Tony Santiago on 06/12/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = CurrencyViewModel()
    @State private var defaultValue: Double = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#132A13").ignoresSafeArea()
                
                VStack (alignment: .center) {
                    Spacer(minLength: 70)
                    
                    Text("Conversor de Moedas")
                        .foregroundStyle(Color(hex: "#ECF39E")).bold().font(.title2)
                    
                    Spacer(minLength: 50)
                    
                    HStack{
                        Spacer()
                        ZStack{
                            DashedRectangle(dashedWidth: .constant(350), dashedHeight: .constant(100), dashedColor: .constant("#ECF39E"))
                            
                            HStack {
                                Picker("Moeda Base", selection: $viewModel.selectedBaseCurrency) {
                                    ForEach(viewModel.currencyRelations.keys.sorted(), id: \.self) { key in
                                        Text("\(key) \n\(viewModel.currencyNames[key] ?? "")")
                                            .tag(key)
                                    }
                                }
                                .padding(.leading, 20)
                                .accentColor(Color(hex: "#ECF39E"))
                                .onChange(of: viewModel.selectedBaseCurrency, {
                                    viewModel.updateTargetCurrencyForBaseCurrency()
                                    viewModel.loadCurrencyRelations(showConvert: true)
                                })
                                
                                Spacer()
                                
                                Text("\(formatAsCurrency(defaultValue))")
                                    .font(.system(size: 35))
                                    .foregroundStyle(Color(hex: "#ECF39E"))
                                    .padding(.trailing, 40)
                            }
                        }
                        Spacer()
                    }
                    
                    Spacer(minLength: 70)
                    
                    NavigationLink(destination: CurrencyConverterView()) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.title2)
                                .foregroundStyle(Color(hex: "#ECF39E"))
                            
                            Text("Conversor Direto")
                                .font(.title2)
                                .foregroundStyle(Color(hex: "#ECF39E"))
                        }
                    }
                    
                    Spacer(minLength: 70)
                    
                    ListCurrencyRelationsView(viewModel: viewModel)
                        .cornerRadius(40)
                        .shadow(radius: 10)
                }
                .ignoresSafeArea()
            }.onAppear {
                viewModel.loadCurrencyRelations(showConvert: true)
                viewModel.amountToConvert = "\(defaultValue)"
            }
        }
    }
}


#Preview {
    ContentView()
}
