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
    
    var onCallReceivingStreamHandler: OnCallReceivingStreamHandler?
    
    init(registrar: FlutterPluginRegistrar) {
        super.init()
        
        self.registrar = registrar
        methodChannel = FlutterMethodChannel(name: Constants.callMethodChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(self, channel: methodChannel!)
        
        let factory = MirrorflyViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "mirrorfly_view")
        
        setupCallEventChannel(registrar: registrar)
        
        CallManager.setCallEventsDelegate(delegate: self)
        
    }
    
    // FlutterPlugin methods
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = FlyCall(registrar: registrar)
    }
        
//    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        if let methodHandler = FlyMethods.callMethodHandlers[methodCall.method] {
//            methodHandler(call, result)
//        } else {
//            result(FlutterMethodNotImplemented)
//        }
//    }
    
    func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if let methodHandler = FlyMethods.callMethodHandlers[call.method] {
            methodHandler(call, result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func setupCallEventChannel(registrar: FlutterPluginRegistrar) {
        
        if (self.onCallReceivingStreamHandler == nil) {
            self.onCallReceivingStreamHandler = OnCallReceivingStreamHandler()
        }
        FlutterEventChannel(name: Constants.onCallReceiving, binaryMessenger: registrar.messenger()).setStreamHandler(self.onCallReceivingStreamHandler as? NSObjectProtocol & FlutterStreamHandler)
                
//        let onCallReceivingStreamHandler = OnCallReceivingStreamHandler()
//        self.eventChannel?.setStreamHandler(onCallReceivingStreamHandler as? NSObjectProtocol & FlutterStreamHandler)
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
        
    }
    
    func onCallAction(callAction: MirrorFlySDK.CallAction, userId: String) {
        
    }
    
    func onLocalVideoTrackAdded(userId: String, videoTrack: RTCVideoTrack) {
        
    }
    
    func onRemoteVideoTrackAdded(userId: String, track: RTCVideoTrack) {
        
    }
    
    func onMuteStatusUpdated(muteEvent: MirrorFlySDK.MuteEvent, userId: String) {
        
    }
    
    func onUserSpeaking(userId: String, audioLevel: Int) {
        
    }
    
    func onUserStoppedSpeaking(userId: String) {
        
    }
}
