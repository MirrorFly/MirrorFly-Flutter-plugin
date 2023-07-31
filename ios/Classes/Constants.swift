//
//  Constants.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation

struct Constants {
    private static let domain = "contus.mirrorfly"
    static let callMethodChannel = "\(domain)/flyCall"
    static let onCallReceiving = "\(domain)/onCallReceiving"
    static let onLocalVideoTrackAddedChannel = "\(domain)/onLocalVideoTrackAdded"
    static let onRemoteVideoTrackAddedChannel = "\(domain)/onRemoteVideoTrackAdded"
    static let onTrackAddedChannel = "\(domain)/onTrackAdded"
    static let onCallStatusUpdateChannel = "\(domain)/onCallStatusUpdated"
    static let onCallActionChannel = "\(domain)/onCallAction"
    static let onMuteStatusUpdatedChannel = "\(domain)/onMuteStatusUpdated"
    static let onUserSpeakingChannel = "\(domain)/onUserSpeaking"
    static let onUserStoppedSpeakingChannel = "\(domain)/onUserStoppedSpeaking"
    
    static let voipToken = "voipToken"
    static let isLoggedIn = "isLoggedIn"
    static let isProfileSaved = "isProfileSaved"
    static let tag = "#MirrorFlyCall"
    
    static let licenseKey = "licenseKey"
    static let containerID = "containerID"
}
enum CallStatus : String {
    case calling = "Calling";
    case ringing = "Ringing";
    case attended = "Attended";
    case connecting = "Connecting";
    case connected = "Connected";
    case disconnected = "Disconnected"
    case reconnecting = "Reconnecting";
    case reconnected = "Reconnected";
    case tryagain = "Unavailable, Try again later"
    case onHold = "Call on Hold"
}
