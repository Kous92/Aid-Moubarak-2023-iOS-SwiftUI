//
//  SettingsView.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 24/03/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: SettingsViewModel
    @State private var number: Int = 0
    @State private var showingDownloadAlert = false
    
    var body: some View {
        ZStack {
            Image("EidBlueGradient")
                .resizable()
                .ignoresSafeArea(.all)
                .zIndex(0)
            
            GeometryReader { geometry in
                VStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.image(Image("GoldFoil")))
                            .font(.system(size: 40, weight: .semibold))
                            .glowBorder(color: .black, lineWidth: 3)
                    }
                }
                .position(x: geometry.safeAreaInsets.leading + 30, y: geometry.safeAreaInsets.top - setTopPositionWithDevice())
                .zIndex(1)
                
                VStack(alignment: .center) {
                    Text("eidTakbirSound")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundStyle(.image(Image("GoldFoil")))
                        .glowBorder(color: .black, lineWidth: 2)
                        .multilineTextAlignment(.center)
                }
                .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top - setTopPositionWithDevice())
            }
            
            VStack {
                List {
                    Picker("availableSounds", selection: $number) {
                        ForEach(viewModel.audioViewModels) { audio in
                            AudioRowCell(viewModel: audio) { setAction(with: $0, audio: audio) }
                            .tag(audio)
                        }
                        .onAppear {
                            print("Actualisation de la vue. Élément \(number) sélectionné.")
                            number = viewModel.isSelected
                        }
                    }
                    .pickerStyle(.inline)
                    .foregroundStyle(.image(Image("GoldFoil")))
                    .listRowBackground(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)))
                    .onChange(of: self.number) { newValue in
                        print("\(viewModel.audioViewModels[newValue].isDownloaded)")
                        Task {
                            await viewModel.saveChoice(with: viewModel.audioViewModels[newValue].audioFileName)
                        }
                    }
                    
                    Section() {
                        if viewModel.isDownloading {
                            Text(viewModel.downloadProgress)
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                                .foregroundStyle(.image(Image("GoldFoil")))
                                .glowBorder(color: .black, lineWidth: 2)
                                .multilineTextAlignment(.leading)
                                .listRowBackground(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)))
                        }
                    }
                    
                }
                .tint(.eidGold)
                .scrollContentBackground(.hidden)
                .overlay {
                    if viewModel.isFetching {
                        ProgressView("syncInProgress")
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .foregroundStyle(.image(Image("GoldFoil")))
                            .glowBorder(color: .black, lineWidth: 2)
                            .multilineTextAlignment(.center)
                            .progressViewStyle(CircularProgressViewStyle(tint: .eidGold))
                    }
                }
                .task {
                    await viewModel.fetchAudioData()
                }
                .padding(.top, 70)
            }
        }
    }
}

private extension SettingsView {
    private func setAction(with status: SettingRowStatus, audio: SoundViewModel) {
        switch status {
        case .play:
            print("Lecture de \(audio.soundName)")
            viewModel.playAudio(with: audio)
        case .pause:
            print("Pause de \(audio.soundName)")
            viewModel.pauseAudio()
        case .download:
            print("Lancement du téléchargement de \(audio.soundName)")
            Task {
                await viewModel.downloadAudio(with: audio)
            }
        }
    }
    
    private func setTopPositionWithDevice() -> CGFloat {
        switch UIDevice.current.interfaceType {
        case .dynamicIsland:
            return 40
        case .notch:
            return 30
        case .none:
            return 0
        }
    }
}

#Preview("Settings screen (English)") {
    SettingsView(viewModel: SettingsViewModel())
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "en"))
}

#Preview("Écran des paramètres (Français)") {
    SettingsView(viewModel: SettingsViewModel())
        .preferredColorScheme(.dark)
        .environment(\.locale, .init(identifier: "fr"))
}
