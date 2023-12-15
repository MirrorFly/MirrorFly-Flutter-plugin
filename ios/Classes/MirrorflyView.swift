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
    private var pulsatingTimer: Timer?
    
    let circleView = UIView(frame: .zero)
//    let rippleLayer = CAShapeLayer()
    
    // Create a pulsating animation using a timer
    var scaleFactor: CGFloat = 1.0
    var growing = true
    
    let waveLayer = CAShapeLayer()
        var waveAnimation: CABasicAnimation!
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        NSLog("\(Constants.callTag) viewId \(viewId)")
        self.viewId = viewId
        super.init()
        
        if let argument = args as? [String: Any]{
            NSLog("\(Constants.callTag) argument--> \(argument)")
            
            let userJid = argument["userJid"] as? String ?? ""
            
            
            var contact = ChatManager.profileDetaisFor(jid: userJid)
            
            NSLog("===contact \(String(describing: contact?.image))")
            
            if(contact == nil){
                do {
                    try ContactManager.shared.getUserProfile(for: userJid, fetchFromServer: true, saveAsFriend: true){ isSuccess, flyError, flyData in
                        var data  = flyData
                        let profileData = data.getData() as? ProfileDetails
                        print("***getUserProfile\(String(describing: profileData))")

                        print("***getUserProfile dict\(String(describing: profileData.toJson()))")
                        if isSuccess {
                            contact = profileData
                            self.handleUserProfileDetails(userJid: userJid, contact: contact, argument: argument)
                                                
                        } else{
//                            result(FlutterError(code: "500", message: flyError!.localizedDescription, details: nil))
                            NSLog("\(Constants.callTag) ContactManager.shared.getUserProfile Error fetching Profile")
                        }
                    }
                }catch{
                    print("Error while calling User Profile Details")
                }

            }else{
                handleUserProfileDetails(userJid: userJid, contact: contact, argument: argument)
            }
            
        
        }
        
    }
    
    private func handleUserProfileDetails(userJid: String, contact: ProfileDetails?, argument: [String: Any]) {
        
        let muteStatus = userJid == AppUtils.getMyJid() ? CallManager.isVideoMuted() : CallManager.isRemoteVideoMuted(userJid)
        

        let userName = FlyUtils.getUserName(jid: (contact?.jid)!, name: contact!.name, nickName: contact!.nickName, contactType: contact!.contactType)
        
        
        NSLog("\(Constants.callTag) userName --> \(userName)")
        videoTrack = CallManager.getRemoteVideoTrack(jid: userJid)
        let calluserslist = CallManager.getAllCallUsersList()
        NSLog("\(Constants.callTag) calluserslist \(calluserslist)")
        NSLog("\(Constants.callTag) calluserslist count \(calluserslist.count)")
        NSLog("\(Constants.callTag) \(userJid) videoTrack--> \(String(describing: videoTrack))")
        NSLog("\(Constants.callTag) Video rendered/Audio Call")
        
        createAudioView(argument: argument, userName: userName, contact: contact)
        
        createVideoView(argument: argument)
        
        if(videoTrack == nil || CallManager.getCallType() == .Audio || muteStatus){
            
//                showAudioView(argument: argument, userName: userName)
//                DispatchQueue.main.async {
                self.videoView?.removeFromSuperview()
//                }
            
        }else{
//                DispatchQueue.main.async {
                self.audioView?.removeFromSuperview()
//                }
            
        }
    }
    
    func dispose() {
        
        self.videoView?.removeFromSuperview()
        self.audioView?.removeFromSuperview()
        self.textView?.removeFromSuperview()
        self.userProfileView?.removeFromSuperview()
        pulsatingTimer?.invalidate()
        pulsatingTimer = nil
    }
    
    private func createVideoView(argument : [String: Any]){
        NSLog("\(Constants.callTag) createVideoView")
        if videoView == nil {
            videoView = getVideoView()
//            DispatchQueue.main.async {
                self._baseView.addSubview(self.videoView!)
//            }
            
        }
        
        videoView?.translatesAutoresizingMaskIntoConstraints = false
        
        videoView?.layer.masksToBounds = true
        videoView?.contentMode = .center
        videoView?.backgroundColor = .black
        if argument["setMirror"] is Bool{
            videoView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        NSLog("\(Constants.callTag) Adding video track")
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
            
            circleView.translatesAutoresizingMaskIntoConstraints = false
            circleView.backgroundColor = randomColor() // Generate a random background color
            circleView.layer.cornerRadius = CGFloat(profileSize / 2)


            // Add a pulsating animation to the circleView
              
            
            if (!hideProfileView){
         
//                if contact?.image == nil || (contact!.image.isEmpty) {
//                    DispatchQueue.main.async {
                        self.audioView?.addSubview(self.circleView)
//                    }

                    
                    NSLog("===contact image is empty")
                    textView = UITextView(frame: .zero)
                    textView?.translatesAutoresizingMaskIntoConstraints = false
                    NSLog("\(Constants.callTag) userName \(userName)")
                    textView?.text = getAbbreviation(from: userName).uppercased()
                    textView?.isEditable = false
                    textView?.isScrollEnabled = false
                    textView?.textAlignment = .center
                    textView?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
                    textView?.textColor = .white
                    textView?.backgroundColor = .clear
                    
                    textView?.clipsToBounds = true
//                    DispatchQueue.main.async {
                        self.audioView?.addSubview(self.textView!)
//                    }
                    
                    
//                }else{
                if contact?.image != nil || (!contact!.image.isEmpty) {
                    NSLog("===contact image is not empty \(profileSize)")
                    userProfileView = UIImageView(frame: .zero)
                    userProfileView?.translatesAutoresizingMaskIntoConstraints = false
                    userProfileView?.frame.size = CGSize(width: profileSize, height: profileSize)
                    userProfileView?.layer.cornerRadius = CGFloat(profileSize / 2)
//                    userProfileView?.loadFlyImage(imageURL: contact?.image ?? "", name: FlyUtils.getUserName(jid: (contact?.jid)!, name: contact!.name, nickName: contact!.nickName, contactType: contact!.contactType), jid: contact?.jid ?? "", textview: self.textView!, circleview: self.circleView)
                    userProfileView?.clipsToBounds = true
//                    DispatchQueue.main.async {
                        self.audioView?.addSubview(self.userProfileView!)
//                    }
                }
                
            
            

                var constraints: [NSLayoutConstraint] = []
                
                
//                if(textView == nil){
                if(contact?.image != nil || (!contact!.image.isEmpty)){
                    NSLog("setting constraint 1")
                    constraints.append(userProfileView!.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor))
                    NSLog("setting constraint 2")
                    alignProfilePictureCenter ? constraints.append(userProfileView!.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor)) :
                    constraints.append(userProfileView!.topAnchor.constraint(equalTo: audioView!.topAnchor, constant: 80))
                    NSLog("setting constraint 3")
                    constraints.append(userProfileView!.widthAnchor.constraint(equalToConstant: CGFloat(profileSize)))
                    NSLog("setting constraint 4")
                    constraints.append(userProfileView!.heightAnchor.constraint(equalToConstant: CGFloat(profileSize)))
                }
//                }else{
                
                NSLog("setting constraint 5")
                    constraints.append(textView!.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor))
                NSLog("setting constraint 6")
                    alignProfilePictureCenter ? constraints.append(textView!.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor)) : constraints.append(textView!.centerYAnchor.constraint(equalTo: audioView!.topAnchor, constant: 130))
                NSLog("setting constraint 7")
                    constraints.append(circleView.centerXAnchor.constraint(equalTo: audioView!.centerXAnchor))
                NSLog("setting constraint 8")
                    alignProfilePictureCenter ? constraints.append(circleView.centerYAnchor.constraint(equalTo: audioView!.centerYAnchor)) : constraints.append(circleView.topAnchor.constraint(equalTo: audioView!.topAnchor, constant: 80))
                NSLog("setting constraint 9")
                    constraints.append(circleView.widthAnchor.constraint(equalToConstant: CGFloat(profileSize)))
                NSLog("setting constraint 10")
                    constraints.append(circleView.heightAnchor.constraint(equalToConstant: CGFloat(profileSize)))
                    
//                }
                NSLayoutConstraint.activate(constraints)
                
                if contact?.image != nil || (!contact!.image.isEmpty) {
                    userProfileView?.loadFlyImage(imageURL: contact?.image ?? "", name: FlyUtils.getUserName(jid: (contact?.jid)!, name: contact!.name, nickName: contact!.nickName, contactType: contact!.contactType), jid: contact?.jid ?? "", textview: self.textView!, circleview: self.circleView)
                }

            }
            

//            pulsatingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//                guard let self = self else { return }
//
//                if self.growing {
//                    scaleFactor = 1.2 // Increase size
//                } else {
//                    scaleFactor = 1.0 // Restore original size
//                }
//
//                self.growing.toggle()
//
//                // Ensure that `circleView` is a valid reference to your UIView
//
////                UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat], animations: {
////                    circleView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
////                }, completion: nil)
//
//
//
//
//                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: {
//                    circleView.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
//                }, completion: nil)
//            }

           
            

            

            
//            // Create the rippleView
//            let rippleView = RippleView(frame: CGRect(x: 0, y: 0, width: profileSize+10, height: profileSize+10))
//            rippleView.translatesAutoresizingMaskIntoConstraints = false
//            rippleView.backgroundColor = .clear // Set a transparent background color
//
//            // Add the rippleView to your circular view or audioView
//            circleView.addSubview(rippleView)
//
//            // Add constraints for the rippleView (similar to your circular view's constraints)
//            NSLayoutConstraint.activate([
//                circleView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
//                circleView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
//                rippleView.widthAnchor.constraint(equalToConstant: CGFloat(profileSize+10)),
//                rippleView.heightAnchor.constraint(equalToConstant: CGFloat(profileSize+10))
//            ])
//
//            // Start the ripple animation
//            rippleView.startRippleAnimation()

//            DispatchQueue.main.async {
                
                self._baseView.addSubview(self.audioView!)
                
//            }
            
            
            
            NSLayoutConstraint.activate([
                audioView!.centerXAnchor.constraint(equalTo: _baseView.centerXAnchor),
                audioView!.centerYAnchor.constraint(equalTo: _baseView.centerYAnchor),
                audioView!.topAnchor.constraint(equalTo: _baseView.topAnchor),
                audioView!.bottomAnchor.constraint(equalTo: _baseView.bottomAnchor)
            ])
//            DispatchQueue.main.async {
                self.videoView?.removeFromSuperview()
//            }
        }
    }
    

    
    public func startAnimation(userID: String) {
        // Check if the timer is nil or invalidated
        if pulsatingTimer == nil || !pulsatingTimer!.isValid {
//             NSLog("Starting Ripple animation for user: \(userID)")
            pulsatingTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
                guard let self = self else { return }

                if self.growing {
                    self.scaleFactor = 1.1 // Increase size
                } else {
                    self.scaleFactor = 1.0 // Restore original size
                }

                self.growing.toggle()

                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                    if self.userProfileView == nil{
                        self.circleView.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
                    }else{
                        self.userProfileView?.transform = CGAffineTransform(scaleX: self.scaleFactor, y: self.scaleFactor)
                    }
                }, completion: nil)
            }

            // Start the timer
            pulsatingTimer?.fire()
        } else {
//             NSLog("Ripple animation is already running for user: \(userID)")
        }
    }

    public func stopAnimation(userID: String) {
        if pulsatingTimer != nil && pulsatingTimer!.isValid {
//             NSLog("Stopping Ripple animation for user: \(userID)")
            pulsatingTimer?.invalidate()
            pulsatingTimer = nil
        } else {
//             NSLog("Ripple animation is not running for user: \(userID)")
        }
    }


    
    private func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func view() -> UIView {
        return _baseView
    }
    
    func updateVideoTrack(userJid: String, updateType: MuteEvent) {
        NSLog("\(Constants.callTag) Update Video Track viewId\(viewId) userJid\(userJid) updateType\(updateType)")
        
        if(updateType == .ACTION_REMOTE_VIDEO_UN_MUTE || updateType == .ACTION_LOCAL_VIDEO_UN_MUTE){
            NSLog("\(Constants.callTag) Removing Existing video track for \(userJid)")
            videoTrack?.remove(videoView as! RTCVideoRenderer)
            videoTrack = CallManager.getRemoteVideoTrack(jid: userJid)
            
            if let track = videoTrack {
                NSLog("\(Constants.callTag) get remote track for \(userJid) : \(track)")
                if videoView == nil{
                    videoView = getVideoView()
                }
                
                track.add(videoView as! RTCVideoRenderer)
                DispatchQueue.main.async {
                    self._baseView.addSubview(self.videoView!)
                
                
                NSLayoutConstraint.activate([
                    self.videoView!.leadingAnchor.constraint(equalTo: self._baseView.leadingAnchor),
                    self.videoView!.trailingAnchor.constraint(equalTo: self._baseView.trailingAnchor),
                    self.videoView!.topAnchor.constraint(equalTo: self._baseView.topAnchor),
                    self.videoView!.bottomAnchor.constraint(equalTo: self._baseView.bottomAnchor)
                ])

                    self.audioView?.removeFromSuperview()
                }
            }else{
                NSLog("\(Constants.callTag) video track is null for \(userJid)")
                
            }
        }else if (updateType == .ACTION_REMOTE_VIDEO_MUTE || updateType == .ACTION_LOCAL_VIDEO_MUTE){
            NSLog("\(Constants.callTag) show Audio View for \(userJid)")
            DispatchQueue.main.async {
                self.videoView?.removeFromSuperview()
                self._baseView.addSubview(self.audioView!)
                
                NSLayoutConstraint.activate([
                    self.audioView!.centerXAnchor.constraint(equalTo: self._baseView.centerXAnchor),
                    self.audioView!.centerYAnchor.constraint(equalTo: self._baseView.centerYAnchor),
                    self.audioView!.topAnchor.constraint(equalTo: self._baseView.topAnchor),
                    self.audioView!.bottomAnchor.constraint(equalTo: self._baseView.bottomAnchor)
                ])
            }
        }else{
            NSLog("\(Constants.callTag) Received Update Mirrorfly View Event is \(updateType) for jid \(userJid). No update is done in Mirrorfly View. Listener has been forwarded to flutter View.")
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
//        DispatchQueue.main.async {
            self.textView?.removeFromSuperview()
//        }
    }
    
    private func removeVideoView() {
        NSLog("\(Constants.callTag) removing video track removeVideoView")
//        DispatchQueue.main.async {
            self.videoTrack?.remove(self.videoView as! RTCVideoRenderer)
            self.videoView?.removeFromSuperview()
//        }
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
    
//    func addRippleEffect(to referenceView: UIView) {
    //            /*! Creates a circular path around the view*/
    //            let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height))
    //            /*! Position where the shape layer should be */
    //            let shapePosition = CGPoint(x: referenceView.bounds.size.width / 2.0, y: referenceView.bounds.size.height / 2.0)
    //            let rippleShape = CAShapeLayer()
    //            rippleShape.bounds = CGRect(x: 0, y: 0, width: referenceView.bounds.size.width, height: referenceView.bounds.size.height)
    //            rippleShape.path = path.cgPath
    //            rippleShape.fillColor = UIColor.clear.cgColor
    //            rippleShape.strokeColor = UIColor.yellow.cgColor
    //            rippleShape.lineWidth = 4
    //            rippleShape.position = shapePosition
    //            rippleShape.opacity = 0
    //
    //            /*! Add the ripple layer as the sublayer of the reference view */
    //            referenceView.layer.addSublayer(rippleShape)
    //            /*! Create scale animation of the ripples */
    //            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
    //            scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
    //            scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))
    //            /*! Create animation for opacity of the ripples */
    //            let opacityAnim = CABasicAnimation(keyPath: "opacity")
    //            opacityAnim.fromValue = 1
    //            opacityAnim.toValue = nil
    //            /*! Group the opacity and scale animations */
    //            let animation = CAAnimationGroup()
    //            animation.animations = [scaleAnim, opacityAnim]
    //        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    //            animation.duration = CFTimeInterval(0.7)
    //            animation.repeatCount = 25
    //            animation.isRemovedOnCompletion = true
    //            rippleShape.add(animation, forKey: "rippleEffect")
    //        }
    //
    //    private func addRippaaaleEffect(to view: UIView) {
    //        let rippleLayer = CAShapeLayer()
    //        rippleLayer.bounds = view.bounds
    //        rippleLayer.position = view.center
    //        rippleLayer.cornerRadius = view.layer.cornerRadius
    //        rippleLayer.backgroundColor = UIColor.clear.cgColor
    //        rippleLayer.strokeColor = UIColor.red.cgColor
    //        rippleLayer.lineWidth = 2
    //        rippleLayer.opacity = 0
    //
    //        view.layer.addSublayer(rippleLayer)
    //
    //        let rippleAnimation = CABasicAnimation(keyPath: "opacity")
    //        rippleAnimation.fromValue = 1
    //        rippleAnimation.toValue = 0
    //        rippleAnimation.duration = 1.5
    //        rippleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    //        rippleAnimation.repeatCount = .greatestFiniteMagnitude
    //
    //        rippleLayer.add(rippleAnimation, forKey: "rippleAnimation")
    //    }
}

private func getIsBlockedByMe(jid: String) -> Bool {
    return ChatManager.getContact(jid: jid)?.isBlockedMe ?? false
}

extension UIImageView {
    func loadFlyImage(imageURL: String, name: String, chatType: ChatType = .singleChat, uniqueId: String = "", contactType : ContactType = .unknown,jid: String, isBlockedByAdmin: Bool = false, validateBlock: Bool = true, textview: UITextView, circleview: UIView){
        NSLog("loadFlyImage imageURL \(imageURL) jid\(jid)")
        var urlString = ""
        if imageURL.hasPrefix("http") {
            NSLog("The URL is Remote")
            urlString = imageURL
        } else {
            NSLog("The image url is local/mirrorfly server")
            urlString = ChatManager.getImageUrl(imageName: imageURL)
        }
//        let urlString = ChatManager.getImageUrl(imageName: imageURL)
        NSLog("loadFlyImage \(urlString)")
        var url = URL(string: urlString)
        var placeholder : UIImage?
        if isBlockedByAdmin {
            NSLog("===contact Blocked By Admin")
            url = URL(string: "")
        }
        self.sd_setImage(with: url, placeholderImage: placeholder, options: [.continueInBackground,.decodeFirstFrameOnly,.lowPriority], progress: nil){ (image, responseError, isFromCache, imageUrl) in
            if let error =  responseError as? NSError{
                if let errorCode = error.userInfo[SDWebImageErrorDownloadStatusCodeKey] as? Int {
                    if errorCode == 401{
                        NSLog("===contact 401 error")
                        ChatManager.refreshToken { [weak self] isSuccess, error, data in
                            if isSuccess{
                                self?.loadFlyImage(imageURL: imageURL, name: name, chatType : chatType, jid: jid, textview: textview, circleview: circleview)
                            }else{
//                                self?.image = placeholder
                                NSLog("===contact refresh token error")
                            }
                        }
                    }else{
//                        self.image = placeholder
                        NSLog("===contact image load error code \(errorCode)")
                    }
                }
            }else{
                NSLog("======contact error else");
                textview.removeFromSuperview()
                circleview.removeFromSuperview()
                self.image = image
            }
        }
    }
}


class RippleView: UIView {
    private var rippleLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        // Configure the ripple layer
        rippleLayer.fillColor = UIColor.clear.cgColor
        rippleLayer.strokeColor = UIColor.gray.cgColor // Set the ripple color to gray
        rippleLayer.lineWidth = 2
        rippleLayer.opacity = 0

        // Add the ripple layer to the view's layer
        layer.addSublayer(rippleLayer)
    }

    func startRippleAnimation() {
        // Create the ripple animation
        let rippleAnimation = CABasicAnimation(keyPath: "path")
        rippleAnimation.fromValue = UIBezierPath(ovalIn: CGRect(x: -2, y: -2, width: 4, height: 4)).cgPath
        rippleAnimation.toValue = UIBezierPath(ovalIn: bounds.insetBy(dx: -2, dy: -2)).cgPath
        rippleAnimation.duration = 1.5 // Animation duration
        rippleAnimation.repeatCount = .greatestFiniteMagnitude // Repeat indefinitely
        rippleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        // Add the animation to the ripple layer
        rippleLayer.add(rippleAnimation, forKey: "rippleAnimation")
    }
}

