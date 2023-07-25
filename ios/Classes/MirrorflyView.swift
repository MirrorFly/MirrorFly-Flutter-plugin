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
            print("\(Constants.tag) argument--> \(argument)")
            
            let userJid = argument["userJid"] as? String ?? ""
            
            let contact = ChatManager.profileDetaisFor(jid: userJid)
            
            let userName = FlyUtils.getUserName(jid: (contact?.jid)!, name: contact!.name, nickName: contact!.nickName, contactType: contact!.contactType)
            
            print("\(Constants.tag) userName --> \(userName)")
            videoTrack = CallManager.getRemoteVideoTrack(jid: userJid)
            let calluserslist = CallManager.getAllCallUsersList()
            print("\(Constants.tag) calluserslist \(calluserslist)")
            print("\(Constants.tag) calluserslist count \(calluserslist.count)")
            print("\(Constants.tag) videoTrack--> \(String(describing: videoTrack))")
            print("\(Constants.tag) Video rendered/Audio Call")
            
            if(videoTrack == nil || CallManager.getCallType() == .Audio){
                
                
                if textView == nil {
//                    textView = UITextView(frame: .zero)
//                    textView?.translatesAutoresizingMaskIntoConstraints = false
//                    textView?.text = userName
//                    textView?.isEditable = false
//                    textView?.isScrollEnabled = false
//                    textView?.textAlignment = .center
//                    textView?.font = UIFont.systemFont(ofSize: 20.0)
//                    textView?.textColor = .black
                    
                    let containerView = UIView(frame: .zero)
                       containerView.translatesAutoresizingMaskIntoConstraints = false
                    
                    if let backgroundColorHex = argument["backgroundColor"] as? String {
                        if backgroundColorHex != ""{
                            backgroundColor = hexStringToUIColor(hex: backgroundColorHex)
                            containerView.backgroundColor = backgroundColor
                            _baseView.backgroundColor = backgroundColor
                        }
                    }
                    // Circular text view background
                       let circleView = UIView(frame: .zero)
                       circleView.translatesAutoresizingMaskIntoConstraints = false
                       circleView.backgroundColor = randomColor() // Generate a random background color
                       circleView.layer.cornerRadius = 30.0
                    
                    textView = UITextView(frame: .zero)
                        textView?.translatesAutoresizingMaskIntoConstraints = false
                    print("\(Constants.tag) userName \(userName)")
                    textView?.text = getAbbreviation(from: userName).uppercased()
                        textView?.isEditable = false
                        textView?.isScrollEnabled = false
                        textView?.textAlignment = .center
                        textView?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
                        textView?.textColor = .white
                    textView?.backgroundColor = .clear // Generate a random background color
                        
//                    let padding: CGFloat = 10.0
//                    textView!.layer.cornerRadius = 55.0
                       
                        // Make the text view circular
//                    textView?.layer.cornerRadius = (textView?.bounds.width)! / 2
                        textView?.clipsToBounds = true
                    containerView.addSubview(circleView)
                    containerView.addSubview(textView!)
                    
                    _baseView.addSubview(containerView)
                    
                    
                    NSLayoutConstraint.activate([
                        circleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        circleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                        circleView.widthAnchor.constraint(equalToConstant: 60),
                        circleView.heightAnchor.constraint(equalToConstant: 60)
                    ])
                    NSLayoutConstraint.activate([
                        textView!.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        textView!.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
                    ])
                    NSLayoutConstraint.activate([
                        containerView.centerXAnchor.constraint(equalTo: _baseView.centerXAnchor),
                        containerView.centerYAnchor.constraint(equalTo: _baseView.centerYAnchor),
                        containerView.topAnchor.constraint(equalTo: _baseView.topAnchor),
                        containerView.bottomAnchor.constraint(equalTo: _baseView.bottomAnchor)
                    ])
                    
                    videoView?.removeFromSuperview()
                }
                
            }else{
                
                removeTextView()
                
                print("\(Constants.tag) Video rendered")
                if videoView == nil {
                    videoView = createVideoView()
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
                textView?.removeFromSuperview()
            }
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
    
    func updateVideoTrack(userJid: String) {
        print("\(Constants.tag) Update Video Track viewId\(viewId) userJid\(userJid)")
        
        
        videoTrack?.remove(videoView as! RTCVideoRenderer)
        videoTrack = CallManager.getRemoteVideoTrack(jid: userJid)
        
        if let track = videoTrack {
            if videoView == nil{
                videoView = createVideoView()
                
                _baseView.addSubview(videoView!)
            }
            
            
            videoView?.translatesAutoresizingMaskIntoConstraints = false
            videoView?.layer.masksToBounds = true
            videoView?.contentMode = .center
            videoView?.backgroundColor = .black
            
            NSLayoutConstraint.activate([
                videoView!.leadingAnchor.constraint(equalTo: _baseView.leadingAnchor),
                videoView!.trailingAnchor.constraint(equalTo: _baseView.trailingAnchor),
                videoView!.topAnchor.constraint(equalTo: _baseView.topAnchor),
                videoView!.bottomAnchor.constraint(equalTo: _baseView.bottomAnchor)
            ])
            if track == nil {
                textView?.text = "No video track available"
                _baseView.addSubview(textView!)
            } else {
                track.add(videoView as! RTCVideoRenderer)
                textView?.removeFromSuperview()
            }
        }
    }
    
    private func createVideoView() -> UIView {
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
