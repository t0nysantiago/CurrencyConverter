//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by Tony Santiago on 06/12/23.
//

import SwiftUI

struct ListCurrencyConverterView: View {
    @ObservedObject private var viewModel = CurrencyViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.currencyRelations.keys.sorted(), id: \.self) { key in
                Section(header: Text("\(key) - \(viewModel.currencyNames[key] ?? "")")) {
                    ForEach(Array(viewModel.currencyRelations[key] ?? []).sorted(), id: \.self) { relatedCurrency in
                        Text("\(relatedCurrency) - \(viewModel.currencyNames[relatedCurrency] ?? "")")
                    }
                }
            }
            .onAppear {
                viewModel.loadCurrencyRelations()
            }
            .alert(isPresented: Binding<Bool>.constant(viewModel.errorMessage != nil), content: {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            })
        }
    }
}


#Preview {
    ListCurrencyConverterView()
}
