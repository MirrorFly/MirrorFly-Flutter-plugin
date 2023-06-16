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
        (channelName: Constants.onCallReceiving, streamHandler: OnCallReceivingStreamHandler()),
        (channelName: Constants.onLocalVideoTrackAddedChannel, streamHandler: OnLocalVideoTrackAddedStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnRemoteVideoTrackAddedStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnTrackAddedStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnCallStatusUpdatedStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnCallActionStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnMuteStatusUpdatedStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnUserSpeakingStreamHandler()),
        (channelName: Constants.onRemoteVideoTrackAddedChannel, streamHandler: OnUserStoppedSpeakingStreamHandler()),
    ]
    var sinkValues: [String: String] = [:]
    
    func initializeEventChannels(registrar: FlutterPluginRegistrar) {
        for (channelName, streamHandler) in FlyEventChannelInitializer.eventChannels {
                var handler: (NSObjectProtocol & FlutterStreamHandler)? = streamHandler
            
                FlutterEventChannel(name: channelName, binaryMessenger: registrar.messenger()).setStreamHandler(handler)
            }
        }
    
    func updateSinkValue(forChannel channelName: String, value: String?) {
        guard let streamHandler = FlyEventChannelInitializer.eventChannels.first(where: { $0.channelName == channelName })?.streamHandler else {
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

