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
    static let onCallAction = "\(domain)/onCallAction"
    static let onMuteStatusUpdated = "\(domain)/onMuteStatusUpdated"
    static let onUserSpeaking = "\(domain)/onUserSpeaking"
    static let onUserStoppedSpeaking = "\(domain)/onUserStoppedSpeaking"
    
    
    static let isLoggedIn = "isLoggedIn"
    static let isProfileSaved = "isProfileSaved"
}
