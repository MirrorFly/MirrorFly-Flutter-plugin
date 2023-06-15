//
//  FlyCallEvents.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import Flutter

public class OnCallReceivingStreamHandler: FlutterStreamHandler {
    public var onCallReceived: FlutterEventSink?
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.onCallReceived = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.onCallReceived = nil
        return nil
    }
    
}
