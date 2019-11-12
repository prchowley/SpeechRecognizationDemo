//
//  SpeechRecognizer.swift
//  JustAsk
//
//  Created by Priyabrata Chowley on 12/11/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Speech

final class SpeechRecognizer: NSObject {
    
    static let shared = SpeechRecognizer()
    fileprivate var speechRequest: SFSpeechAudioBufferRecognitionRequest?
    var completion: (String?, Bool)->() = {_, _ in}
    
    func startRecognizer() {
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .authorized:
                #if targetEnvironment(simulator)
                let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "ttsMP3.com_VoiceText_2019-11-13_0_5_39", ofType: "mp3")!)
                let request = SFSpeechURLRecognitionRequest(url: fileURL)
                
                guard let speechRecognizer = SFSpeechRecognizer(locale: NSLocale.current) else { return }
                speechRecognizer.recognitionTask(with: request, resultHandler: { [unowned self] (result, error) in
                    guard let result = result else { return }
                    self.completion(result.bestTranscription.formattedString, result.isFinal)
                })
                #else
                guard let speechRecognizer = SFSpeechRecognizer(locale: NSLocale.current) else { return }
                self.speechRequest = SFSpeechAudioBufferRecognitionRequest()
                speechRecognizer.recognitionTask(with: self.speechRequest, resultHandler: { [unowned self] (result, error) in
                    guard let result = result else { return }
                    self.completion(result.bestTranscription.formattedString, result.isFinal)
                })
                #endif
            case .denied:
                fallthrough
            case .notDetermined:
                fallthrough
            case.restricted:
                print("User Autorization Issue.")
            @unknown default: print("unknown")
            }
        }
        
    }
    
    func endRecognizer() {
        guard let speechRequest = speechRequest else { return }
        speechRequest.endAudio()
        self.completion(nil, true)
    }
    
    func process(request buffer: CMSampleBuffer) {
        speechRequest?.appendAudioSampleBuffer(buffer)
    }
}
