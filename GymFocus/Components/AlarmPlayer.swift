//
//  AlarmPlayer.swift
//  GymFocus
//
//  Created by Giovanni De Francesco on 14/07/25.
//

import AVFoundation

class AlarmPlayer {
    private var player: AVAudioPlayer?

    func playSound(named name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found: \(name)")
        }
    }
    
    func stop(){
        player?.stop()
    }
}
