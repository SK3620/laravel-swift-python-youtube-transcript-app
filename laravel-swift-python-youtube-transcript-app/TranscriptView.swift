//
//  TranscriptView.swift
//  laravel-swift-python-youtube-transcript-app
//
//  Created by 鈴木 健太 on 2024/08/06.
//

import SwiftUI

struct TranscriptView: View {
    @State private var videoId: String = ""
    @State private var transcript: [TranscriptItem] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Enter Video ID", text: $videoId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    fetchTranscript(videoId: videoId)
                }) {
                    Text("Fetch Transcript")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .padding()

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if transcript.isEmpty {
                    Spacer()
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(transcript) { item in
                                VStack(alignment: .leading) {
                                    Text(item.text)
                                    Text("Start: \(item.start)")
                                    Text("Duration: \(item.duration)")
                                }
                                .padding(.bottom)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Transcript Screen")
        }
    }

    func fetchTranscript(videoId: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/transcript/\(videoId)") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load transcript: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load transcript: Invalid response"
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([TranscriptItem].self, from: data)
                DispatchQueue.main.async {
                    self.transcript = decodedData
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load transcript: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct TranscriptItem: Identifiable, Codable {
    var id: UUID { UUID() }
    var text: String
    var start: Double
    var duration: Double
}

struct TranscriptScreen_Previews: PreviewProvider {
    static var previews: some View {
       TranscriptView()
    }
}
