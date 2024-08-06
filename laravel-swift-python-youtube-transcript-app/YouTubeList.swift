//
//  YouTubeList.swift
//  laravel-swift-python-youtube-transcript-app
//
//  Created by 鈴木 健太 on 2024/08/06.
//

import SwiftUI
import YouTubePlayerKit

struct YouTubeList: View {
    @StateObject
      var youTubePlayer: YouTubePlayer = "https://youtube.com/watch?v=psL_5RIBqnY"
      
      var body: some View {
          VStack {
              // YouTubePlayerView
              YouTubePlayerView(self.youTubePlayer) { state in
                  switch state {
                  case .idle:
                      ProgressView()
                  case .ready:
                      EmptyView()
                  case .error(let error):
                      Text(verbatim: "YouTube player couldn't be loaded")
                  }
              }
              .frame(height: 300) // YouTubeプレイヤーの高さを設定
              
              HStack(spacing: 20) {
                  Button(action: {
                      // 3秒巻き戻し
                      Task {
                          let currentTime = try await youTubePlayer.getCurrentTime()
                          let mesurement = Measurement(value: 3.0, unit: UnitDuration.seconds)
                          try await youTubePlayer.seek(to: currentTime - mesurement)
                      }
                  }) {
                      Text("3秒巻き戻し")
                  }
                  
                  Button(action: {
                      // 3秒早送り
                      Task {
                          let currentTime = try await youTubePlayer.getCurrentTime()
                          let mesurement = Measurement(value: 3.0, unit: UnitDuration.seconds)
                          try await youTubePlayer.seek(to: currentTime + mesurement, allowSeekAhead: true)
                      }
                  }) {
                      Text("3秒早送り")
                  }
                  
                  Button(action: {
                      // 現在の動画の時間の取得
                      Task {
                          let currentTime = try await youTubePlayer.getCurrentTime()
                          print("現在の動画の時間: \(currentTime) 秒")
                      }
                  }) {
                      Text("現在の時間取得")
                  }
                  
                  Button(action: {
                      // 動画時間の10秒の位置から視聴
                      let mesurement = Measurement(value: 10.0, unit: UnitDuration.seconds)
                      youTubePlayer.seek(to: mesurement, allowSeekAhead: true)
                  }) {
                      Text("10秒から視聴")
                  }
              }
              .padding()
          }
      }
}

#Preview {
    YouTubeList()
}
