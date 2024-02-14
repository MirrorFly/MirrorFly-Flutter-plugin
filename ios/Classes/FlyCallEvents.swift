//
//  FlyCallEvents.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import Flutter


public class EventStreamHandler: NSObject, FlutterStreamHandler, FlyEventSinkProvider {
    var eventSink: FlutterEventSink?
    private var eventSinkValue: Any?
    
    func setEventSinkValue(_ value: Any?) {
        self.eventSinkValue = value
        eventSink?(value)
        updateEventSinkValue()
    }
    
    private func updateEventSinkValue() {
        eventSink?(eventSinkValue)
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
