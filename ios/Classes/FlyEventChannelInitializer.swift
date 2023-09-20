//
//  FlyEventChannelConstants.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 16/06/23.
//

import Foundation
import Flutter



class FlyEventChannelInitializer {
    static let eventChannels: [(channelName: String, streamHandler: NSObjectProtocol & FlutterStreamHandler)] = [
//         (channelName: Constants.onCallReceiving, streamHandler: OnCallReceivingStreamHandler()),
        (channelName: Constants.onLocalVideoTrackAddedChannel, streamHandler: OnLocalVideoTrackAddedStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnRemoteVideoTrackAddedStreamHandler()),
        (channelName: Constants.onTrackAddedChannel, streamHandler: OnTrackAddedStreamHandler()),
        (channelName: Constants.onCallStatusUpdateChannel, streamHandler: OnCallStatusUpdatedStreamHandler()),
        (channelName: Constants.onCallActionChannel, streamHandler: OnCallActionStreamHandler()),
        (channelName: Constants.onMuteStatusUpdatedChannel, streamHandler: OnMuteStatusUpdatedStreamHandler()),
        (channelName: Constants.onUserSpeakingChannel, streamHandler: OnUserSpeakingStreamHandler()),
        (channelName: Constants.onUserStoppedSpeakingChannel, streamHandler: OnUserStoppedSpeakingStreamHandler()),
        (channelName: Constants.onMissedCallChannel, streamHandler: OnMissedCallStreamHandler()),
    ]
    var sinkValues: [String: String] = [:]
    
    func initializeEventChannels(registrar: FlutterPluginRegistrar) {
        for (channelName, streamHandler) in FlyEventChannelInitializer.eventChannels {
                let handler: (NSObjectProtocol & FlutterStreamHandler)? = streamHandler
            
                FlutterEventChannel(name: channelName, binaryMessenger: registrar.messenger()).setStreamHandler(handler)
            }
        }
    
    func updateSinkValue(forChannel channelName: String, value: String?) {
        guard let streamHandler = FlyEventChannelInitializer.eventChannels.first(where: { $0.channelName == channelName })?.streamHandler else {
                print("#MirrorflyCall else condition")
               return
           }
           
           if let provider = streamHandler as? FlyEventSinkProvider {
               provider.setEventSinkValue(value)
           }
       }
}

protocol FlyEventSinkProvider {
    func setEventSinkValue(_ value: String?)
}

