//
//  AudioRowCell.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 30/03/2024.
//

import SwiftUI

struct AudioRowCell: View {
    var viewModel: SoundViewModel
    var handler: (SettingRowStatus) -> Void
    @State private var isPlaying = false
    
    var body: some View {
        HStack {
            Text(viewModel.soundName)
                .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                .foregroundStyle(.image(Image("GoldFoil")))
                .font(.system(size: 13, weight: .medium))
            
            if viewModel.isDownloaded {
                Button(action: {
                    isPlaying ? pauseAction() : playAction()
                    isPlaying.toggle()
                }, label: {
                    Image(systemName: "\("playpause.fill")")
                        .foregroundStyle(.image(Image("GoldFoil")))
                })
            } else {
                Button(action: downloadAction, label: {
                    Image(systemName: "icloud.and.arrow.down")
                        .foregroundStyle(.image(Image("GoldFoil")))
                })
            }
        }
        .background(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)))
    }
    
    func downloadAction() {
        handler(.download)
    }
    
    func playAction() {
        handler(.play)
    }
    
    func pauseAction() {
        handler(.pause)
    }
}

#Preview {
    AudioRowCell(viewModel: SoundViewModel(id: 1, soundName: "Al Afasy TV", audioFileURL: "http://kous92.free.fr/AudioData/EidTakbir/AlAfasyTV.mp3", audioFileName: "AlAfasyTV.mp3", fileSize: 3), handler: { _ in })
    .previewLayout(PreviewLayout.sizeThatFits)
    .preferredColorScheme(.dark)
}
