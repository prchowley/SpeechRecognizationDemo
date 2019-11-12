//
//  ViewController.swift
//  JustAsk
//
//  Created by Priyabrata Chowley on 12/11/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController {
        
    // MARK:- IBOutlet
    @IBOutlet weak var textViewConvertedText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        setupSpeech()
    }
    
    // MARK:- Setup
    func setupAudio() {
        AudioManager.shared.completion = { buffer in
            SpeechRecognizer.shared.process(request: buffer)
        }
    }
    func setupSpeech() {
        SpeechRecognizer.shared.completion = { [unowned self] predictedString, completed in
            if completed {
                AudioManager.shared.endCapture()
                print("Completed")
            } else {
                self.textViewConvertedText.text = predictedString
            }
        }
        SpeechRecognizer.shared.startRecognizer()
    }
    
    // MARK:- Actions
    @IBAction func actionRecord(_ sender: Any) {
        AudioManager.shared.toggle()
    }        
}
