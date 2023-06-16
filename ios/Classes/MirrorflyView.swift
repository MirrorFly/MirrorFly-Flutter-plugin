//
//  MirrorflyView.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 13/06/23.
//

import Foundation
import Flutter
import MirrorFlySDK

class MirrorflyView: NSObject, FlutterPlatformView {
    
    private var _baseView = UIView()
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        
        super.init()
        
        if let argument = args as? [String: Any]{
            print("argument--> \(argument)")
            
            #if arch(arm64)
                var localView = RTCMTLVideoView(frame: .zero)
            #else
                var localView = RTCEAGLVideoView(frame: .zero)
            #endif
            
            let userJid = argument["userJid"] as? String ?? ""
            let videoTrack = CallManager.getRemoteVideoTrack(jid: userJid)
            print("local videoTrack--> \(videoTrack)")
            localView.translatesAutoresizingMaskIntoConstraints = false
            
            localView.layer.masksToBounds = true
            localView.backgroundColor = .black
            if argument["setMirror"] is Bool{
                localView.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            
            videoTrack?.add(localView)
            _baseView.addSubview(localView)
            
            NSLayoutConstraint.activate([
                localView.leadingAnchor.constraint(equalTo: self.view().leadingAnchor, constant: 0),
                localView.trailingAnchor.constraint(equalTo: self.view().trailingAnchor, constant: 0),
                localView.topAnchor.constraint(equalTo: self.view().topAnchor, constant: 0),
                localView.bottomAnchor.constraint(equalTo: self.view().bottomAnchor, constant: 0)
            ])
            
        }
        
    }
    
    func view() -> UIView {
        return _baseView
    }
    
}
