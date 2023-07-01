//
//  Data.swift
//  NoconStopwatch
//
//  Created by 金子広樹 on 2023/07/01.
//

import SwiftUI
import RealmSwift

class Data: Object {
    @Persisted var time: Double
    @Persisted var rapText = RealmSwift.List<String>()
    @Persisted var rapCount: Int
}

extension Data {
    private static var config = Realm.Configuration(schemaVersion: 1)
    private static var realm = try! Realm(configuration: config)
    
    ///　Modelの全項目取得
    /// - Parameters: なし
    /// - Returns: なし
    static func findAll() -> Results<Data> {
        realm.objects(self)
    }
    
    ///　Modelに新規データを追加
    /// - Parameters:
    ///   - data: 新規Modelデータ
    /// - Returns: なし
    static func add(_ data: Data) {
        try! realm.write {
            realm.add(data)
        }
    }
    
    ///　Modelデータの最後の項目のデータを更新
    /// - Parameters:
    ///   - time: 時間計測用変数
    ///   - rapText: ラップテキスト
    ///   - rapCount: ラップのカウント数
    /// - Returns: なし
    static func update(time: Double, rapText: [String], rapCount: Int) {
        let result = findAll().last!
        try! realm.write {
            result.time = time
            // rapTextを一度全て削除してから、最新のrapTextを入れる。
            result.rapText.removeAll()
            result.rapText.append(objectsIn: rapText)
            
            result.rapCount = rapCount
        }
    }
    
    ///　Modelの全項目削除
    /// - Parameters: なし
    /// - Returns: なし
    static func delete() {
        try! realm.write {
            let table = realm.objects(self)
            realm.delete(table)
        }
    }
}


// 各種設定
let maxRapCount: Int = 100                              // ラップの最大カウント数
let maxElapsedTime: Double = 36000                      // 計測できる最大時間

// Viewのサイズ
let timerLabelFrameWidth: CGFloat = 45                  // 時間表示テキストのフレーム横幅
let buttonSize: CGFloat = 40                            // ボタンサイズ

// 固定色
let able: Color = Color("Able")                         // 文字・ボタン色
let disable: Color = Color("Disable")                   // 背景色
