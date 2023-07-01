//
//  StartStopButton.swift
//  NoconStopwatch
//
//  Created by 金子広樹 on 2023/07/01.
//

import SwiftUI

struct StartStopButton: View {
    @ObservedObject var viewModel = ContentViewModel.shared
    
    var body: some View {
        if viewModel.mode == .start {
            Button {
                viewModel.stopTime()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundColor(able)
            }
        } else {
            Button {
                viewModel.startTime()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: "pause.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundColor(able)
            }
        }
    }
}
