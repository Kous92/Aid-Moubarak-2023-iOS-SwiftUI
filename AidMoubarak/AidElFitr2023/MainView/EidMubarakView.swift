//
//  EidMubarakView.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 19/04/2023.
//

import SwiftUI

struct EidMubarakView: View {
    @Environment(\.dismiss) var dismiss
    
    // ViewModel: MVVM
    @ObservedObject var viewModel: EidMubarakViewModel
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
                .position(x: geometry.safeAreaInsets.leading + 40, y: geometry.safeAreaInsets.top - 15)
                .zIndex(2)
                
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
                
            }.zIndex(3)
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
            Text(NSLocalizedString(message, comment: ""))
                .foregroundStyle(.image(Image("GoldFoil")))
        } else {
            Text(NSLocalizedString(message, comment: ""))
                .foregroundColor(Color("EidWhite"))
        }
    }
}

#Preview("Eid Al Fitr View (English)") {
    EidMubarakView(viewModel: EidMubarakViewModel(animationDataFileName: "EidAlFitrAnimationData"))
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "en"))
}

#Preview("Eid Al Adha View (English)") {
    EidMubarakView(viewModel: EidMubarakViewModel(animationDataFileName: "EidAlAdhaAnimationData"))
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "en"))
}

#Preview("Vue Aïd El Fitr (Français)") {
    EidMubarakView(viewModel: EidMubarakViewModel(animationDataFileName: "EidAlFitrAnimationData"))
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "fr"))
}

#Preview("Vue Aïd El Adha (Français)") {
    EidMubarakView(viewModel: EidMubarakViewModel(animationDataFileName: "EidAlAdhaAnimationData"))
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "fr"))
}
