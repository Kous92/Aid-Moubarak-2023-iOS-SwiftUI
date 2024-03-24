//
//  EidButton.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 27/06/2023.
//

import SwiftUI

struct EidButton: View {
    let title: String
    
    var body: some View {
        Text(NSLocalizedString(title, comment: ""))
            .fontWeight(.semibold)
            .frame(width: UIScreen.main.bounds.width * 0.7, height: Constants.goldenButtonHeight, alignment: .center)
            .font(.system(size: Constants.goldenButtonFontSize))
            .foregroundStyle(.image(Image("GoldFoil")))
            .background(Color("DarkBlue"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.image(Image("GoldFoil")), lineWidth: 1)
            )
    }
}

struct EidButton_Previews: PreviewProvider {
    static var previews: some View {
        EidButton(title: "title1")
            .preferredColorScheme(.dark)
    }
}
