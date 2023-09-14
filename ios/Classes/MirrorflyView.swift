//
//  MirrorflyView.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 13/06/23.
//

import Foundation
import Flutter
import MirrorFlySDK
import SDWebImage

class MirrorflyView: NSObject, FlutterPlatformView {
    
    private var _baseView = UIView()
    private let viewId: Int64
    
    private var textView: UITextView?
    private var userProfileView: UIImageView?
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
            
            print("===contact \(contact?.image)")
            
            let userName = FlyUtils.getUserName(jid: (contact?.jid)!, name: contact!.name, nickName: contact!.nickName, contactType: contact!.contactType)
            
            
            NSLog("\(Constants.tag) userName --> \(userName)")
            videoTrack = CallManager.getRemoteVideoTrack(jid: userJid)
            let calluserslist = CallManager.getAllCallUsersList()
            NSLog("\(Constants.tag) calluserslist \(calluserslist)")
            NSLog("\(Constants.tag) calluserslist count \(calluserslist.count)")
            NSLog("\(Constants.tag) \(userJid) videoTrack--> \(String(describing: videoTrack))")
            NSLog("\(Constants.tag) Video rendered/Audio Call")
            
            createAudioView(argument: argument, userName: userName, contact: contact)
            
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
    
    private func createAudioView(argument : [String: Any], userName : String, contact: ProfileDetails?){
        
        let alignProfilePictureCenter = argument["alignProfilePictureCenter"] as? Bool ?? true
        let profileSize = argument["profileSize"] as? Int ?? 60
        let hideProfileView = argument["hideProfileView"] as? Bool ?? false
        
        if textView == nil || userProfileView == nil {
            
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
            
            
            if (!hideProfileView){
                //
                //
                //Need to remove the below lone when working on profiel view
                contact?.image = ""
                //
                //
                //
                if contact?.image == nil || (contact!.image.isEmpty) {
                    audioView?.addSubview(circleView)
                    print("===contact image is empty")
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
                    audioView?.addSubview(textView!)
                }else{
                    print("===contact image is not empty \(profileSize)")
                    userProfileView = UIImageView(frame: .zero)
//                    userProfileView?.translatesAutoresizingMaskIntoConstraints = false
//                    userProfileView?.frame.size = CGSize(width: profileSize, height: profileSize)
                    userProfileView?.layer.cornerRadius = CGFloat(profileSize / 2)
                    userProfileView?.loadFlyImage(imageURL: contact?.image ?? "", name: FlyUtils.getUserName(jid: (contact?.jid)!, name: contact!.name, nickName: contact!.nickName, contactType: contact!.contactType), jid: contact?.jid ?? "")
                    userProfileView?.clipsToBounds = true
                    audioView?.addSubview(userProfileView!)
                }
                
            
                var constraints: [NSLayoutConstraint] = []
                
                if(textView == nil){
                    constraints.append(userProfileView!.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor))
                    alignProfilePictureCenter ? constraints.append(userProfileView!.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor)) :
                    constraints.append(userProfileView!.topAnchor.constraint(equalTo: audioView!.topAnchor, constant: 80))
                }else{
                    constraints.append(textView!.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor))
                    alignProfilePictureCenter ? constraints.append(textView!.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor)) : constraints.append(textView!.centerYAnchor.constraint(equalTo: audioView!.topAnchor, constant: 130))
                    
                    constraints.append(circleView.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor))
                    alignProfilePictureCenter ? constraints.append(circleView.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor)) : constraints.append(circleView.topAnchor.constraint(equalTo: audioView!.topAnchor, constant: 80))
                    constraints.append(circleView.widthAnchor.constraint(equalToConstant: CGFloat(profileSize)))
                    constraints.append(circleView.heightAnchor.constraint(equalToConstant: CGFloat(profileSize)))
                    
                }
                NSLayoutConstraint.activate(constraints)
//                NSLayoutConstraint.activate([
//                    textView == nil ? userProfileView!.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor) : textView!.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor),
//                    textView != nil ? alignProfilePictureCenter ? textView!.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor) :
//                        textView!.centerYAnchor.constraint(equalTo: audioView!.topAnchor, constant: 130) : alignProfilePictureCenter ? userProfileView!.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor) :
//                        userProfileView!.centerYAnchor.constraint(equalTo: audioView!.topAnchor, constant: 130),
//                    textView != nil ? alignProfilePictureCenter ? userProfileView!.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor) : userProfileView!.topAnchor.constraint(equalTo: audioView!.topAnchor, constant: 80): nil,
//                ])
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

private func getIsBlockedByMe(jid: String) -> Bool {
    return ChatManager.getContact(jid: jid)?.isBlockedMe ?? false
}

extension UIImageView {
    func loadFlyImage(imageURL: String, name: String, chatType: ChatType = .singleChat, uniqueId: String = "", contactType : ContactType = .unknown,jid: String, isBlockedByAdmin: Bool = false, validateBlock: Bool = true){
        let urlString = ChatManager.getImageUrl(imageName: imageURL)
        var url = URL(string: urlString)
        var placeholder : UIImage?
        if isBlockedByAdmin {
            url = URL(string: "")
        }
        self.sd_setImage(with: url, placeholderImage: placeholder, options: [.continueInBackground,.decodeFirstFrameOnly,.lowPriority], progress: nil){ (image, responseError, isFromCache, imageUrl) in
            if let error =  responseError as? NSError{
                if let errorCode = error.userInfo[SDWebImageErrorDownloadStatusCodeKey] as? Int {
                    if errorCode == 401{
                        print("===contact 401 error")
                        ChatManager.refreshToken { [weak self] isSuccess, error, data in
                            if isSuccess{
                                self?.loadFlyImage(imageURL: imageURL, name: name, chatType : chatType, jid: jid)
                            }else{
//                                self?.image = placeholder
                                print("===contact refresh token error")
                            }
                        }
                    }else{
//                        self.image = placeholder
                        print("===contact image load error code \(errorCode)")
                    }
                }
            }else{
                self.image = image
            }
        }
    }
}

