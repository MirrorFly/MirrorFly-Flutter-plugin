//
//  FlyCall.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import MirrorFlySDK
import Flutter

@objc class FlyCall : NSObject, CallManagerDelegate, FlutterPlugin{
    
    
    
    private var methodChannel: FlutterMethodChannel?
    private var registrar: FlutterPluginRegistrar?
    private var eventChannel : FlutterEventChannel?
    private var eventChannelInitializer: FlyEventChannelInitializer = FlyEventChannelInitializer()
    
    init(registrar: FlutterPluginRegistrar) {
        super.init()
        
        self.registrar = registrar
        methodChannel = FlutterMethodChannel(name: Constants.callMethodChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(self, channel: methodChannel!)
        
        let factory = MirrorflyViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "mirrorfly_view")
        
        eventChannelInitializer.initializeEventChannels(registrar: registrar)
        
        CallManager.setCallEventsDelegate(delegate: self)
        
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _ = FlyCall(registrar: registrar)
    }
        
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let methodHandler = FlyMethodConstants.callMethodHandlers[call.method] {
            methodHandler(call, result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    func getDisplayName(IncomingUser: [String]) {
        
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
        jsonObject.setValue(callStatus.rawValue, forKey: "callStatus")
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
        eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallStatusUpdateChannel, value: callUpdate)
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
        print("#MirroflyCall onlocal video Track --> \(userId)")
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(FlyDefaults.myJid, forKey: "userJid")
        var jidJson = pluginDictToJson(dictionary: jsonObject)
        
        eventChannelInitializer.sinkValues[Constants.onTrackAddedChannel] = jidJson
    }
    
    func onRemoteVideoTrackAdded(userId: String, track: RTCVideoTrack) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(FlyDefaults.myJid, forKey: "userJid")
        var jidJson = pluginDictToJson(dictionary: jsonObject)
        
        eventChannelInitializer.sinkValues[Constants.onTrackAddedChannel] = jidJson
    }
    
    
}
