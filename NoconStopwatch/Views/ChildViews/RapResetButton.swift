//
//  RapResetButton.swift
//  NoconStopwatch
//
//  Created by 金子広樹 on 2023/07/01.
//

import SwiftUI

struct RapResetButton: View {
    @ObservedObject var viewModel = ContentViewModel.shared
    
    var body: some View {
        if viewModel.mode == .start {
            if viewModel.rapCount < maxRapCount {
                Button {
                    viewModel.addRapTime()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Image(systemName: "flag.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: buttonSize, height: buttonSize)
                        .foregroundColor(able)
                }
            } else {
                // 空白のボタン
                Button { } label: {
                    Image(systemName: "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: buttonSize, height: buttonSize)
                        .foregroundColor(able)
                }
            }
        } else if viewModel.mode == .stop {
            Button {
                viewModel.reset()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .frame(width: buttonSize, height: buttonSize)
                    .foregroundColor(able)
            }
        } else if viewModel.mode == .zero {
            if viewModel.elapsedTime > 0 {
                Button {
                    viewModel.reset()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .scaledToFit()
                        .bold()
                        .frame(width: buttonSize, height: buttonSize)
                        .foregroundColor(able)
                }
            } else {
                // 空白のボタン
                Button { } label: {
                    Image(systemName: "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: buttonSize, height: buttonSize)
                        .foregroundColor(able)
                }
            }
        }
    }
}
