//
//  FlyCallMethods.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation

let mirrorflyCallMethodChannel = "contus.mirrorfly/flyCall"

@objc class FlyCallMethods : NSObject{
    
    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
        
    func setupMethodChannel(registrar: FlutterPluginRegistrar) {
        methodChannel = FlutterMethodChannel(name: mirrorflyCallMethodChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(self, channel: methodChannel!)
    }
    
    func setupEventChannel(registrar: FlutterPluginRegistrar) {
        eventChannel = FlutterEventChannel(name: "fly_call_events", binaryMessenger: registrar.messenger())
        eventChannel?.setStreamHandler(self)
    }
        
    
}
