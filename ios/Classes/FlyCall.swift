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

@objc class FlyCall : NSObject, CallManagerDelegate, FlutterPlugin, AudioManagerDelegate, PKPushRegistryDelegate{
    
    private var methodChannel: FlutterMethodChannel?
    private var registrar: FlutterPluginRegistrar?
    private var eventChannel : FlutterEventChannel?
    private var eventChannelInitializer: FlyEventChannelInitializer = FlyEventChannelInitializer()
    private var factory : MirrorflyViewFactory?
    
    var currentOutputDevice : OutputType = .receiver
    
    init(registrar: FlutterPluginRegistrar) {
        super.init()
        
        self.registrar = registrar
        methodChannel = FlutterMethodChannel(name: Constants.callMethodChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(self, channel: methodChannel!)
        
        factory = MirrorflyViewFactory(messenger: registrar.messenger())
        registrar.register(factory!, withId: "mirrorfly_view")
        
        eventChannelInitializer.initializeEventChannels(registrar: registrar)
        
        AudioManager.shared().audioManagerDelegate = self
        
        CallManager.setCallEventsDelegate(delegate: self)
        
        registerForVOIPNotifications()
        
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _ = FlyCall(registrar: registrar)
    }
        
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let methodHandler = FlyMethodConstants.callMethodHandlers[call.method] {
            print("\(Constants.tag) Method call \(call.method)")
            methodHandler(call, result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    func getDisplayName(IncomingUser: [String]) {
        var userString = [String]()
        if FlyDefaults.hideNotificationContent{
            userString.append(FlyDefaults.appName)
        }else{
            for JID in IncomingUser where JID != FlyDefaults.myJid{
                print("#jid \(JID)")
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
            print("#names \(userString)")
        }
        CallManager.getContactNames(IncomingUserName: userString)
    }
    
    func getUserName(jid : String, name : String , nickName : String, contactType : ContactType) -> String {
        FlyUtils.getUserName(jid: jid, name: name, nickName: nickName, contactType: contactType)
    }
    
    func getGroupName(_ groupId: String) {
        
    }
    
    func sendCallMessage(groupCallDetails: MirrorFlySDK.GroupCallDetails, users: [String], invitedUsers: [String]) {
        print("#MirroflyCall send call message group call Details--> \(groupCallDetails)")
        print("#MirroflyCall send call message users--> \(users)")
        print("#MirroflyCall send call message Invited users--> \(invitedUsers)")
        
        try? FlyMessenger.sendCallMessage(for: groupCallDetails, users : users , inviteUsers: invitedUsers) { isSuccess, flyError, flyData in
            var data  = flyData
            if isSuccess {
                print(data.getMessage() as? String ?? "")
            } else{
                print(data.getMessage() as! String)
            }
        }
    }
    
    func socketConnectionEstablished() {
        
    }
    
    func onCallStatusUpdated(callStatus: MirrorFlySDK.CALLSTATUS, userId: String) {
        print("#MirroflyCall Call Status Updated--> \(callStatus.rawValue) userID \(userId)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        if (callStatus.rawValue == "CALL TIME OUTt"){
            jsonObject.setValue("CALL TIME OUT", forKey: "callStatus")
        }else{
            jsonObject.setValue(callStatus.rawValue, forKey: "callStatus")
        }
        jsonObject.setValue(userId, forKey: "userJid")
        
        if CallManager.isOneToOneCall()  {
            jsonObject.setValue("OneToOne", forKey: "callMode")
        }else{
            jsonObject.setValue("GroupCall", forKey: "callMode")
        }
        
        if(callStatus.rawValue == "Attended"){
            
            if CallManager.getCallType() == .Audio {
                jsonObject.setValue("audio", forKey: "callType")
            } else {
                jsonObject.setValue("video", forKey: "callType")
            }
        }
        
        let callUpdate = pluginDictToJson(dictionary: jsonObject)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallStatusUpdateChannel, value: callUpdate)
//        }
        
    }
    
    func onCallAction(callAction: MirrorFlySDK.CallAction, userId: String) {
        print("#MirroflyCall Event oncalll Action --> \(callAction) userID \(userId)")
    }
    
    func onMuteStatusUpdated(muteEvent: MirrorFlySDK.MuteEvent, userId: String) {
        print("#MirroflyCall Event onmute status updated --> \(muteEvent) userID \(userId)")
    }
    
    func onUserSpeaking(userId: String, audioLevel: Int) {
        print("#MirroflyCall user speaking --> \(userId) audioLevel \(audioLevel)")
    }
    
    func onUserStoppedSpeaking(userId: String) {
        print("#MirroflyCall user stopped speaking --> \(userId)")
    }
    
    func onLocalVideoTrackAdded(userId: String, videoTrack: RTCVideoTrack) {
        print("\(Constants.tag) onlocal video Track --> \(userId) ---> \(videoTrack)")
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(FlyDefaults.myJid, forKey: "userJid")
        var jidJson = pluginDictToJson(dictionary: jsonObject)
        
//        if let mirrorflyView = MirrorflyViewFactory.mirrorflyViews[viewId] {
//                            mirrorflyView.updateVideoTrack(userJid: userJid)
//                            result(nil)
//                        } else {
//                            result(FlutterError(code: "INVALID_VIEW_ID", message: "Invalid view identifier", details: nil))
//                        }
        
        let videoTrack = CallManager.getRemoteVideoTrack(jid: userId)
        print("\(Constants.tag) delegate videoTrack--> \(String(describing: videoTrack))")
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: userId)
            } else {
                // Handle case when view is not found
                print("\(Constants.tag) onLocalVideoTrackAdded --> View is not Found")
            }
        } else {
            // Handle case when unique ID is not found
            print("\(Constants.tag) onLocalVideoTrackAdded --> Unique ID is not Found")
        }
        
        eventChannelInitializer.sinkValues[Constants.onTrackAddedChannel] = jidJson
    }
    
    func onRemoteVideoTrackAdded(userId: String, track: RTCVideoTrack) {
        print("\(Constants.tag) onRemote video Track --> \(userId)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userId, forKey: "userJid")
        let jidJson = pluginDictToJson(dictionary: jsonObject)
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: userId) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: userId)
            } else {
                // Handle case when view is not found
            }
        } else {
            // Handle case when unique ID is not found
        }

        eventChannelInitializer.sinkValues[Constants.onTrackAddedChannel] = jidJson
    }
    
    func audioRoutedTo(deviceName: String, audioDeviceType: MirrorFlySDK.OutputType) {
        print("#audiomanager audioRoutedTo  CallViewController \(deviceName) \(audioDeviceType)")
        switch audioDeviceType {
        case .receiver:
            currentOutputDevice = .receiver
//            outgoingCallView?.speakerButton.setImage(UIImage(named: "IconSpeakerOff" ), for: .normal)
        case .speaker:
            currentOutputDevice = .speaker
//            outgoingCallView?.speakerButton.setImage(UIImage(named: "IconSpeakerOn" ), for: .normal)
        case .headset:
            currentOutputDevice = .headset
//            outgoingCallView?.speakerButton.setImage(UIImage(named: "headset" ), for: .normal)
        case .bluetooth:
            currentOutputDevice = .bluetooth
//            outgoingCallView?.speakerButton.setImage(UIImage(named: "bluetooth_headset" ), for: .normal)
        @unknown default:
            currentOutputDevice = .receiver
//            outgoingCallView?.speakerButton.setImage(UIImage(named: "IconSpeakerOff" ), for: .normal)
        }
    }
    
    func registerForVOIPNotifications() {
        NSLog("\(Constants.tag) Registering Voip Notification")
        let pushRegistry = PKPushRegistry(queue: .main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
    }

    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {

        NSLog("\(Constants.tag) VoIP Token: \(pushCredentials)")
        let deviceTokenString = pushCredentials.token.reduce("") { $0 + String(format: "%02X", $1) }
        NSLog("\(Constants.tag) #token pushRegistry VT => \(deviceTokenString)")
        print("\(Constants.tag) device Token \(deviceTokenString)")
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
            print("\(Constants.tag) #FlyCall Exception : \(error.localizedDescription)")
        }
        
        
        NSLog("\(Constants.tag) Push VOIP Received with Payload - %@",payload.dictionaryPayload)
        NSLog("\(Constants.tag) #callopt \(FlyUtils.printTime()) pushRegistry voip received")

        VOIPManager.sharedInstance.processPayload(payload.dictionaryPayload)
        
    }

}
