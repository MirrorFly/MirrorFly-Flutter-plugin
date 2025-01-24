//
//  FlyCall.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import MirrorFlySDK
import Flutter
import PushKit

@objc class FlyCall : NSObject, CallManagerDelegate, FlutterPlugin, PKPushRegistryDelegate, AudioManagerDelegate, MissedCallNotificationDelegate, FlyChatUserDelegate, CallLogDelegate, JoinCallDelegate {
   
    
    var usersInCall: [String: MirrorFlySDK.CALLSTATUS] = [:]
    
    func chatManagerStatus(status: ConnectionStatus) {
        print("--- chatManagerStatus delegate \(status)")
    }
    
    
    var selectedAudioRouteDevice : String = "receiver"
    var isAudioRouteMethodCall : Bool = false
    
    func audioRoutedTo(deviceName: String, audioDeviceType: MirrorFlySDK.OutputType) {
        NSLog("#MirrorflyCall Events: Audio Delegate triggerDelegateForOutputs \(audioDeviceType)")
        
        switch (audioDeviceType) {
        case .bluetooth:
            selectedAudioRouteDevice = "bluetooth"
            break
        case .receiver:
            selectedAudioRouteDevice = "receiver"
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
            jsonObject.setValue(AppUtils.shared.getMyJid(), forKey: "userJid")
            jsonObject.setValue("AUDIO_DEVICE_CHANGED", forKey: "callAction")
            let callUpdate = pluginDictToJson(dictionary: jsonObject)
            self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallActionChannel, value: callUpdate)
        }
        
    }
    
    
    private var methodChannel: FlutterMethodChannel?
    private var registrar: FlutterPluginRegistrar?
    private var eventChannel : FlutterEventChannel?
    //    private var eventChannelInitializer: FlyEventChannelInitializer = FlyEventChannelInitializer()
    private let eventChannelInitializer = FlyEventChannelInitializer.shared
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
        CallManager.callLogDelegate = self
        
        //        AudioManager.sharedInstance.audioManagerDelegate = self
        NSLog("\(Constants.callTag) audioManagerDelegate")
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _ = FlyCall(registrar: registrar)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if (call.method == "selectedAudioDevice"){
            selectedAudioDevice(call: call, result: result)
        }else if (call.method == "disconnectCall"){
            NSLog("\(Constants.callTag) Disconnecting Call")
            NSLog("\(Constants.callTag) clearing Mirrorfly Views in method call")
            let localUserJid = AppUtils.shared.getMyJid()
//             factory?.clearMirrorflyView(userJID: localUserJid)
            factory?.clearAllMirrorflyView()
            CallManager.incomingUserJidArr.removeAll()
            CallManager.disconnectCall()
            /// Call Status Duplicate Handle Code Start
            if isUserExists(userId: localUserJid) {
                usersInCall.removeValue(forKey: localUserJid)
            }
            /// Call Status Duplicate Handle Code End
//            sendLocalHangupDelegate()
            
            result(true)
        }else{
            if (call.method == "makeVoiceCall" || call.method == "makeVideoCall" || call.method == "makeGroupVideoCall" || call.method == "makeGroupVoiceCall"){
                
                if AudioManager.shared().audioManagerDelegate == nil {
                    NSLog("\(Constants.callTag) AudioManager Delegate is Nil, setting new Delegate")
                    AudioManager.shared().audioManagerDelegate = self
                }
                
            }
            if (call.method == "initializeMeet"){
                CallManager.setJoinCallDelegate(delegate: self)
            }
            if let methodHandler = FlyMethodConstants.callMethodHandlers[call.method] {
                NSLog("\(Constants.callTag) Method call \(call.method)")
                methodHandler(call, result, factory)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func sendLocalHangupDelegate() {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(AppUtils.shared.getMyJid(), forKey: "userJid")
        
        
        jsonObject.setValue(CallAction.ACTION_LOCAL_HANGUP.rawValue, forKey: "callAction")
        
        
        if CallManager.isOneToOneCall()  {
            jsonObject.setValue("onetoone", forKey: "callMode")
        }else{
            jsonObject.setValue("onetomany", forKey: "callMode")
        }
        if CallManager.getCallType() == .Audio {
            jsonObject.setValue("audio", forKey: "callType")
        } else {
            jsonObject.setValue("video", forKey: "callType")
        }
        
        let callActionJson = pluginDictToJson(dictionary: jsonObject)
        
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallActionChannel, value: callActionJson)
    }
    
//    
//    func getDisplayName(IncomingUser: [String], incomingUserName: String, metaData: [MirrorFlySDK.CallMetadata]) -> [String] { //) {
//        //    func getDisplayName(IncomingUser: [String]) {
//        var userString = [String]()
//        if isHideNotificationContent{
//            userString.append(APP_NAME)
//        }else{
//            for JID in IncomingUser where JID != AppUtils.shared.getMyJid(){
//                NSLog("#jid \(JID)")
//                if let contact = ChatManager.getContact(jid: JID.lowercased()){
//                    let contactSync = Utility.getBoolFromPreference(key: Constants.contactSyncEnable)
//                    if contactSync{
//                        if contact.contactType == .unknown{
//                            userString.append((try? FlyUtils.getIdFromJid(jid: JID)) ?? "")
//                        }else{
//                            userString.append(getUserName(jid: contact.jid, name: contact.name, nickName: contact.nickName, contactType: contact.contactType))
//                        }
//                    }else{
//                        userString.append(getUserName(jid: contact.jid, name: contact.name, nickName: contact.nickName, contactType: contact.contactType))
//                    }
//                }else {
//                    let pd = ContactManager.shared.saveTempContact(userId: JID)
//                    userString.append(pd?.name ?? "User")
//                }
//            }
//            NSLog("#names \(userString)")
//        }
//        CallManager.getContactNames(IncomingUserName: userString)
//        
//        return userString
//    }
    
    func getDisplayName(IncomingUser: [String], incomingUserName: String, metaData: [MirrorFlySDK.CallMetadata]) -> [String] {
        var userString = [String]()
        let dispatchGroup = DispatchGroup()
        
        if isHideNotificationContent {
            userString.append(APP_NAME)
        } else {
            for JID in IncomingUser where JID != AppUtils.shared.getMyJid() {
                NSLog("#jid \(JID)")
                dispatchGroup.enter()
                getDisplayNameFromServer(JID: JID) { resp in
                    userString.append(contentsOf: resp)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            NSLog("#names \(userString)")
            CallManager.getContactNames(IncomingUserName: userString)
        }
        
        NSLog("#names \(userString)")
        return userString
    }

    private func getDisplayNameFromServer(JID: String, completion: @escaping ([String]) -> Void) {
        var userString = [String]()
        do {
            try ContactManager.shared.getUserProfile(for: JID.lowercased(), fetchFromServer: true, saveAsFriend: true) { isSuccess, flyError, flyData in
                var data = flyData
                let profileData = data.getData() as? ProfileDetails
                
                if isSuccess {
                    userString.append(self.getUserName(jid: profileData?.jid ?? "", name: profileData?.name ?? "", nickName: profileData?.nickName ?? "", contactType: profileData?.contactType ?? .unknown))
                } else {
                    let localDisplayNames = self.getLocalDisplayName(JID: JID)
                    userString.append(contentsOf: localDisplayNames)
                }
                completion(userString)
            }
        } catch {
            let localDisplayNames = self.getLocalDisplayName(JID: JID)
            userString.append(contentsOf: localDisplayNames)
            completion(userString)
        }
    }
    private func getLocalDisplayName(JID : String) -> [String] {
        var userString = [String]()
        if let contact = ChatManager.getContact(jid: JID.lowercased()){
            let contactSync = Utility.getBoolFromPreference(key: Constants.contactSyncEnable)
            if contactSync{
                if contact.contactType == .unknown{
                    userString.append((try? FlyUtils.getIdFromJid(jid: JID)) ?? "")
                }else{
                    userString.append(self.getUserName(jid: contact.jid, name: contact.name, nickName: contact.nickName, contactType: contact.contactType))
                }
            }else{
                userString.append(self.getUserName(jid: contact.jid, name: contact.name, nickName: contact.nickName, contactType: contact.contactType))
            }
        }else {
            let pd = ContactManager.shared.saveTempContact(userId: JID)
            userString.append(pd?.name ?? "User")
        }
        return userString
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
    //This method has been moved inside SDK from latest release
    //    func sendCallMessage(groupCallDetails: MirrorFlySDK.GroupCallDetails, users: [String], invitedUsers: [String]) {
    //        NSLog("#MirrorflyCall send call message group call Details--> \(groupCallDetails)")
    //        NSLog("#MirrorflyCall send call message users--> \(users)")
    //        NSLog("#MirrorflyCall send call message Invited users--> \(invitedUsers)")
    //
    //        try? FlyMessenger.sendCallMessage(for: groupCallDetails, users : users , inviteUsers: invitedUsers) { isSuccess, flyError, flyData in
    //            var data  = flyData
    //            if isSuccess {
    //                NSLog(data.getMessage() as? String ?? "")
    //            } else{
    //                NSLog(data.getMessage() as! String)
    //            }
    //        }
    //    }
    
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
    
    /// Call Status Duplicate Handle Code Start
    func isUserExists(userId: String) -> Bool {
        return usersInCall.keys.contains(userId)
    }
    /// Call Status Duplicate Handle Code End
    
    func onCallStatusUpdated(callStatus: MirrorFlySDK.CALLSTATUS, userId: String) {
        NSLog("#MirrorflyCall Events: Call Status Updated--> \(callStatus.rawValue) userID \(userId)")
        NSLog("#MirrorflyCall Call Status Updated calling--> \(CALLSTATUS.CALLING.rawValue)")
        let userJID = userId
        let selfJID = AppUtils.shared.getMyJid()

        if AudioManager.shared().audioManagerDelegate == nil  && callStatus != .DISCONNECTED{
            NSLog("\(Constants.callTag) AudioManager Delegate is Nil, setting new Delegate @ onCallStatusUpdated")
            AudioManager.shared().audioManagerDelegate = self
        }
        
        /// Call Status Duplicate Handle Code Start
//        if (callStatus == .ATTENDED || callStatus == .CONNECTED || callStatus == .RINGING){
            usersInCall.removeAll()
            usersInCall = CallManager.getCallUsersWithStatus()
            if !isUserExists(userId: selfJID){
                usersInCall[selfJID] = .CONNECTED
            }
            print("\(Constants.callTag) Events: usersInCall: \(usersInCall)")
//        }
        
        
        if(userJID != "" && (callStatus == .DISCONNECTED || callStatus == .CALL_TIME_OUT)){
            NSLog("\(Constants.callTag) clearing Mirrorfly Views")
            self.factory?.clearMirrorflyView(userJID: userJID)
        }else{
            NSLog("\(Constants.callTag) unable to clear Mirrorfly Views \(userJID) callstatus \(callStatus.rawValue)")
        }
        
        if (callStatus == .ATTENDED && userId != selfJID){
            NSLog("\(Constants.callTag) Events: Attended Received for remote user so ignoring it")
            return
        }
        
        if usersInCall.count <= 1 {
            NSLog("\(Constants.callTag) Events: Userlist Have only one user so call will be disconnected already sent so ignoring the status")
            return
        }
        
       
        
        if (callStatus == .DISCONNECTED && !isUserExists(userId: userJID)){
            NSLog("\(Constants.callTag) Events: User status already sent so ignoring the status")
            return
        }
        
        if ((callStatus == .CALL_TIME_OUT || callStatus == .INVITE_CALL_TIME_OUT  || callStatus == .USER_LEFT || callStatus == .DISCONNECTED) && isUserExists(userId: userJID)) {
            NSLog("\(Constants.callTag) Events: User exists so forwarding the status")
            usersInCall.removeValue(forKey: userJID)
        }else if !(callStatus == .CALL_TIME_OUT || callStatus == .INVITE_CALL_TIME_OUT  || callStatus == .USER_LEFT || callStatus == .DISCONNECTED) && !isUserExists(userId: userJID){
            NSLog("\(Constants.callTag) Events: User not exists so adding the user")
            usersInCall[userJID] = .CONNECTED
        }
        /// Call Status Duplicate Handle Code End
        
        //Added to Sync the Call log in Call Status update
        NSLog("\(Constants.callTag) Events: callLogUpdate in status Update")
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallLogUpdateChannel, value: true)
        
        
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
        
        if CallManager.getCallType() == .Audio {
            jsonObject.setValue("audio", forKey: "callType")
        } else {
            jsonObject.setValue("video", forKey: "callType")
        }
        
        let callStatusUpdateJson = pluginDictToJson(dictionary: jsonObject)
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallStatusUpdateChannel, value: callStatusUpdateJson)
        
    }
    
    func onCallAction(callAction: MirrorFlySDK.CallAction, userId: String) {
        NSLog("#MirrorflyCall Events: oncalll Action --> \(callAction.rawValue) userID \(userId)")
        
        ///Work Around till sdk is fixed
        
        if callAction == .ACTION_LOCAL_HANGUP && AppUtils.shared.getMyJid() != userId {
            NSLog("#MirrorflyCall Events: oncalll Action --> \(callAction.rawValue) userID \(userId) :==> rejecting local hangup to send to the user")
            return
        }
        
        if (callAction == .ACTION_REMOTE_BUSY && isUserExists(userId: userId)) {
            NSLog("\(Constants.callTag) Events: User exists in Call Action so forwarding the status")
            usersInCall.removeValue(forKey: userId)
        }
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userId, forKey: "userJid")
        
        
        jsonObject.setValue(callAction.rawValue, forKey: "callAction")
        
        if (callAction == .CHANGE_TO_AUDIO_CALL){
            CallManager.setCallType(callType: .Audio)
            AudioManager.shared().autoReRoute()
        }
        
        if (callAction == .ACTION_VIDEO_CALL_CONVERSION_ACCEPTED){
            CallManager.setCallType(callType: .Video)
            CallManager.muteVideo(false)
            CallManager.enableVideo()
            AudioManager.shared().autoReRoute()
        }
        
        if CallManager.isOneToOneCall()  {
            jsonObject.setValue("onetoone", forKey: "callMode")
        }else{
            jsonObject.setValue("onetomany", forKey: "callMode")
        }
        if CallManager.getCallType() == .Audio {
            jsonObject.setValue("audio", forKey: "callType")
        } else {
            jsonObject.setValue("video", forKey: "callType")
        }
        
        let callActionJson = pluginDictToJson(dictionary: jsonObject)
        
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallActionChannel, value: callActionJson)
        
    }
    
    func onMuteStatusUpdated(muteEvent: MirrorFlySDK.MuteEvent, userId: String) {
        NSLog("#MirrorflyCall Events: onmute status updated --> \(muteEvent) userID \(userId)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userId, forKey: "userJid")
        switch(muteEvent){
        case .ACTION_LOCAL_AUDIO_MUTE:
            jsonObject.setValue("LOCAL_AUDIO_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_REMOTE_VIDEO_MUTE:
            jsonObject.setValue("REMOTE_VIDEO_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_REMOTE_VIDEO_UN_MUTE:
            jsonObject.setValue("REMOTE_VIDEO_UN_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_REMOTE_AUDIO_MUTE:
            jsonObject.setValue("REMOTE_AUDIO_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_REMOTE_AUDIO_UN_MUTE:
            jsonObject.setValue("REMOTE_AUDIO_UN_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_LOCAL_AUDIO_UN_MUTE:
            jsonObject.setValue("LOCAL_AUDIO_UN_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_LOCAL_VIDEO_MUTE:
            jsonObject.setValue("LOCAL_VIDEO_MUTE", forKey: "muteEvent")
            break;
        case .ACTION_LOCAL_VIDEO_UN_MUTE:
            jsonObject.setValue("LOCAL_VIDEO_UN_MUTE", forKey: "muteEvent")
            break;
        @unknown default:
            jsonObject.setValue("unknown", forKey: "muteEvent")
            break;
        }
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: userId, updateType: muteEvent)
            } else {
                // Handle case when view is not found
                NSLog("\(Constants.callTag) \(muteEvent) --> View is not Found")
            }
        } else {
            // Handle case when unique ID is not found
            NSLog("\(Constants.callTag) \(muteEvent) --> Unique ID is not Found")
        }
        
        let muteActionJson = pluginDictToJson(dictionary: jsonObject)
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onMuteStatusUpdatedChannel, value: muteActionJson)
        
    }
    
    func onUserSpeaking(userId: String, audioLevel: Int) {
        
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
        
        //        eventChannelInitializer.sinkValues[Constants.onUserSpeakingChannel] = userId
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onUserStoppedSpeakingChannel, value: userId)
    }
    
    func onLocalVideoTrackAdded(userId: String, videoTrack: RTCVideoTrack) {
        NSLog("#MirrorflyCall Events: onlocal video Track --> \(userId) ---> \(videoTrack)")
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(AppUtils.shared.getMyJid(), forKey: "userJid")
        let jidJson = pluginDictToJson(dictionary: jsonObject)
        
        let videoTrack = CallManager.getRemoteVideoTrack(jid: userId)
        NSLog("\(Constants.callTag) delegate videoTrack--> \(String(describing: videoTrack))")
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: userId, updateType: MuteEvent.ACTION_LOCAL_VIDEO_UN_MUTE)
            } else {
                // Handle case when view is not found
                NSLog("\(Constants.callTag) onLocalVideoTrackAdded --> View is not Found")
            }
        } else {
            // Handle case when unique ID is not found
            NSLog("\(Constants.callTag) onLocalVideoTrackAdded --> Unique ID is not Found")
        }
        
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onLocalVideoTrackAddedChannel, value: jidJson)
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onTrackAddedChannel, value: jidJson)
    }
    
    func onRemoteVideoTrackAdded(userId: String, track: RTCVideoTrack) {
        NSLog("#MirrorflyCall Events: onRemote video Track --> \(userId)")
        NSLog("\(Constants.callTag) isRemoteVideoMuted \(CallManager.isRemoteVideoMuted(userId))")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userId, forKey: "userJid")
        let jidJson = pluginDictToJson(dictionary: jsonObject)
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: userId, updateType: CallManager.isRemoteVideoMuted(userId) ? MuteEvent.ACTION_REMOTE_VIDEO_MUTE : MuteEvent.ACTION_REMOTE_VIDEO_UN_MUTE)
            } else {
                // Handle case when view is not found
            }
        } else {
            // Handle case when unique ID is not found
        }
        
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onRemoteVideoTrackAddedChannel, value: jidJson)
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onTrackAddedChannel, value: jidJson)
    }
    
    
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
        Utility.saveInPreference(key: Constants.voipToken, value: deviceTokenString)
        if Utility.getBoolFromPreference(key: Constants.isLoggedIn) {
            VOIPManager.sharedInstance.saveVOIPToken(token: deviceTokenString)
            VOIPManager.sharedInstance.updateDeviceToken()
        }else{
            NSLog("\(Constants.callTag) Update VOIP Token is skipped due to user is not logged in")
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        let licenseKey = Utility.getStringFromPreference(key: Constants.licenseKey)
        let containerID = Utility.getStringFromPreference(key: Constants.containerID)
        
        NSLog("\(Constants.callTag) #VOIP licenseKey \(licenseKey)")
        NSLog("\(Constants.callTag) #VOIP containerID \(containerID)")
        
        ChatManager.setAppGroupContainerId(id: containerID)
        ChatManager.initializeSDK(licenseKey: licenseKey) { _, _, _ in }
        
        //        do {
        //            try CallManager.initCallSDK()
        //        }
        //        catch(let error ) {
        //            NSLog("\(Constants.callTag) #FlyCall Exception : \(error.localizedDescription)")
        //        }
        
        
        NSLog("\(Constants.callTag) Push VOIP Received with Payload - %@",payload.dictionaryPayload)
        NSLog("\(Constants.callTag) #callopt \(FlyUtils.printTime()) pushRegistry voip received")
        
        VOIPManager.sharedInstance.processPayload(payload.dictionaryPayload)
        
    }
    
    func onMissedCall(isOneToOneCall: Bool, userJid: String, groupId: String?, callType: String, userList: [String], metaData: [MirrorFlySDK.CallMetadata], permissionDenied: Bool) {
        
        NSLog("\(Constants.callTag) Events: onMissedCall Event Delegate --> isOneToOneCall : \(isOneToOneCall) userJid: \(userJid) groupId: \(String(describing: groupId)) callType: \(callType) userList: \(userList)")
        NSLog("\(Constants.callTag) Events: FlyConstants.isLoaclNotificationEnabled \(FlyConstants.isLoaclNotificationEnabled)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userJid, forKey: "userJid")
        jsonObject.setValue(isOneToOneCall, forKey: "isOneToOneCall")
        jsonObject.setValue(groupId, forKey: "groupId")
        if callType == "audio call"{
            jsonObject.setValue("audio", forKey: "callType")
        }else if callType == "video call"{
            jsonObject.setValue("video", forKey: "callType")
        }else{
            jsonObject.setValue("", forKey: "callType")
        }
        
        jsonObject.setValue(userList.joined(separator: ","), forKey: "userList")
        
        let onMissedCallJson = pluginDictToJson(dictionary: jsonObject)
        
        //Added to Sync the Call log in Missed call Event
        NSLog("\(Constants.callTag) Events: callLogUpdate in onMissedCall")
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallLogUpdateChannel, value: true)
        
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onMissedCallChannel, value: onMissedCallJson)
    }
    
    func clearAllCallLog() {
        NSLog("\(Constants.callTag) clearAllCallLog")
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.clearAllCallLogChannel, value: true)
    }
    
    func deleteCallLogs(callLogId: String) {
        NSLog("\(Constants.callTag) deleteCallLogs")
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallLogDeletedChannel, value: callLogId)
    }
    
    
    func onCallLogsUpdated() {
        NSLog("\(Constants.callTag) Events: callLogUpdate")
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallLogUpdateChannel, value: true)
    }
    
    func userProfileDidChange(for jid: String, profileDetails: MirrorFlySDK.ProfileDetails) {
        NSLog("\(Constants.callTag) Fly Call userProfileDidChange")
    }
    
    ///Meet delegates
    
    func onSubscribeSuccess() {
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onSubscribeSuccess, value: true)
    }
    
    func onUsersUpdated(usersList: [String]) {
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onUsersUpdated, value: usersList.toJson())
    }
    
    func onLocalTrack(videoTrack: RTCVideoTrack?) {
        let currentJid = AppUtils.shared.getMyJid()
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(currentJid, forKey: "userJid")
        let jidJson = pluginDictToJson(dictionary: jsonObject)
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: currentJid) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updatePreviewVideoTrack(track: videoTrack, updateType: MuteEvent.ACTION_LOCAL_VIDEO_UN_MUTE)
            } else {
                // Handle case when view is not found
                NSLog("\(Constants.callTag) onLocalVideoTrackAdded --> View is not Found")
            }
        } else {
            // Handle case when unique ID is not found
            NSLog("\(Constants.callTag) onLocalVideoTrackAdded --> Unique ID is not Found")
        }
        
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onLocalVideoTrackAddedChannel, value: jidJson)
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onTrackAddedChannel, value: jidJson)
    }
    
    func onError(reason: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue("500", forKey: "code")
        jsonObject.setValue(reason, forKey: "description")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onError, value: jsonString)
    }
    
}

