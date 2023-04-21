//
//  EidMubarakView.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 19/04/2023.
//

import SwiftUI

struct EidMubarakView: View {
    // ViewModel: MVVM
    @ObservedObject var viewModel = EidMubarakViewModel()
    @State private var mediaViewModel = MediaViewModel(message: "", imageName: "", colorText: "", shadowColor: "", goldEffect: false)
    
    // Propriétés texte central
    @State private var imageName = ""
    @State private var message = ""
    @State private var goldEffect = false
    @State private var shadowColorName = ""
    @State private var textColorName = ""
    
    @State private var showMainText = false
    @State private var showImage = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var seconds = 0
    
    var body: some View {
        ZStack {
            if showImage {
                Image(imageName)
                    .resizable()
                    .ignoresSafeArea(.all)
                    .transition(.opacity)
                    .opacity(1)
                    .zIndex(1)
            }
            
            GeometryReader { geometry in
                if showMainText {
                    VStack(spacing: 10) {
                        messageText()
                            .font(.system(size: Constants.messageFontSize))
                            .fontWeight(.medium)
                            .glowBorder(color: .black, lineWidth: 2)
                            .shadow(color: Color(shadowColorName), radius: 10)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                
            }.zIndex(2)
        }
        .onAppear {
            viewModel.initData()
            updateView()
            viewModel.playAudioMedia()
            
            withAnimation(Animation.easeInOut(duration: 2)) {
                showImage.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(Animation.easeInOut(duration: 2)) {
                    showMainText.toggle()
                }
            }
        }
        .onReceive(timer) { _ in
            self.seconds += 1
            if seconds % 8 == 0 {
                switchImageAnimation()
            }
        }.background(.black)
    }
    
    private func switchImageAnimation() {
        guard viewModel.getActualMediaIndex() < viewModel.getMediaCount() else {
            timer.upstream.connect().cancel()
            return
        }
        
        withAnimation(Animation.easeInOut(duration: 1)) {
            message = ""
            showImage.toggle()
            showMainText.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.easeInOut(duration: 2)) {
                updateView()
                showImage.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(Animation.easeInOut(duration: 2)) {
                showMainText.toggle()
            }
        }
    }
    
    private func updateView() {
        mediaViewModel = viewModel.getMediaViewModel()
        message = mediaViewModel.message
        imageName = mediaViewModel.imageName
        shadowColorName = mediaViewModel.shadowColor
        textColorName = mediaViewModel.colorText
        goldEffect = mediaViewModel.goldEffect
    }
    
    @ViewBuilder
    private func messageText() -> some View {
        if goldEffect {
            Text(message)
                .foregroundStyle(.image(Image("GoldFoil")))
        } else {
            Text(message)
                .foregroundColor(Color("White"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EidMubarakView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Eid View (iPhone)")
                .previewDevice("iPhone 14 Pro")
            
            EidMubarakView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Eid View (iPhone SE)")
                .previewDevice("iPhone SE (3rd generation)")
            
            EidMubarakView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Eid View (iPad)")
                .previewDevice("iPad Pro (11-inch) (4th generation)")
        }
    }
}