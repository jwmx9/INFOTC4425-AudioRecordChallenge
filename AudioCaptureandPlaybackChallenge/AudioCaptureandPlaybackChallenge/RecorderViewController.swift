//
//  RecorderViewController.swift
//  AudioCaptureandPlaybackChallenge
//
//  Created by John Williams III on 7/11/19.
//  Copyright © 2019 John Williams III. All rights reserved.
//

import UIKit
import AVFoundation


class RecorderViewController: UIViewController, AVAudioPlayerDelegate , AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIBarButtonItem!
    
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    
    var fileName: String = "audioFile.m4a"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupRecorder()
        playButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func recordAction(_ sender: Any) {
        
        if (soundRecorder?.isRecording == false) {
            playButton.isEnabled = false
            recordButton.image = UIImage(named: "stop")
            soundRecorder?.record()
        } else {
            playButton.isEnabled = true
            recordButton.image = UIImage(named: "record")
            soundRecorder?.stop()
        }
        
        /*
        if recordButton.image?.accessibilityIdentifier == "Record" {
            soundRecorder.record()
            recordButton.image = UIImage(named: "stop")
            playButton.isEnabled = false
        } else {
            soundRecorder.stop()
            recordButton.image = UIImage(named: "record")
            playButton.isEnabled = false
        }
 */
    }
    
    @IBAction func playAction(_ sender: Any) {
        
        guard let soundRecorder = soundRecorder, soundRecorder.isRecording == false else {
            print("Unable to play audio")
            return
        }
        
        if let soundPlayer = soundPlayer {
            if (soundPlayer.isPlaying) {
                soundPlayer.stop()
                playButton.image = UIImage(named: "play")
                recordButton.isEnabled = false
                return
            }
        }
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
            recordButton.isEnabled = false
            playButton.image = UIImage(named: "pause")

        
        /*
        if playButton.image?.accessibilityIdentifier == "Play" {
            playButton.image = UIImage(named: "stop")
            recordButton.isEnabled = false
            setupPlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            playButton.image = UIImage(named: "play")
            recordButton.isEnabled = false
        }
 */
    }
    
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecorder() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100.2] as [String : Any]
        
        do {
            soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting )
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    func setupPlayer() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        } catch {
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playButton.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        playButton.image = UIImage(named: "play")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

