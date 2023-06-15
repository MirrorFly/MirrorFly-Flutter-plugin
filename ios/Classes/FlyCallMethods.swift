//
//  FlyCallMethods.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import Flutter
import MirrorFlySDK


@objc class FlyCallMethods : NSObject{
    
    func getCallUsersList(call: FlutterMethodCall, result: @escaping FlutterResult) {
           
        result("Result for 'init' method")
    }
    
    func getAudioDevices(call: FlutterMethodCall, result: @escaping FlutterResult) {
           
    }
    func selectedAudioDevice(call: FlutterMethodCall, result: @escaping FlutterResult) {
           
    }
    func selectAudioDevice(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func makeCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["user_jid"] as? String ?? ""
        
        try! CallManager.makeVoiceCall(jid) { [weak self] (isSuccess , message)  in
           if isSuccess  {
               if(!CallManager.isAudioCallPermissionsGranted()){
                   print("MirrorflyCall Audio call permission not granted")
                   result(FlutterError(code: "500", message: "Microphone Permission not enabled", details: nil))
                   return
               }
               if isSuccess == false {
                   let errorMessage = self?.getErrorMessage(description: message)
                   print("MirroflyCall making call error--->\(errorMessage)")
               }else{
                   print("MirrorflyCall Success -->")
               }
            }
         }
    }
    func makeVideoCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["user_jid"] as? String ?? ""
        
        print("making video call")
        
        if(!CallManager.isAudioCallPermissionsGranted()){
            print("MirrorflyCall Audio call permission not granted")
            result(FlutterError(code: "500", message: "Microphone Permission not enabled", details: nil))
            return
            
        }
        if(!CallManager.isVideoCallPermissionsGranted()){
            print("MirrorflyCall Video call permission not granted")
            result(FlutterError(code: "500", message: "Camera Permission not enabled", details: nil))
            return
        }
        try! CallManager.makeVideoCall(jid) { isSuccess , message in
            print("call result --> \(isSuccess) messsage --> \(message)")
            if (isSuccess){
                print("MirrorflyCall Success")
                result(isSuccess)
            }
        }
        result(true)
    }
    func answerCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func declineCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        CallManager.disconnectCall()
    }
    func muteAudio(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func muteVideo(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isVideoMuted(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isRemoteVideoMuted(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isRemoteVideoPaused(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func makeGroupVideoCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["groupJid"] as? String ?? ""
        let jidList = args["jidList"] as? [String] ?? []
        
        print("***making group call")
        do {
            try CallManager.makeGroupVideoCall(jidList, groupID: groupJid) { (isSuccess, message) in
                
                
                if isSuccess{
                    print("***Make Group Video Call Success")
                }else{
                    print("***Make Group Video Call Failed \(message)")
                }
            }
        }catch(let error ) {
            print("***makeGroupVideoCall Error \(error.localizedDescription)")
        }
        result(true)
    }
    func switchCamera(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isCallOnHold(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isOneToOneCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func getCallType(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isCallConnected(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isVideoCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isAudioCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isCallNotConnected(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isUserAudioMuted(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    func isUserVideoMuted(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    }
    
    
    
    func getErrorMessage(description: String) -> String {
        
        let split = description.components(separatedBy: "ErrorCode")
        let errorMessage = split.isEmpty ? description : split[0]
        return errorMessage
    }
    
}
