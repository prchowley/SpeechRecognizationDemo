//
//  AudioManager.swift
//  JustAsk
//
//  Created by Priyabrata Chowley on 12/11/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import AVFoundation

final class AudioManager: NSObject {
    
    static let shared = AudioManager()
    fileprivate var capture: AVCaptureSession?
    var completion: (CMSampleBuffer)->() = {_ in}

    func setup() {
        capture = AVCaptureSession()
    }
    
    func startCapture() {
        
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
            print("No capture device.")
            return
        }
        
        guard let audioIn = try? AVCaptureDeviceInput(device: audioDevice) else {
            print("No input device.")
            return
        }
        
        guard let capture = capture else { return }
        guard capture.canAddInput(audioIn) else {
            print("unable to add input device")
            return
        }
        
        capture.addInput(audioIn)
        
        let audioOut = AVCaptureAudioDataOutput()
        audioOut.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        guard capture.canAddOutput(audioOut) else {
            print("Unable to add audio output")
            return
        }
        
        capture.addOutput(audioOut)
        audioOut.connection(with: AVMediaType.audio)
        capture.startRunning()
        
    }
    
    func endCapture() {
        guard let capture = capture else { return }
        if capture.isRunning {
            capture.stopRunning()
        }
    }
    
    func toggle() {
        guard let capture = capture else { return }
        if capture.isRunning {
            endCapture()
        } else {
            startCapture()
        }
    }

}

// MARK:- AVCaptureAudioDataOutputSampleBufferDelegate
extension AudioManager: AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        completion(sampleBuffer)
    }
}
