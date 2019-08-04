//
//  RecordViewController.swift
//  AudioMemo
//
//  Created by Kilian Kellermann on 31.07.19.
//  Copyright © 2019 Kilian Kellermann. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {

    @IBOutlet weak var informationLabel: UILabel!
    
    var accessGranted = false
    var audioRecorder: AVAudioRecorder?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAudioRecorder()
    }
    
    func setupAudioRecorder() {
        if let audioRecorder = Utility.getAudioRecorder() {
            self.audioRecorder = audioRecorder
            self.audioRecorder!.delegate = self
            accessGranted = true
        } else {
            print("User denied access")
        }
    }

    func updateInformationLabel(recording: Bool) {
        if recording {
            informationLabel.text = "Recording..."
            informationLabel.textColor = UIColor.red
        } else {
            informationLabel.text = "Hold Button To Record"
            informationLabel.textColor = UIColor.white
        }
    }
    
    func startRecording() {
        print("Starting recording...")
        audioRecorder?.record()
    }
    
    func stopRecording() {
        print("Stopped recording")
        audioRecorder?.stop()
    }
    
    func showAccessAlert() {
        let alertViewController = UIAlertController(title: "No Access To Microphone", message: "Please allow AudioMemo access to the microphone in your settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func recordButtonTouchDown(_ sender: UIButton) {
        if accessGranted {
            startRecording()
            updateInformationLabel(recording: true)
        } else {
            showAccessAlert()
        }
    }
    
    @IBAction func recordButtonTouchUpInside(_ sender: UIButton) {
        if !accessGranted { return }
        stopRecording()
        updateInformationLabel(recording: false)
    }
    
    @IBAction func recordButtonTouchUpOutside(_ sender: UIButton) {
        if !accessGranted { return }
        stopRecording()
        updateInformationLabel(recording: false)
    }
}

extension RecordViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Everything OK")
            if let saveViewController = storyboard?.instantiateViewController(withIdentifier: "SaveViewController") as? SaveViewController {
                present(saveViewController, animated: true, completion: nil)
            }
        } else {
            print("Error during recording")
        }
    }
    
}
