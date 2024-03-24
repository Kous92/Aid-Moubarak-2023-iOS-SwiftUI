//
//  SettingsView.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 24/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    private let sounds = ["Takbir 1", "Al Afasy TV", "Mishary bin Rashid Al Afasy", "Al Sheikh Hashem Al Saqaf"]
    @State private var selectedSound: String = "Takbir 1"
    
    var body: some View {
        ZStack {
            Image("EidBlueGradient")
                .resizable()
                .ignoresSafeArea(.all)
                .zIndex(0)
            
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.image(Image("GoldFoil")))
                            .font(.system(size: 40, weight: .semibold))
                            .glowBorder(color: .black, lineWidth: 3)
                    }
                }
                .position(x: geometry.safeAreaInsets.leading + 40, y: geometry.safeAreaInsets.top)
                .zIndex(1)
                
                VStack {
                    Text("Son du Takbir de l'Aïd")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundStyle(.image(Image("GoldFoil")))
                        .glowBorder(color: .black, lineWidth: 2)
                        .multilineTextAlignment(.center)
                        // .position(x: geometry.size.width / 2, y: 0)
                    
                    List {
                        Picker("", selection: $selectedSound) {
                            ForEach(sounds, id: \.self) { sound in
                                Text(sound)
                                    .foregroundStyle(.image(Image("GoldFoil")))
                                    // .listRowBackground(Image(""))
                                    // .listSectionSeparator(.hidden)
                            }
                        }
                        .listRowBackground(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)))
                        .pickerStyle(.inline)
                    }
                    .scrollContentBackground(.hidden)
                    .zIndex(2)
                    /*
                    List(sounds, id: \.self) { sound in
                        Text(sound)
                            .foregroundStyle(.image(Image("GoldFoil")))
                            // .listRowBackground(Image(""))
                            .listRowBackground(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)))
                            // .listSectionSeparator(.hidden)
                    }
                    //.background(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)))
                    .scrollContentBackground(.hidden)
                     */
                    
                    
                }
            }
        }
    }
}

#Preview("Settings screen (English)") {
    SettingsView()
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "en"))
}

#Preview("Écran des paramètres (Français)") {
    SettingsView()
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "fr"))
}
