//
//  FlyMethods.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import Flutter

class FlyMethodConstants {
    
    static let flyCallMethods = FlyCallMethods()
    static let callMethodHandlers: [String: (FlutterMethodCall, @escaping FlutterResult) -> Void] = {
        return [
            "getCallUsersList": flyCallMethods.getCallUsersList,
            "getAudioDevices": flyCallMethods.getAudioDevices,
            "selectedAudioDevice": flyCallMethods.selectedAudioDevice,
            "selectAudioDevice": flyCallMethods.selectAudioDevice,
            "makeVoiceCall": flyCallMethods.makeCall,
            "makeVideoCall": flyCallMethods.makeVideoCall,
            "answerCall": flyCallMethods.answerCall,
            "declineCall": flyCallMethods.declineCall,
            "muteAudio": flyCallMethods.muteAudio,
            "muteVideo": flyCallMethods.muteVideo,
            "isVideoMuted": flyCallMethods.isVideoMuted,
            "isRemoteVideoMuted": flyCallMethods.isRemoteVideoMuted,
            "isRemoteVideoPaused": flyCallMethods.isRemoteVideoPaused,
            "makeGroupVideoCall": flyCallMethods.makeGroupVideoCall,
            "makeGroupVoiceCall": flyCallMethods.makeGroupVoiceCall,
            "switchCamera": flyCallMethods.switchCamera,
            "isCallOnHold": flyCallMethods.isCallOnHold,
            "isOneToOneCall": flyCallMethods.isOneToOneCall,
            "getCallType": flyCallMethods.getCallType,
            "isCallConnected": flyCallMethods.isCallConnected,
            "isVideoCall": flyCallMethods.isVideoCall,
            "isAudioCall": flyCallMethods.isAudioCall,
            "isCallNotConnected": flyCallMethods.isCallNotConnected,
            "isUserAudioMuted": flyCallMethods.isUserAudioMuted,
            "isUserVideoMuted": flyCallMethods.isUserVideoMuted,
            "inviteUsersToOngoingCall": flyCallMethods.inviteUsersToOngoingCall,
//            "updateTrack": flyCallMethods.updateTrack,
            
        ]
    }()
}
