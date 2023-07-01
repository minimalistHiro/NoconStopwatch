//
//  ContentViewModel.swift
//  NoconStopwatch
//
//  Created by 金子広樹 on 2023/07/01.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    static var shared: ContentViewModel = ContentViewModel()
    
    @Published var data: [Data] = Array(Data.findAll())
    @Published var mode: StopWatchMode = .zero
    var timer = Timer()                                                     // タイマー
    @Published var elapsedTime: Double = 0.0                                // 時間計測用変数
    var minutes: Int { return Int(elapsedTime / 60) }                       // 分
    var second: Int { return Int(elapsedTime) % 60 }                        // 秒
    var milliSecond: Int { return Int(elapsedTime * 100) % 100 }            // 小数点以下
    @Published var rapText: [String] = []                                   // ラップテキスト
    @Published var rapCount: Int = 0                                        // ラップのカウント数
    var backgroundTaskId = UIBackgroundTaskIdentifier.init(rawValue: 0)     // バックグラウンド用トークン
    
    enum StopWatchMode {
        case zero
        case start
        case stop
    }
    
    ///　タイマーを開始
    /// - Parameters: なし
    /// - Returns: なし
    func startTime() {
        mode = .start
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] _ in
            // タイマーをメインスレッドと別スレッドで実行。
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            
            // バックグラウンド処理開始
            backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            // 時間計測用変数が計測できる最大時間を超えた場合、タイマーを一時停止する。
            if elapsedTime > maxElapsedTime {
                stopTime()
                return
            }
            update()
            self.elapsedTime += 0.01
        }
    }
    
    ///　タイマーを停止
    /// - Parameters: なし
    /// - Returns: なし
    func stopTime() {
        timer.invalidate()
        mode = .stop
        // バックグラウンド処理終了
        UIApplication.shared.endBackgroundTask(backgroundTaskId)
    }
    
    ///　タイマーをリセット
    /// - Parameters: なし
    /// - Returns: なし
    func reset() {
        timer.invalidate()
        elapsedTime = 0.0
        rapText.removeAll()
        rapCount = 0
        // Realm操作
        Data.delete()
        create()
        
        mode = .zero
    }
    
    ///　ラップタイムを追加
    /// - Parameters: なし
    /// - Returns: なし
    func addRapTime() {
        rapCount += 1
        
        // ラップのカウント数が最大カウント数を超えないように制御。
        if rapCount > maxRapCount {
            return
        }
        var rap: String {
            return String(format: "%02d:%02d.%02d", minutes, second, milliSecond)
        }
        rapText.append("\(rapCount).  \(rap)")
    }
    
// MARK: - RealmCRUD
    
    ///　新規データの作成
    /// - Parameters: なし
    /// - Returns: なし
    func create() {
        let model = Data()
        Data.add(model)
    }
    
    ///　データの取得
    /// - Parameters: なし
    /// - Returns: なし
    func read() {
        // modelからviewModelに各データを追加
        if let result = data.last {
            elapsedTime = result.time
            rapText.append(contentsOf: Array(result.rapText))
            rapCount = result.rapCount
        }
    }
    
    ///　データを更新
    /// - Parameters: なし
    /// - Returns: なし
    func update() {
        // viewModelからmodelにテキストデータを更新
        Data.update(time: elapsedTime, rapText: rapText, rapCount: rapCount)
    }
}
