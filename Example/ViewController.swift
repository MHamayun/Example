//
//  ViewController.swift
//  Example
//
//  Created by Yuki Ono on 2020/07/29.
//  Copyright © 2020 Yuki Ono. All rights reserved.
//

import UIKit
import AVFoundation
import WaveSlider
import MobileCoreServices


class ViewController: UIViewController {

    @IBOutlet weak var waveSlider: WaveSlider!
    @IBOutlet weak var button: UIButton!
    
    var player: AVPlayer!
    var observation: NSKeyValueObservation?
    var playerItem: AVPlayerItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.isHidden = true
        
        let path = Bundle.main.path(forResource: "baya", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        observation = player.currentItem?.observe(\.status) { [weak self] _, _ in self?.startIfPossible() }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        let time = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            guard let duration = self?.player.currentItem?.duration.seconds else { return }
            self?.waveSlider.value = Float(time.seconds / duration)
        }
        
        waveSlider.set(url: url) { [weak self] in self?.startIfPossible() }
    }
    
    @IBAction func play(_ sender: Any) {
        button.isHidden = true
        player.seek(to: .zero)
        player.play()
        
    }
    
    
    @IBAction func moveForward(_ sender: UIButton) {
        
        
//        func openDocumentPicker() {
            // Use the UTI for .wav files
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeWaveformAudio as String, "org.xiph.flac"], in: .import)
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                present(documentPicker, animated: true, completion: nil)
//        }
        
//          guard let duration = playerItem?.duration else { return }
//          let currentTime = CMTimeGetSeconds(player?.currentTime() ?? CMTime.zero)
//        let newTime = currentTime + 3.0 // Move forward by 5 seconds
//          if newTime < CMTimeGetSeconds(duration) {
//              let time: CMTime = CMTimeMakeWithSeconds(newTime, preferredTimescale: 1)
//              player?.seek(to: time)
//          }
      }
    
    @IBAction func moveBackward(_ sender: UIButton) {
          let currentTime = CMTimeGetSeconds(player?.currentTime() ?? CMTime.zero)
        var newTime = currentTime - 3.0 // Move backward by 15 seconds
          if newTime < 0 {
              newTime = 0
          }
          let time: CMTime = CMTimeMakeWithSeconds(newTime, preferredTimescale: 1)
          player?.seek(to: time)
      }
    
    func startIfPossible() {
        guard player.currentItem?.status == .readyToPlay, waveSlider.status == .ready else { return }
        button.isHidden = false
    }
    
    @objc func playerDidFinishPlaying() {
        button.isHidden = false
    }
}



extension ViewController: UIDocumentPickerDelegate {

   
    
    // Implement the UIDocumentPickerDelegate methods
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let selectedFileURL = urls.first else {
//            return
//        }
//        // Check if the file is of .wav type
//        if selectedFileURL.pathExtension.lowercased() == "wav" {
//            // Handle the selected .wav file
//            print("Selected file is a .wav file: \(selectedFileURL)")
//        } else {
//            // Handle other file types or show an error
//            print("Selected file is not a .wav file")
//        }
//    }
    
    // Implement the UIDocumentPickerDelegate methods
      func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
          guard let selectedFileURL = urls.first else {
              return
          }
          // Check if the file is of .wav or .flac type
          let fileExtension = selectedFileURL.pathExtension.lowercased()
          if fileExtension == "wav" || fileExtension == "flac" {
              // Handle the selected .wav or .flac file
              print("Selected file is a \(fileExtension) file: \(selectedFileURL)")
          } else {
              // Handle other file types or show an error
              print("Selected file is not a .wav or .flac file")
          }
      }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled")
    }
}
