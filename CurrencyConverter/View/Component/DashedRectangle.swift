//
//  DashedRectangle.swift
//  CurrencyConverter
//
//  Created by Tony Santiago on 08/12/23.
//

import SwiftUI

struct DashedRectangle: View {
    @Binding var dashedWidth: Float
    @Binding var dashedHeight: Float
    @Binding var dashedColor: String
    var body: some View {
        Path { path in
            let rect = CGRect(x: 0, y: 0, width: CGFloat(dashedWidth), height: CGFloat(dashedHeight))
            let cornerRadius: CGFloat = 10
            path.addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        }
        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
        .foregroundColor(Color(hex: dashedColor))
        .frame(width: CGFloat(dashedWidth), height: CGFloat(dashedHeight))
        .background(Color.clear)
    }
}

#Preview {
    DashedRectangle(dashedWidth: .constant(350), dashedHeight: .constant(100), dashedColor: .constant(""))
}
