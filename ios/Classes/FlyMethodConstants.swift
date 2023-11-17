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
    static let callMethodHandlers: [String: (FlutterMethodCall, @escaping FlutterResult, MirrorflyViewFactory?) -> Void] = {
        return [
            "getCallUsersList": flyCallMethods.getCallUsersList,
            "getAudioDevices": flyCallMethods.getAudioDevices,
//            "selectedAudioDevice": flyCallMethods.selectedAudioDevice,
            "selectAudioDevice": flyCallMethods.selectAudioDevice,
            "makeVoiceCall": flyCallMethods.makeCall,
            "makeVideoCall": flyCallMethods.makeVideoCall,
            "answerCall": flyCallMethods.answerCall,
            "declineCall": flyCallMethods.declineCall,
            "muteAudio": flyCallMethods.muteAudio,
            "isVideoMuted": flyCallMethods.isVideoMuted,
            "isRemoteVideoMuted": flyCallMethods.isRemoteVideoMuted,
            "isRemoteVideoPaused": flyCallMethods.isRemoteVideoPaused,
            "makeGroupVideoCall": flyCallMethods.makeGroupVideoCall,
            "makeGroupVoiceCall": flyCallMethods.makeGroupVoiceCall,
            "switchCamera": flyCallMethods.switchCamera,
            "isCallOnHold": flyCallMethods.isCallOnHold,
            "isOneToOneCall": flyCallMethods.isOneToOneCall,
            "getCallType": flyCallMethods.getCallType,
            "getGroupID": flyCallMethods.getGroupID,
            "isCallConnected": flyCallMethods.isCallConnected,
            "isVideoCall": flyCallMethods.isVideoCall,
            "isAudioCall": flyCallMethods.isAudioCall,
            "isCallNotConnected": flyCallMethods.isCallNotConnected,
            "isUserAudioMuted": flyCallMethods.isUserAudioMuted,
            "isUserVideoMuted": flyCallMethods.isUserVideoMuted,
            "inviteUsersToOngoingCall": flyCallMethods.inviteUsersToOngoingCall,
            "getCallDirection": flyCallMethods.getCallDirection,
            "getAllAvailableAudioInput": flyCallMethods.getAllAvailableAudioInput,
            "routeAudioTo": flyCallMethods.routeAudioTo,
            "isOnGoingCall": flyCallMethods.isOnGoingCall,
//            "disconnectCall": flyCallMethods.disconnectCall,
            "muteVideo": flyCallMethods.muteVideo,
            "getUnreadMissedCallCount": flyCallMethods.getUnreadMissedCallCount,
            "requestVideoCallSwitch": flyCallMethods.requestVideoCallSwitch,
            "cancelVideoCallSwitch": flyCallMethods.cancelVideoCallSwitch,
            "acceptVideoCallSwitchRequest": flyCallMethods.acceptVideoCallSwitchRequest,
            "declineVideoCallSwitchRequest": flyCallMethods.declineVideoCallSwitchRequest,
            "getMaxCallUsersCount": flyCallMethods.getMaxCallUsersCount,
            "getInvitedUsersList": flyCallMethods.getInvitedUsersList,
//            "changeCallType": flyCallMethods.changeCallType,
//            "reRouteAudio": flyCallMethods.reRouteAudio,
            
        ]
    }()
}
