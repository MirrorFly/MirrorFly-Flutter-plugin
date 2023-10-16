//
//  FlyCall.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import MirrorFlySDK
import Flutter
import PushKit

@objc class FlyCall : NSObject, CallManagerDelegate, FlutterPlugin, PKPushRegistryDelegate, AudioManagerDelegate, MissedCallNotificationDelegate {
    
    var selectedAudioRouteDevice : String = "receiver"
    var isAudioRouteMethodCall : Bool = false
    
    func audioRoutedTo(deviceName: String, audioDeviceType: MirrorFlySDK.OutputType) {
        NSLog("#MirrorflyCall triggerDelegateForOutputs \(audioDeviceType)")
        
        switch (audioDeviceType) {
        case .bluetooth:
            selectedAudioRouteDevice = "bluetooth"
            break
        case .receiver:
            selectedAudioRouteDevice = "receiver"
        case .speaker:
            selectedAudioRouteDevice = "speaker"
        case .headset:
            selectedAudioRouteDevice = "headset"
        @unknown default:
            selectedAudioRouteDevice = "none"
        }
        if !isAudioRouteMethodCall{
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue(AppUtils.getMyJid(), forKey: "userJid")
            jsonObject.setValue("AUDIO_DEVICE_CHANGED", forKey: "callAction")
            let callUpdate = pluginDictToJson(dictionary: jsonObject)
            self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallActionChannel, value: callUpdate)
        }
        
    }
    
    
    private var methodChannel: FlutterMethodChannel?
    private var registrar: FlutterPluginRegistrar?
    private var eventChannel : FlutterEventChannel?
    private var eventChannelInitializer: FlyEventChannelInitializer = FlyEventChannelInitializer()
    private var factory : MirrorflyViewFactory?
    
    var currentOutputDevice : OutputType = .receiver
    
    init(registrar: FlutterPluginRegistrar) {
        super.init()
        
        self.registrar = registrar
        
        
        factory = MirrorflyViewFactory(messenger: registrar.messenger())
        registrar.register(factory!, withId: "mirrorfly_view")
        
        eventChannelInitializer.initializeEventChannels(registrar: registrar)
        
        registerForVOIPNotifications()
        
        methodChannel = FlutterMethodChannel(name: Constants.callMethodChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(self, channel: methodChannel!)
        
        CallManager.setCallEventsDelegate(delegate: self)
        AudioManager.shared().audioManagerDelegate = self
        CallManager.missedCallNotificationDelegate = self
        
//        AudioManager.sharedInstance.audioManagerDelegate = self
        NSLog("\(Constants.callTag) audioManagerDelegate")
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _ = FlyCall(registrar: registrar)
    }
        
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if (call.method == "selectedAudioDevice"){
            selectedAudioDevice(call: call, result: result)
//        }else if (call.method == "muteVideo"){
//            muteVideo(call: call, result: result)
        }else{
            if (call.method == "makeVoiceCall" || call.method == "makeVideoCall" || call.method == "makeGroupVideoCall" || call.method == "makeGroupVoiceCall"){
                
                if AudioManager.shared().audioManagerDelegate == nil {
                    NSLog("\(Constants.callTag) AudioManager Delegate is Nil, setting new Delegate")
                    AudioManager.shared().audioManagerDelegate = self
                }

            }
//            if (call.method == "declineCall" || call.method == "disconnectCall"){
//                NSLog("\(Constants.callTag) clearing Mirrorfly Views in method call")
//                factory?.clearMirrorflyView()
//            }
            if let methodHandler = FlyMethodConstants.callMethodHandlers[call.method] {
                NSLog("\(Constants.callTag) Method call \(call.method)")
                methodHandler(call, result, factory)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    
    func getDisplayName(IncomingUser: [String]) {
        var userString = [String]()
        if isHideNotificationContent{
            userString.append(APP_NAME)
        }else{
            for JID in IncomingUser where JID != AppUtils.getMyJid(){
                NSLog("#jid \(JID)")
                if let contact = ChatManager.getContact(jid: JID.lowercased()){
                    let contactSync = Utility.getBoolFromPreference(key: Constants.contactSyncEnable)
                    if contactSync{
                        if contact.contactType == .unknown{
                            userString.append((try? FlyUtils.getIdFromJid(jid: JID)) ?? "")
                        }else{
                            userString.append(getUserName(jid: contact.jid, name: contact.name, nickName: contact.nickName, contactType: contact.contactType))
                        }
                    }else{
                        userString.append(getUserName(jid: contact.jid, name: contact.name, nickName: contact.nickName, contactType: contact.contactType))
                    }
                }else {
                    let pd = ContactManager.shared.saveTempContact(userId: JID)
                    userString.append(pd?.name ?? "User")
                }
            }
            NSLog("#names \(userString)")
        }
        CallManager.getContactNames(IncomingUserName: userString)
    }
    
    func getUserName(jid : String, name : String , nickName : String, contactType : ContactType) -> String {
        FlyUtils.getUserName(jid: jid, name: name, nickName: nickName, contactType: contactType)
    }
    
    func getGroupName(_ groupId: String) {
        if isHideNotificationContent {
            CallManager.getContactNames(IncomingUserName: [APP_NAME])
        }else{
            if let groupContact =  ChatManager.getContact(jid: groupId.lowercased()){
                CallManager.getContactNames(IncomingUserName: [groupContact.name])
            }else{
                CallManager.getContactNames(IncomingUserName: ["Call from Group"])
            }
        }
    }
    
    func sendCallMessage(groupCallDetails: MirrorFlySDK.GroupCallDetails, users: [String], invitedUsers: [String]) {
        NSLog("#MirrorflyCall send call message group call Details--> \(groupCallDetails)")
        NSLog("#MirrorflyCall send call message users--> \(users)")
        NSLog("#MirrorflyCall send call message Invited users--> \(invitedUsers)")
        
        try? FlyMessenger.sendCallMessage(for: groupCallDetails, users : users , inviteUsers: invitedUsers) { isSuccess, flyError, flyData in
            var data  = flyData
            if isSuccess {
                NSLog(data.getMessage() as? String ?? "")
            } else{
                NSLog(data.getMessage() as! String)
            }
        }
    }
    
    func socketConnectionEstablished() {
        
    }
     
    func selectedAudioDevice(call: FlutterMethodCall, result: @escaping FlutterResult) {
        isAudioRouteMethodCall = true
//        AudioManager.sharedInstance.getCurrentAudioInput()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NSLog("#Mirrorfly call selectedAudioDevice \(self.selectedAudioRouteDevice)")
            self.isAudioRouteMethodCall = false
            result(self.selectedAudioRouteDevice)
        }
    }
    
    
    
    
    func onCallStatusUpdated(callStatus: MirrorFlySDK.CALLSTATUS, userId: String) {
        NSLog("#MirrorflyCall Call Status Updated--> \(callStatus.rawValue) userID \(userId)")
            
        if AudioManager.shared().audioManagerDelegate == nil  && callStatus != .DISCONNECTED{
            NSLog("\(Constants.callTag) AudioManager Delegate is Nil, setting new Delegate @ onCallStatusUpdated")
            AudioManager.shared().audioManagerDelegate = self
        }

        var userJID = userId
        if userJID == "" && callStatus == .DISCONNECTED{
//            NSLog("\(Constants.callTag) SDK is empty so assigning self jid")
            NSLog("\(Constants.callTag) Disconnected is Called on Empty User ID so assuming self disconnect is called and not returning the Delegate")
//            userJID = AppUtils.getMyJid()
            return
        }
        
        if userJID == ""{
            userJID = AppUtils.getMyJid()
        }
        
        if(userJID != "" && callStatus == .DISCONNECTED){
            NSLog("\(Constants.callTag) clearing Mirrorfly Views")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.factory?.clearMirrorflyView(userJID: userJID)
//            }
            
        }

        //Added this below condition based on the iOS Sample App.
        //callStatus != .DISCONNECTED is added for flutter, bcz the network disconnection gives the own JID for disconnect.
        //callStatus != .ON_HOLD && callStatus != .ON_RESUME for flutter to handle Call Hold and Resume
//        if userJID == AppUtils.getMyJid() && (callStatus != .RECONNECTING && callStatus != .RECONNECTED && callStatus != .DISCONNECTED && callStatus != .ON_HOLD && callStatus != .ON_RESUME) {
//            NSLog("#Mirrorfly Call not updating the Call Status for my jid")
//            return
//        }
        
        if callStatus == .RECONNECTED && !CallManager.isCallConnected(){
            NSLog("#Mirrorfly Call not updating the Call Status bcz Call is reconnected status and call is not connected")
            return
        }
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        if (callStatus.rawValue == "CALL TIME OUTt"){
            jsonObject.setValue("CALL TIME OUT", forKey: "callStatus")
        }else{
            jsonObject.setValue(callStatus.rawValue, forKey: "callStatus")
        }
        jsonObject.setValue(userJID, forKey: "userJid")
        
        if CallManager.isOneToOneCall()  {
            jsonObject.setValue("onetoone", forKey: "callMode")
        }else{
            jsonObject.setValue("onetomany", forKey: "callMode")
        }
        
//        if(callStatus.rawValue == "Attended"){
            
//            NSLog("#MirrorflyCall Call Status Updated Attended")
//            AudioManager.shared().audioManagerDelegate = self
            
            if CallManager.getCallType() == .Audio {
                jsonObject.setValue("audio", forKey: "callType")
            } else {
                jsonObject.setValue("video", forKey: "callType")
            }
//        }
        
        
        
        let callStatusUpdateJson = pluginDictToJson(dictionary: jsonObject)
            self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallStatusUpdateChannel, value: callStatusUpdateJson)
        
    }
    
    func onCallAction(callAction: MirrorFlySDK.CallAction, userId: String) {
        NSLog("#MirrorflyCall Event oncalll Action --> \(callAction.rawValue) userID \(userId)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        if userId == ""{
            jsonObject.setValue(AppUtils.getMyJid(), forKey: "userJid")
        }else{
            jsonObject.setValue(userId, forKey: "userJid")
        }
        jsonObject.setValue(callAction.rawValue, forKey: "callAction")
        
        if (callAction == .CHANGE_TO_AUDIO_CALL){
            CallManager.setCallType(callType: .Audio)
//            CallManager.muteVideo(true)
            CallManager.disableVideo()
            AudioManager.shared().autoReRoute()
        }
        
        if (callAction == .ACTION_VIDEO_CALL_CONVERSION_ACCEPTED){
//            if AudioManager.shared().audioManagerDelegate == nil {
//                NSLog("\(Constants.callTag) AudioManager Delegate is Nil, setting new Delegate")
//                AudioManager.shared().audioManagerDelegate = self
//            }else{
//                NSLog("\(Constants.callTag) AudioManager Delegate is already set")
//            }
            CallManager.setCallType(callType: .Video)
            CallManager.muteVideo(false)
            CallManager.enableVideo()
            AudioManager.shared().autoReRoute()
        }
        
        let callActionJson = pluginDictToJson(dictionary: jsonObject)
        
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallActionChannel, value: callActionJson)
    }
    
    func onMuteStatusUpdated(muteEvent: MirrorFlySDK.MuteEvent, userId: String) {
        NSLog("#MirrorflyCall Event onmute status updated --> \(muteEvent) userID \(userId)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userId, forKey: "userJid")
        switch(muteEvent){
        case .ACTION_LOCAL_AUDIO_MUTE:
//            jsonObject.setValue("local_audio_mute", forKey: "muteEvent")
            break;
        case .ACTION_REMOTE_VIDEO_MUTE:
            jsonObject.setValue("REMOTE_VIDEO_MUTE", forKey: "muteEvent")
            if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
                if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                    mirrorflyView.updateVideoTrack(userJid: userId, updateType: muteEvent)
                } else {
                    // Handle case when view is not found
                    NSLog("\(Constants.callTag) ACTION_REMOTE_VIDEO_MUTE --> View is not Found")
                }
            } else {
                // Handle case when unique ID is not found
                NSLog("\(Constants.callTag) ACTION_REMOTE_VIDEO_MUTE --> Unique ID is not Found")
            }
            break;
        case .ACTION_REMOTE_VIDEO_UN_MUTE:
            jsonObject.setValue("REMOTE_VIDEO_UN_MUTE", forKey: "muteEvent")
            if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
                if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                    mirrorflyView.updateVideoTrack(userJid: userId, updateType: muteEvent)
                } else {
                    // Handle case when view is not found
                    NSLog("\(Constants.callTag) ACTION_REMOTE_VIDEO_UN_MUTE --> View is not Found")
                }
            } else {
                // Handle case when unique ID is not found
                NSLog("\(Constants.callTag) ACTION_REMOTE_VIDEO_UN_MUTE --> Unique ID is not Found")
            }
            break;
        case .ACTION_REMOTE_AUDIO_MUTE:
            jsonObject.setValue("REMOTE_AUDIO_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_REMOTE_AUDIO_UN_MUTE:
            jsonObject.setValue("REMOTE_AUDIO_UN_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_LOCAL_AUDIO_UN_MUTE:
//            jsonObject.setValue("local_audio_unmute", forKey: "muteEvent")
            break;
        @unknown default:
//            jsonObject.setValue("unknown", forKey: "muteEvent")
            break;
        }
        
        let muteActionJson = pluginDictToJson(dictionary: jsonObject)
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onMuteStatusUpdatedChannel, value: muteActionJson)
        
    }
    
    func onUserSpeaking(userId: String, audioLevel: Int) {
//        NSLog("#MirrorflyCall user speaking --> \(userId) audioLevel \(audioLevel)")
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userId, forKey: "userJid")
        jsonObject.setValue(audioLevel, forKey: "audioLevel")
        let speakingJson = pluginDictToJson(dictionary: jsonObject)
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
//                mirrorflyView.startAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    mirrorflyView.startAnimation(userID: userId)
                }

            } else {
                // Handle case when view is not found
            }
        } else {
            // Handle case when unique ID is not found
        }
        
//        eventChannelInitializer.sinkValues[Constants.onUserSpeakingChannel] = speakingJson
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onUserSpeakingChannel, value: speakingJson)
        
    }
    
    func onUserStoppedSpeaking(userId: String) {
//        NSLog("#MirrorflyCall user stopped speaking --> \(userId)")
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    mirrorflyView.stopAnimation(userID: userId)
                }
            } else {
                // Handle case when view is not found
            }
        } else {
            // Handle case when unique ID is not found
        }
        
        eventChannelInitializer.sinkValues[Constants.onUserSpeakingChannel] = userId
    }
    
    func onLocalVideoTrackAdded(userId: String, videoTrack: RTCVideoTrack) {
        NSLog("\(Constants.callTag) onlocal video Track --> \(userId) ---> \(videoTrack)")
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(AppUtils.getMyJid(), forKey: "userJid")
        let jidJson = pluginDictToJson(dictionary: jsonObject)
        
//        if let mirrorflyView = MirrorflyViewFactory.mirrorflyViews[viewId] {
//                            mirrorflyView.updateVideoTrack(userJid: userJid)
//                            result(nil)
//                        } else {
//                            result(FlutterError(code: "INVALID_VIEW_ID", message: "Invalid view identifier", details: nil))
//                        }
        
        let videoTrack = CallManager.getRemoteVideoTrack(jid: userId)
        NSLog("\(Constants.callTag) delegate videoTrack--> \(String(describing: videoTrack))")
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: userId, updateType: MuteEvent.ACTION_REMOTE_VIDEO_UN_MUTE)
            } else {
                // Handle case when view is not found
                NSLog("\(Constants.callTag) onLocalVideoTrackAdded --> View is not Found")
            }
        } else {
            // Handle case when unique ID is not found
            NSLog("\(Constants.callTag) onLocalVideoTrackAdded --> Unique ID is not Found")
        }
        
        eventChannelInitializer.sinkValues[Constants.onTrackAddedChannel] = jidJson
    }
    
    func onRemoteVideoTrackAdded(userId: String, track: RTCVideoTrack) {
        NSLog("\(Constants.callTag) onRemote video Track --> \(userId)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userId, forKey: "userJid")
        let jidJson = pluginDictToJson(dictionary: jsonObject)
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: userId, updateType: MuteEvent.ACTION_REMOTE_VIDEO_UN_MUTE)
            } else {
                // Handle case when view is not found
            }
        } else {
            // Handle case when unique ID is not found
        }

        eventChannelInitializer.sinkValues[Constants.onTrackAddedChannel] = jidJson
    }
    
//    func audioRoutedTo(deviceName: String, audioDeviceType: MirrorFlySDK.OutputType) {
//        NSLog("#audiomanager audioRoutedTo  CallViewController \(deviceName) \(audioDeviceType)")
//        switch audioDeviceType {
//        case .receiver:
//            currentOutputDevice = .receiver
////            outgoingCallView?.speakerButton.setImage(UIImage(named: "IconSpeakerOff" ), for: .normal)
//        case .speaker:
//            currentOutputDevice = .speaker
////            outgoingCallView?.speakerButton.setImage(UIImage(named: "IconSpeakerOn" ), for: .normal)
//        case .headset:
//            currentOutputDevice = .headset
////            outgoingCallView?.speakerButton.setImage(UIImage(named: "headset" ), for: .normal)
//        case .bluetooth:
//            currentOutputDevice = .bluetooth
////            outgoingCallView?.speakerButton.setImage(UIImage(named: "bluetooth_headset" ), for: .normal)
//        @unknown default:
//            currentOutputDevice = .receiver
////            outgoingCallView?.speakerButton.setImage(UIImage(named: "IconSpeakerOff" ), for: .normal)
//        }
//    }
    
    func registerForVOIPNotifications() {
        NSLog("\(Constants.callTag) Registering Voip Notification")
        let pushRegistry = PKPushRegistry(queue: .main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
    }

    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {

        NSLog("\(Constants.callTag) VoIP Token: \(pushCredentials)")
        let deviceTokenString = pushCredentials.token.reduce("") { $0 + String(format: "%02X", $1) }
        NSLog("\(Constants.callTag) #token pushRegistry VT => \(deviceTokenString)")
        NSLog("\(Constants.callTag) device Token \(deviceTokenString)")
        VOIPManager.sharedInstance.saveVOIPToken(token: deviceTokenString)
        Utility.saveInPreference(key: Constants.voipToken, value: deviceTokenString)
        VOIPManager.sharedInstance.updateDeviceToken()
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        let licenseKey = Utility.getStringFromPreference(key: Constants.licenseKey)
        let containerID = Utility.getStringFromPreference(key: Constants.containerID)
        
        NSLog("#VOIP licenseKey \(licenseKey)")
        NSLog("#VOIP containerID \(containerID)")
        
        ChatManager.setAppGroupContainerId(id: containerID)
        ChatManager.initializeSDK(licenseKey: licenseKey) { _, _, _ in }
        
        do {
            try CallManager.initCallSDK()
        }
        catch(let error ) {
            NSLog("\(Constants.callTag) #FlyCall Exception : \(error.localizedDescription)")
        }
        
        
        NSLog("\(Constants.callTag) Push VOIP Received with Payload - %@",payload.dictionaryPayload)
        NSLog("\(Constants.callTag) #callopt \(FlyUtils.printTime()) pushRegistry voip received")

        VOIPManager.sharedInstance.processPayload(payload.dictionaryPayload)
        
    }
    
    func onMissedCall(isOneToOneCall: Bool, userJid: String, groupId: String?, callType: String, userList: [String]) {
        NSLog("\(Constants.callTag) onMissedCall Event Delegate --> isOneToOneCall : \(isOneToOneCall) userJid: \(userJid) groupId: \(String(describing: groupId)) callType: \(callType) userList: \(userList)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userJid, forKey: "userJid")
        jsonObject.setValue(isOneToOneCall, forKey: "isOneToOneCall")
        jsonObject.setValue(groupId, forKey: "groupId")
        jsonObject.setValue(callType, forKey: "callType")
        jsonObject.setValue(userList.joined(separator: ","), forKey: "userList")
        
        let onMissedCallJson = pluginDictToJson(dictionary: jsonObject)
        
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onMissedCallChannel, value: onMissedCallJson)
    }

}

//extension FlyCall : MissedCallNotificationDelegate {
//    func onMissedCall(isOneToOneCall: Bool, userJid: String, groupId: String?, callType: String, userList: [String]) {
//        NSLog("\(Constants.callTag) onMissedCall Event Delegate --> isOneToOneCall : \(isOneToOneCall) userJid: \(userJid) groupId: \(groupId) callType: \(callType) userList: \(userList)")
//        let jsonObject: NSMutableDictionary = NSMutableDictionary()
//        jsonObject.setValue(userJid, forKey: "userJid")
//        jsonObject.setValue(isOneToOneCall, forKey: "isOneToOneCall")
//        jsonObject.setValue(groupId, forKey: "groupId")
//        jsonObject.setValue(callType, forKey: "callType")
//        jsonObject.setValue(userList.joined(separator: ","), forKey: "userList")
//
//        let onMissedCallJson = pluginDictToJson(dictionary: jsonObject)
//
//        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onMissedCallChannel, value: onMissedCallJson)
//    }
//
//
//}

//extension FlyCall : AudioManagerDelegate {
//
//    func audioRoutedTo(deviceName: String, audioDeviceType: MirrorFlySDK.OutputType) {
//        NSLog("#audiomanager audioRoutedTo  CallViewController \(deviceName) \(audioDeviceType)")
//        switch audioDeviceType {
//        case .receiver:
//            currentOutputDevice = .receiver
//        case .speaker:
//            currentOutputDevice = .speaker
//        case .headset:
//            currentOutputDevice = .headset
//        case .bluetooth:
//            currentOutputDevice = .bluetooth
//        @unknown default:
//            currentOutputDevice = .receiver
//        }
//    }
//}
