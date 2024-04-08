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
    @State private var showingErrorAlert = false
    
    var body: some View {
        ZStack {
            Image("EidBlueGradient")
                .resizable()
                .ignoresSafeArea(.all)
                .zIndex(0)
            
            GeometryReader { geometry in
                HStack(alignment: .center) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.image(Image("GoldFoil")))
                            .font(.system(size: 40, weight: .semibold))
                            .glowBorder(color: .black, lineWidth: 3)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    Text("eidTakbirSound")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .foregroundStyle(.image(Image("GoldFoil")))
                        .glowBorder(color: .black, lineWidth: 2)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    Button {
                        Task {
                            do {
                               try await viewModel.fetchAudioData(forceRefresh: true)
                            } catch {
                                showingErrorAlert.toggle()
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(.image(Image("GoldFoil")))
                            .font(.system(size: 30, weight: .semibold))
                            .glowBorder(color: .black, lineWidth: 3)
                    }
                    .padding(.trailing, 20)
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
                        .alert(isPresented: $showingDownloadAlert, content: sendAlert)
                    }
                    .pickerStyle(.inline)
                    .foregroundStyle(.image(Image("GoldFoil")))
                    .listRowBackground(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)))
                    .onChange(of: self.number) { newValue in
                        Task {
                            guard viewModel.audioViewModels[newValue].isDownloaded else {
                                print("Le son n'est pas téléchargé.")
                                showingDownloadAlert.toggle()
                                number = 0
                                await viewModel.saveChoice(with: viewModel.audioViewModels[0].audioFileName)
                                return
                            }
                            
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
                    do {
                       try await viewModel.fetchAudioData()
                    } catch {
                        showingErrorAlert.toggle()
                    }
                }
                .alert(isPresented: $showingErrorAlert, content: {
                    sendNetworkErrorAlert()
                })
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
    
    private func sendAlert() -> Alert {
        Alert(title: Text("error"), message: Text("fileNotDownloaded"))
    }
    
    private func sendNetworkErrorAlert() -> Alert {
        Alert(title: Text("error"), message: Text("viewModel.errorMessage"))
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
