//
//  HomeView.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 26/06/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var isPresentedFitr = false
    @State private var isPresentedAdha = false
    @State private var isPresentedSettings = false
    
    var body: some View {
        ZStack {
            Image("EidBlueGradient")
                .resizable()
                .ignoresSafeArea(.all)
                .zIndex(0)
            
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 10) {
                    Text("eidMubarak")
                        .font(.system(size: 40))
                        .foregroundStyle(.image(Image("GoldFoil")))
                        .glowBorder(color: .black, lineWidth: 2)
                        .fontWeight(.semibold)
                    
                    Text("menuTitle")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundStyle(.image(Image("GoldFoil")))
                        .glowBorder(color: .black, lineWidth: 2)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 25)
                .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 25)
            }
            
            VStack {
                Button {
                    isPresentedFitr.toggle()
                } label: {
                    EidButton(title: "title1")
                }
                .fullScreenCover(isPresented: $isPresentedFitr) {
                    withAnimation {
                        EidMubarakView(viewModel: EidMubarakViewModel(animationDataFileName: "EidAlFitrAnimationData"))
                    }
                }
                .padding(.bottom, 30)
                
                Button {
                    isPresentedAdha.toggle()
                } label: {
                    EidButton(title: "title2")
                }
                .fullScreenCover(isPresented: $isPresentedAdha) {
                    withAnimation {
                        EidMubarakView(viewModel: EidMubarakViewModel(animationDataFileName: "EidAlAdhaAnimationData"))
                    }
                }
                .padding(.bottom, 80)
                
                Button {
                    isPresentedSettings.toggle()
                } label: {
                    EidButton(title: "Choix du son")
                }
                .fullScreenCover(isPresented: $isPresentedSettings) {
                    withAnimation {
                        SettingsView(viewModel: SettingsViewModel())
                    }
                }
            }
        }
    }
}

#Preview("Home screen (English)") {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "en"))
}

#Preview("Écran d'accueil (Français)") {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "fr"))
}
