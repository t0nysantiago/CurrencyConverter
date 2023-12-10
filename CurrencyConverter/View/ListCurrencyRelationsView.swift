//
//  ListCurrencyRelationsView.swift
//  CurrencyConverter
//
//  Created by Tony Santiago on 08/12/23.
//

import SwiftUI

struct ListCurrencyRelationsView: View {
    @ObservedObject var viewModel: CurrencyViewModel
    
    var body: some View {
        ZStack (alignment: .leading){
            (Color(hex: "#31572C")).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 10) {
                    if let currencyRelations = viewModel.currencyRelations[viewModel.selectedBaseCurrency] {
                        VStack(alignment: .leading) {
                            ForEach(currencyRelations.sorted(), id: \.self) { relatedCurrency in
                                HStack {
                                    Image(systemName: "dollarsign.square")
                                        .font(.title)
                                        .foregroundStyle(Color(hex: "#132A13"))
                                        .padding(.trailing, -10)
                                    
                                    Text("\(relatedCurrency) \n\(viewModel.currencyNames[relatedCurrency] ?? "")")
                                        .foregroundStyle(Color(hex: "#ECF39E"))
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Text(viewModel.convertedAmounts[viewModel.selectedBaseCurrency + relatedCurrency] ?? "...")
                                        .font(.title)
                                        .foregroundStyle(Color(hex: "#ECF39E"))
                                        .padding(.trailing, 10)
                                }
                            }
                        }
                    }
                }
                .padding()
                .alert(isPresented: Binding<Bool>.constant(viewModel.errorMessage != nil), content: {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
                })
//                .onAppear {
//                    viewModel.loadCurrencyRelations()
//                    viewModel.amountToConvert = "100"
//                }
            }
        }
    }
}

struct ListCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        let mockViewModel = CurrencyViewModel()

        return ListCurrencyRelationsView(viewModel: mockViewModel)
            .previewLayout(.sizeThatFits)
    }
}
