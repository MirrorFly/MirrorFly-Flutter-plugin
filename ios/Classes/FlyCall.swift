//
//  FlyCall.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation

@objc class FlyCall : NSObject{
    
    private var methodChannel: FlutterMethodChannel?
    
    var onCallReceivingStreamHandler: OnCallReceivingStreamHandler?
    
    init(registrar: FlutterPluginRegistrar) {
        super.init()
        
        methodChannel = FlutterMethodChannel(name: Constants.callMethodChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(self, channel: methodChannel!)
        
        setupCallEventChannel(registrar: registrar)
        
    }
        
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let methodHandler = FlyMethods.callMethodHandlers[methodCall.method] {
            methodHandler(result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func setupCallEventChannel(registrar: FlutterPluginRegistrar) {
        
        if (self.onCallReceivingStreamHandler == nil) {
            self.onCallReceivingStreamHandler = OnCallReceivingStreamHandler()
        }
        FlutterEventChannel(name: Constants.onCallReceiving, binaryMessenger: registrar.messenger()).setStreamHandler(self.onCallReceivingStreamHandler)
        
    }
    
    
}
