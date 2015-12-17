//
//  List.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/03.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import Foundation

//色々なInt型数値
struct ManyNum {
    static let ZERO: Int32 = 0
    static let SLEEP: Double = 3
    static let ROOP_AN_COUNT: Int32 = 10000
    static let WAKU_COUNT: Int32 = 13
    static let DOUBLE_MAX = 8
    static let TRIPLE_MAX = 5
    static let BASE_AD_HEIGHT: CGFloat = 50
    static let INCREMENT_AD_HEIGHT: CGFloat = 10
}

//画面サイズ
struct DisplaySize {
    static let FOUR_WIDTH: CGFloat = 320.0
    static let SIX_WIDTH: CGFloat = 375.0
    static let SIXPLUS_WIDTH: CGFloat = 414.0
    static let FIVE_HEIGHT: CGFloat = 960.0
    static let BOARD_WITH: CGFloat = 3.0
}

//フォントサイズ　※objective-Cのintと合わせるためにはInt32指定が必要(Intじゃダメ)
struct FontSize {
    static let FOUR_FONT: Int32 = 12
    static let FIVE_FONT: Int32 = 14
    static let SIX_FONT: Int32 = 16
    static let SIXPLUS_FONT: Int32 = 18
    static let SYSTEMSIZE: Int32 = 3
}

//タグ系
struct TAG {
    //choice画面
    static let SINGLE = 101
    static let MULTI = 102
    static let CONFIRM = 103
    static let RELOAD = 104
    //シングルdetail画面
    static let HOME_T = 101
    //static let DRAW_T = 102 ← 自動インクリメントで設定してるからコメントアウト
    //static let AWAY_T = 103 ← 自動インクリメントで設定してるからコメントアウト
    //static let UNIT_T = 104 ← 自動インクリメントで設定してるからコメントアウト
    static let HOME_P = 201
    //static let DRAW_P = 202 ← 自動インクリメントで設定してるからコメントアウト
    //static let AWAY_P = 203 ← 自動インクリメントで設定してるからコメントアウト
    //static let UNIT_P = 204 ← 自動インクリメントで設定してるからコメントアウト
    static let HOME_I = 301
    static let DRAW_I = 302
    static let AWAY_I = 303
    //マルチdetail画面
    static let DOB_T = 101
    static let DOB_P = 201
    //static let TRI_T = 102 ← 自動インクリメントで設定してるからコメントアウト
    //static let TRI_P = 202 ← 自動インクリメントで設定してるからコメントアウト
}

//TOTOとBODDS
struct ODDS {
    static let TOTO: Int32 = 0
    static let BOOK: Int32 = 1
}

//URL文字列の構造体
struct URL_STR {
    static let KAISAI_URL = "https://toto.rakuten.co.jp/toto/schedule/"
    static let TEAM_NAME_URL = "http://www.geocities.jp/totorandata/"
    static let COPY_TYPE = "public.utf8-plain-text"
}

//ファイル名文字列の構造体
struct FILE_NAME {
    static let LOGO = "TotoRanLogo.png"
    static let NOMAL_PNG = "nomal.png"
    static let SINCLE_PNG = "select_single.png"
    static let MULTI_PNG = "select_multi.png"
    static let BUTTON_PUSH = "kashan01"
    static let ERASE = "erase"
}

//選択画面の色々な値
struct CHOICE {
    static let SIXPLUS_HEIGHT: CGFloat = 700 //6+の画面高さを基準にする
    static let BUTTON_HEIGHT: CGFloat = 41.75 //ボタンの高さ
    static let BUTTON_INTERVAL: CGFloat = 5 //ボタンの間隔
    static let BASE_POINT: CGFloat = 10 //起点
    static let TAG_INCREMENT = 87 //tagの桁数増やし用
    static let TAG_BASE = 101 //tagの起点(101)
    static let CLEAR_WIDTH: CGFloat = 200 //選択解除ボタンwidth
    static let CLEAR_HEIGHT: CGFloat = 50 //選択解除ボタンheight
    static let TAGMAX = 314
    static let TAGMAXBASE = 100
    static let CLEARTAG = 9999
}

//メッセージ系文字列の構造体 ※AppDelegateはObjective-Cだからここでは書かないでAppDelegate.mに書いてある
struct MESSAGE_STR {
    static let DATA_GETING = "データ取得中..."
    static let DATA_GETED = "データ取得完了！"
    static let ROOP_AN_MESSAGE1 = "何かしらの異常が発生しました\nアプリを再起動してください\n※シーズンオフでスケジュールが未定な場合は起動できません"
    static let ROOP_AN_MESSAGE2 = "何かしらの異常が発生しました\nアプリを再起動してください"
    static let NOT_KAISAI_MESSAGE = "現在開催中のtotoはありません"
    static let ALL_SELECTED = "もうその組み合わせで買えば？"
    static let BASE_RERTURN = "前画面に戻ると現在の選択状態が破棄されますが、よろしいですか？"
    static let DT_CHECK = "以下の組合わせを超える事は出来ません\n※合計486口を超える事はできません\nダブル:0 トリプル:5\nダブル:1 トリプル:5\nダブル:2 トリプル:4\nダブル:3 トリプル:3\nダブル:4 トリプル:3\nダブル:5 トリプル:2\nダブル:6 トリプル:1\nダブル:7 トリプル:1\nダブル:8 トリプル:0"
    static let BUY_EXPIERD = "表示中の回は購入締切期限切れです\nアプリを再起動してください"
    static let OVER_THIRTEEN = "選択された合計数が「１３試合」を超えてます"
    static let ALL_IS_NONRANDOM = "オールならランダムの必要なくね？"
    static let THIRTEEN_FOR_ONE = "選択された合計数が「１３試合」の場合は１口までです"
    static let TWENTY_FOR_TWO = "選択された合計数が「１２試合」の場合は３口までです"
    static let ELEVEN_FOR_THREE = "選択された合計数が「１１試合」の場合は９口までです"
    static let TOTORAN = "\n\n#トトラン！"
    static let COPY_MESSAGE = "クリップボードに保存しました\n以下のような場所にご使用ください\n・twitter\n・FaceBook\n・某巨大掲示板"
    static let RETURN_MESSAGE = "前画面に戻ると現在のランダム抽出データが破棄されますが、よろしいですか？"
    static let NODATA_BOOK = "現在はまだbook(bODDS)の支持率情報がありません"
}

//NENDのキー
struct NENDKEY {
    //本番キー
    static let SET_ID = "c8bd9444e4a8061a10c867d45629ce252a17cd82"
    static let SPOT_ID = "443087"
    
    //テストキー
//    static let SET_ID = "a6eca9dd074372c898dd1df549301f277c53f2b9"
//    static let SPOT_ID = "3172"
}
