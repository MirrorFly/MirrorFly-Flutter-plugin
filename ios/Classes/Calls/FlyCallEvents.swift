//
//  FlyCallEvents.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import Flutter


public class EventStreamHandler: NSObject, FlutterStreamHandler, FlyEventSinkProvider {
    var eventSink: FlutterEventSink?
    
    func setEventSinkValue(_ value: Any?) {
        eventSink?(value)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
