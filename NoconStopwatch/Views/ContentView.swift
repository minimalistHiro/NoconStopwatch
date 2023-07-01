//
//  ContentView.swift
//  NoconStopwatch
//
//  Created by 金子広樹 on 2023/07/01.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel.shared
    @Environment(\.scenePhase) private var scenePhase
    // 各種時間表示テキストを1桁ずつ分ける
    var minutesTensPlace: String {
        let number = String(format: "%02d", viewModel.minutes)
        return String(number.dropLast())
    }
    var minutesOnesPlace: String {
        let number = String(format: "%02d", viewModel.minutes)
        return String(number.dropFirst())
    }
    var secondTensPlace: String {
        let number = String(format: "%02d", viewModel.second)
        return String(number.dropLast())
    }
    var secondOnesPlace: String {
        let number = String(format: "%02d", viewModel.second)
        return String(number.dropFirst())
    }
    var milliSecondTensPlace: String {
        let number = String(format: "%02d", viewModel.milliSecond)
        return String(number.dropLast())
    }
    var milliSecondOnesPlace: String {
        let number = String(format: "%02d", viewModel.milliSecond)
        return String(number.dropFirst())
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    List {
                        ForEach(viewModel.rapText, id: \.self) { rap in
                            HStack(spacing: 10) {
                                Spacer()
                                Text(rap)
                                    .font(.system(size: 25))
                                    .frame(width: 180, alignment: .leading)
                                Spacer()
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.inset)
                    .environment(\.defaultMinListRowHeight, 40)
                    .frame(height: UIScreen.main.bounds.height / 2.5)
                    .onAppear {
                        viewModel.read()
                        // データを格納するモデルが作成されていない場合、新規作成する。
                        if viewModel.data.count == 0 {
                            viewModel.create()
                        }
                    }
                    .onChange(of: viewModel.rapText) { value in
                        // ラップが1つ以上ある場合飲み実行。新規ラップが作成される度にスクロール処理を加える。
                        if viewModel.rapText.count != 0 {
                            withAnimation { proxy.scrollTo(viewModel.rapText[viewModel.rapText.endIndex - 1], anchor: .bottom) }
                        }
                    }
                    .onChange(of: viewModel.mode) { mode in
                        // StopWatchModeの状態によって、バックグラウンド処理の実行の有無を決定。
                        switch mode {
                        case .zero:
                            UIApplication.shared.isIdleTimerDisabled = false
                        case .start:
                            UIApplication.shared.isIdleTimerDisabled = true
                        case.stop:
                            UIApplication.shared.isIdleTimerDisabled = false
                        }
                    }
                    HStack(spacing: 5) {
                        Text(minutesTensPlace)
                            .frame(width: timerLabelFrameWidth, alignment: .trailing)
                        Text(minutesOnesPlace)
                            .frame(width: timerLabelFrameWidth, alignment: .trailing)
                        Text(":")
                        Text(secondTensPlace)
                            .frame(width: timerLabelFrameWidth, alignment: .trailing)
                        Text(secondOnesPlace)
                            .frame(width: timerLabelFrameWidth, alignment: .trailing)
                        Text(".")
                        Text(milliSecondTensPlace)
                            .frame(width: timerLabelFrameWidth, alignment: .trailing)
                        Text(milliSecondOnesPlace)
                            .frame(width: timerLabelFrameWidth, alignment: .trailing)
                    }
                    .font(.system(size: 80))
                    Spacer()
                    HStack(spacing: 10) {
                        Spacer()
                        RapResetButton()
                        Spacer()
                        StartStopButton()
                        Spacer()
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 14 Pro")
                .previewDisplayName("iPhone 14 Pro")
            ContentView()
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
                .previewDisplayName("iPad Pro (12.9-inch) (6th generation)")
        }
    }
}

