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
    private let viewId: Int64
    
    private var textView: UITextView?
    private var videoView: UIView?
    private var audioView: UIView?
    private var videoTrack: RTCVideoTrack?
    private var backgroundColor: UIColor?
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        print("\(Constants.tag) viewId \(viewId)")
        self.viewId = viewId
        super.init()
        
        if let argument = args as? [String: Any]{
            NSLog("\(Constants.tag) argument--> \(argument)")
            
            let userJid = argument["userJid"] as? String ?? ""
            
            let contact = ChatManager.profileDetaisFor(jid: userJid)
            
            let userName = FlyUtils.getUserName(jid: (contact?.jid)!, name: contact!.name, nickName: contact!.nickName, contactType: contact!.contactType)
            
            NSLog("\(Constants.tag) userName --> \(userName)")
            videoTrack = CallManager.getRemoteVideoTrack(jid: userJid)
            let calluserslist = CallManager.getAllCallUsersList()
            NSLog("\(Constants.tag) calluserslist \(calluserslist)")
            NSLog("\(Constants.tag) calluserslist count \(calluserslist.count)")
            NSLog("\(Constants.tag) \(userJid) videoTrack--> \(String(describing: videoTrack))")
            NSLog("\(Constants.tag) Video rendered/Audio Call")
            
            createAudioView(argument: argument, userName: userName)
            
            createVideoView(argument: argument)
            
            if(videoTrack == nil || CallManager.getCallType() == .Audio){
                
//                showAudioView(argument: argument, userName: userName)
                videoView?.removeFromSuperview()
                
            }else{
                
                audioView?.removeFromSuperview()
                
            }
        }
        
    }
    
    private func createVideoView(argument : [String: Any]){
        print("\(Constants.tag) Video rendered")
        if videoView == nil {
            videoView = getVideoView()
            _baseView.addSubview(videoView!)
            
        }
        
        videoView?.translatesAutoresizingMaskIntoConstraints = false
        
        videoView?.layer.masksToBounds = true
        videoView?.contentMode = .center
        videoView?.backgroundColor = .black
        if argument["setMirror"] is Bool{
            videoView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        videoTrack?.add(videoView as! RTCVideoRenderer)
        
        NSLayoutConstraint.activate([
            videoView!.leadingAnchor.constraint(equalTo: _baseView.leadingAnchor),
            videoView!.trailingAnchor.constraint(equalTo: _baseView.trailingAnchor),
            videoView!.topAnchor.constraint(equalTo: _baseView.topAnchor),
            videoView!.bottomAnchor.constraint(equalTo: _baseView.bottomAnchor)
        ])
    }
    
    private func createAudioView(argument : [String: Any], userName : String){
        
        let alignProfilePictureCenter = argument["alignProfilePictureCenter"] as? Bool ?? true
        let profileSize = argument["profileSize"] as? Int ?? 60
        let hideProfileView = argument["hideProfileView"] as? Bool ?? false
        
        if textView == nil {
            
            audioView = UIView(frame: .zero)
            audioView?.translatesAutoresizingMaskIntoConstraints = false
            
            if let backgroundColorHex = argument["backgroundColor"] as? String {
                if backgroundColorHex != ""{
                    backgroundColor = hexStringToUIColor(hex: backgroundColorHex)
                    audioView?.backgroundColor = backgroundColor
                    _baseView.backgroundColor = backgroundColor
                }
            }
            // Circular text view background
            let circleView = UIView(frame: .zero)
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.backgroundColor = randomColor() // Generate a random background color
            circleView.layer.cornerRadius = CGFloat(profileSize / 2)
            
            textView = UITextView(frame: .zero)
            textView?.translatesAutoresizingMaskIntoConstraints = false
            NSLog("\(Constants.tag) userName \(userName)")
            textView?.text = getAbbreviation(from: userName).uppercased()
            textView?.isEditable = false
            textView?.isScrollEnabled = false
            textView?.textAlignment = .center
            textView?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
            textView?.textColor = .white
            textView?.backgroundColor = .clear
            
            textView?.clipsToBounds = true
            if (!hideProfileView){
                audioView?.addSubview(circleView)
                audioView?.addSubview(textView!)
                
                NSLayoutConstraint.activate([
                    circleView.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor),
                    alignProfilePictureCenter ? circleView.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor) : circleView.topAnchor.constraint(equalTo: audioView!.topAnchor, constant: 80),
                    circleView.widthAnchor.constraint(equalToConstant: CGFloat(profileSize)),
                    circleView.heightAnchor.constraint(equalToConstant: CGFloat(profileSize))
                ])
                NSLayoutConstraint.activate([
                    textView!.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor),
                    alignProfilePictureCenter ? textView!.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor) :
                        textView!.centerYAnchor.constraint(equalTo: audioView!.topAnchor, constant: 130)
                ])
            }
            
            _baseView.addSubview(audioView!)
            
            
            
            NSLayoutConstraint.activate([
                audioView!.centerXAnchor.constraint(equalTo: _baseView.centerXAnchor),
                audioView!.centerYAnchor.constraint(equalTo: _baseView.centerYAnchor),
                audioView!.topAnchor.constraint(equalTo: _baseView.topAnchor),
                audioView!.bottomAnchor.constraint(equalTo: _baseView.bottomAnchor)
            ])
            
            videoView?.removeFromSuperview()
        }
    }
    
    private func randomColor() -> UIColor {
        // Generate random RGB values for the background color
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func view() -> UIView {
        return _baseView
    }
    
    func updateVideoTrack(userJid: String, updateType: MuteEvent) {
        print("\(Constants.tag) Update Video Track viewId\(viewId) userJid\(userJid)")
        
        if(updateType == .ACTION_REMOTE_VIDEO_UN_MUTE){
            videoTrack?.remove(videoView as! RTCVideoRenderer)
            videoTrack = CallManager.getRemoteVideoTrack(jid: userJid)
            
            if let track = videoTrack {
                print("\(Constants.tag) get remote track \(track)")
                if videoView == nil{
                    videoView = getVideoView()
                }
                
                track.add(videoView as! RTCVideoRenderer)
                _baseView.addSubview(videoView!)
                
                
                NSLayoutConstraint.activate([
                    videoView!.leadingAnchor.constraint(equalTo: _baseView.leadingAnchor),
                    videoView!.trailingAnchor.constraint(equalTo: _baseView.trailingAnchor),
                    videoView!.topAnchor.constraint(equalTo: _baseView.topAnchor),
                    videoView!.bottomAnchor.constraint(equalTo: _baseView.bottomAnchor)
                ])
                audioView?.removeFromSuperview()
            }else{
                print("\(Constants.tag) video track is null")
                
            }
        }else{
            print("\(Constants.tag) show Audio View")
            videoView?.removeFromSuperview()
            _baseView.addSubview(audioView!)
            
            NSLayoutConstraint.activate([
                audioView!.centerXAnchor.constraint(equalTo: _baseView.centerXAnchor),
                audioView!.centerYAnchor.constraint(equalTo: _baseView.centerYAnchor),
                audioView!.topAnchor.constraint(equalTo: _baseView.topAnchor),
                audioView!.bottomAnchor.constraint(equalTo: _baseView.bottomAnchor)
            ])
        }
    }
    
    private func getVideoView() -> UIView {
        #if arch(arm64)
            return RTCMTLVideoView(frame: .zero)
        #else
            return RTCEAGLVideoView(frame: .zero)
        #endif
    }
    private func removeTextView() {
        textView?.removeFromSuperview()
    }
    
    private func removeVideoView() {
        videoTrack?.remove(videoView as! RTCVideoRenderer)
        videoView?.removeFromSuperview()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getAbbreviation(from string: String) -> String {
        let words = string.components(separatedBy: .whitespaces)
        
        if words.count >= 2 {
            let firstLetter = String(words[0].prefix(1))
            let secondLetter = String(words[1].prefix(1))
            
            return firstLetter + secondLetter
        } else if words.count == 1 {
            return String(string.prefix(2))
        }
        
        return ""
    }
    
    
}
