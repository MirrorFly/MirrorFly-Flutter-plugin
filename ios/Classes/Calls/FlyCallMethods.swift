//
//  FlyCallMethods.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import Flutter
import MirrorFlySDK


@objc class FlyCallMethods : NSObject{

    static let shared = FlyCallMethods()

    let tag = "#MirrorFlyCall"
    let callLogManager = CallLogManager()
    var callLogArray = [CallLog]()
    
    /// A token for the observer, used to manage and remove the observer when no longer needed.
    var observerToken: NSObjectProtocol?
    
    /// Singleton instance of FlyEventChannelInitializer, used to initialize and manage event channels.
    private let eventChannelInitializer = FlyEventChannelInitializer.shared
    
    private var factory : MirrorflyViewFactory?
    
    /// This boolean indicates whether to check for the XMPP connection before making a call.
    /// This feature ensures that a call is made only after the server is reconnected during permission popups.
    let checkXMPPConnection = true
    
    var meetLinkServerObserverToken: NSObjectProtocol?
    
    
    func getCallUsersList(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
        var jsonArray: [[String: Any]] = []
        
        let currentUserJid = AppUtils.shared.getMyJid()
        
        for (memberJid,status) in CallManager.getCallUsersWithStatus() {
            NSLog("\(tag) processing user list \(memberJid) \(status)")
            if memberJid == currentUserJid {
                NSLog("\(tag) processing user list Skipped jid \(memberJid), as we are adding locally after the iteration")
                continue
            }
            let jsonObject: [String: Any] = [
                "userJid": memberJid,
                "callStatus": status.rawValue,
                "isAudioMuted" : CallManager.isRemoteAudioMuted(memberJid),
                "isVideoMuted" : CallManager.isRemoteVideoMuted(memberJid)
            ]
            NSLog("#MirrorflyCall Call Status Updated--> Appending CallUsersList \(jsonObject)")
            jsonArray.append(jsonObject)
        }
        
        let localJIDJson: [String: Any] = [
            "userJid": currentUserJid,
            "callStatus": CallManager.getCallDirection() == .Incoming ? (CallManager.isCallConnected() ? "Connected" : "Connecting") : (CallManager.isCallConnected() ? "Connected" : "Calling"),
            "isAudioMuted" : CallManager.isAudioMuted(),
            "isVideoMuted" : CallManager.isVideoMuted()
        ]
        
        jsonArray.append(localJIDJson)
        
        
        let userListJson = convertArrayToJSONString(array: jsonArray)
        NSLog("\(tag) getCallUsersWithStatus \(String(describing: userListJson))")
        result(userListJson)
    }
    
    func muteVideo(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let muteStatus = args["muteVideo"] as? Bool ?? false
        NSLog("\(Constants.callTag) muteVideo Method MuteStatus \(muteStatus)")
        CallManager.muteVideo(muteStatus)
        
        
        if !CallManager.isOneToOneCall() && !muteStatus{
            CallManager.setCallType(callType: .Video)
            CallManager.enableVideo()
        }else if !CallManager.isOneToOneCall() && muteStatus{
            CallManager.setCallType(callType: .Audio)
            CallManager.disableVideo()
        }
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: AppUtils.shared.getMyJid()) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: AppUtils.shared.getMyJid(), updateType: muteStatus ? MuteEvent.ACTION_LOCAL_VIDEO_MUTE : MuteEvent.ACTION_LOCAL_VIDEO_UN_MUTE)
            } else {
                NSLog("\(Constants.callTag) ACTION_LOCAL_VIDEO_MUTE --> View is not Found")
            }
        } else {
            NSLog("\(Constants.callTag) ACTION_LOCAL_VIDEO_MUTE --> Unique ID is not Found")
        }
        AudioManager.shared().autoReRoute()
        result(true)
    }
    
    func getAudioDevices(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    
    func makeVoiceCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["user_jid"] as? String ?? ""
        
        if(!CallManager.isAudioCallPermissionsGranted()){
            NSLog("#CALL CHECK MirrorflyCall Audio call permission not granted")
            result(FlutterError(code: FLErrorCode.PERMISSION_NOT_GRANTED, message: FLErrorMessage.MICROPHONE_PERMISSION_NOT_ENABLED, details: nil))
            return
        }
        if checkXMPPConnection {
            result(true)
            
            guard ChatManager.isChatServerConnected() else {
                print("#CALL CHECK isChatServerConnected false")
                addObserverForConnectionStatus(jid: jid, callType: "voice")
                return
            }
            
            print("#CALL CHECK isChatServerConnected true")
            initiateVoiceCall(jid: jid)
        }else{
            try! CallManager.makeVoiceCall(jid) { isSuccess, flyError in
                if isSuccess {
                    print("#CALL CHECK make call success")
                    result(isSuccess)
                } else {
                    let errorMessage = flyError?.localizedDescription
                    NSLog("MirroflyCall making call error--->\(errorMessage ?? "make voice call error")")
                    
                    result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.CALL_FAILED_MESSAGE, details: errorMessage))
                    
                }
            }
        }
    }
    
    func makeVideoCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["user_jid"] as? String ?? ""
        NSLog("making video call")
        
        if(!CallManager.isAudioCallPermissionsGranted()){
            NSLog("MirrorflyCall Audio call permission not granted")
            result(FlutterError(code: FLErrorCode.PERMISSION_NOT_GRANTED, message: FLErrorMessage.MICROPHONE_PERMISSION_NOT_ENABLED, details: nil))
            return
            
        }
        if(!CallManager.isVideoCallPermissionsGranted()){
            NSLog("MirrorflyCall Video call permission not granted")
            result(FlutterError(code: FLErrorCode.PERMISSION_NOT_GRANTED, message: FLErrorMessage.CAMERA_PERMISSION_NOT_ENABLED, details: nil))
            return
        }
        
        if checkXMPPConnection {
            result(true)
            
            guard ChatManager.isChatServerConnected() else {
                print("#CALL CHECK isChatServerConnected false")
                addObserverForConnectionStatus(jid: jid, callType: "video")
                return
            }
            self.initiateVideoCall(jid: jid)
        }else{
            
            try! CallManager.makeVideoCall(jid) { isSuccess , flyError in
                NSLog("call result --> \(isSuccess) messsage --> \(String(describing: flyError))")
                if (isSuccess){
                    result(isSuccess)
                }else{
                    let errorMessage = flyError?.localizedDescription
                    NSLog("MirroflyCall making call error--->\(errorMessage ?? "make voice call error")")
                    result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.CALL_FAILED_MESSAGE, details: errorMessage))
                    
                }
            }
        }
        
    }
    
    func declineCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        NSLog("\(Constants.callTag) declineCall")
        NSLog("\(Constants.callTag) clearing Mirrorfly Views in method call")
        factory?.clearMirrorflyView(userJID: AppUtils.shared.getMyJid())
        CallManager.incomingUserJidArr.removeAll()
        CallManager.disconnectCall()
        result(true)
        
    }
    func muteAudio(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let muteStatus = args["muteAudio"] as? Bool ?? false
        CallManager.muteAudio(muteStatus)
        NSLog("\(Constants.callTag) Calling the Audio Delegate")
        result(true)
    }
    
    func makeGroupVideoCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["groupJid"] as? String ?? ""
        let jidList = args["jidList"] as? [String] ?? []
        
        if(!CallManager.isAudioCallPermissionsGranted()){
            NSLog("MirrorflyCall Audio call permission not granted")
            result(FlutterError(code: FLErrorCode.PERMISSION_NOT_GRANTED, message: FLErrorMessage.MICROPHONE_PERMISSION_NOT_ENABLED, details: nil))
            return
            
        }
        if(!CallManager.isVideoCallPermissionsGranted()){
            NSLog("MirrorflyCall Video call permission not granted")
            result(FlutterError(code: FLErrorCode.PERMISSION_NOT_GRANTED, message: FLErrorMessage.CAMERA_PERMISSION_NOT_ENABLED, details: nil))
            return
        }
        
        if checkXMPPConnection {
            result(true)
            
            guard ChatManager.isChatServerConnected() else {
                print("#CALL CHECK isChatServerConnected false")
                addObserverForConnectionStatus(jidList: jidList, groupJid: groupJid, callType: "video")
                return
            }
            self.initiateGroupVideoCall(jidList: jidList, groupJid: groupJid)
        }else{
            
            do {
                try CallManager.makeGroupVideoCall(jidList, groupID: groupJid) { isSuccess, flyError in
                    
                    if isSuccess{
                        NSLog("***Make Group Video Call Success")
                        result(true)
                    }else{
                        let errorMessage = flyError?.localizedDescription
                        NSLog("MirroflyCall Group Video Call error--->\(String(describing: errorMessage))")
                        result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.CALL_FAILED_MESSAGE, details: errorMessage))
                    }
                }
            }catch(let error ) {
                NSLog("***makeGroupVideoCall Error \(error.localizedDescription)")
                result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.CALL_FAILED_MESSAGE, details: error.localizedDescription))
            }
        }
        
    }
    
    func makeGroupVoiceCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["groupJid"] as? String ?? ""
        let jidList = args["jidList"] as? [String] ?? []
        
        if(!CallManager.isAudioCallPermissionsGranted()){
            NSLog("MirrorflyCall Audio call permission not granted")
            result(FlutterError(code: FLErrorCode.PERMISSION_NOT_GRANTED, message: FLErrorMessage.MICROPHONE_PERMISSION_NOT_ENABLED, details: nil))
            return
            
        }
        
        if checkXMPPConnection {
            result(true)
            
            guard ChatManager.isChatServerConnected() else {
                print("#CALL CHECK isChatServerConnected false")
                addObserverForConnectionStatus(jidList: jidList, groupJid: groupJid, callType: "voice")
                return
            }
            self.initiateGroupVoiceCall(jidList: jidList, groupJid: groupJid)
        }else{
            do {
                try CallManager.makeGroupVoiceCall(jidList, groupID: groupJid) { isSuccess, flyError in
                    if isSuccess{
                        NSLog("***Make Group Voice Call Success")
                        result(true)
                    }else{
                        let errorMessage = flyError?.localizedDescription
                        NSLog("MirroflyCall Group Video Call error--->\(String(describing: errorMessage))")
                        result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.CALL_FAILED_MESSAGE, details: errorMessage))
                    }
                }
            }catch(let error ) {
                NSLog("***makeGroupVideoCall Error \(error.localizedDescription)")
                result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.CALL_FAILED_MESSAGE, details: error.localizedDescription))
            }
        }
    }
    func inviteUsersToOngoingCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let jidList = args["jidList"] as? [String] ?? []
        
        CallManager.inviteUsersToOngoingCall(jidList) { isSuccess, flyError in
            if isSuccess {
                NSLog("inviteUsersToOngoingCall Success")
                result(true)
            } else {
                if !isSuccess, case let .unexpected(message, code) = flyError {
                    switch code {
                    case ErrorCode.XMPP_CONNECTION_ERROR,
                        ErrorCode.JANUS_CONNECTION_ERROR,
                        ErrorCode.SIGNAL_CONNECTION_ERROR,
                        ErrorCode.INVITE_USER_NOT_IN_ONGOING_CALL:
                        result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.INVITE_FAILED_MESSAGE, details: message))
                        
                    case ErrorCode.FORBIDDEN:
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        
                    default:
                        result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.INVITE_FAILED_MESSAGE, details: message))
                    }
                }
                
            }
        };
    }
    func switchCamera(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        CallManager.switchCamera {
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue(AppUtils.shared.getMyJid(), forKey: "userJid")
            jsonObject.setValue("CAMERA_SWITCH_SUCCESS", forKey: "callAction")
            let callUpdate = pluginDictToJson(dictionary: jsonObject)
            self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallActionChannel, value: callUpdate)
            result(true)
        }
    }
    func isCallOnHold(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func isOneToOneCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        result(CallManager.isOneToOneCall())
    }
    func getCallType(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        result(CallManager.getCallType().rawValue)
    }
    func getGroupID(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let groupID = CallManager.getGroupID()
        print("getGroupID \(String(describing: groupID))")
        result(groupID ?? "")
    }
    func getCallDirection(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        result(CallManager.getCallDirection() == .Incoming ? "Incoming" : "Outgoing")
    }
    func getAllAvailableAudioInput(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
        var jsonArray: [[String: String]] = []
        for item in AudioManager.shared().getAllAvailableAudioInput() {
            let jsonObject: [String: String] = [
                "id": item.id,
                "name": item.name,
                "type": item.type == .bluetooth ? "bluetooth" : item.type == .speaker ? "speaker" : item.type == .headset ? "headset" : item.type == .receiver ? "receiver" : "none"
            ]
            jsonArray.append(jsonObject)
        }
        let availableAudioListJson = jsonArray.toJson()
        NSLog("\(tag) availableAudioListJson \(String(describing: availableAudioListJson))")
        result(availableAudioListJson)
    }
    
    func routeAudioTo(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let routeType = args["routeType"] as? String ?? ""
        NSLog("triggerDelegateForOutputs route Type \(routeType)")
        switch (routeType) {
        case "bluetooth":
            NSLog("****triggerDelegateForOutputs routed to bluetooth")
            AudioManager.shared().routeAudioTo(device: .bluetooth, force: true);
            break;
        case "headset":
            NSLog("****triggerDelegateForOutputs routed to headset")
            AudioManager.shared().routeAudioTo(device: .headset, force: true);
            break;
        case "receiver":
            NSLog("****triggerDelegateForOutputs routed to receiver")
            AudioManager.shared().routeAudioTo(device: .receiver, force: true);
            break;
        case "speaker":
            NSLog("****triggerDelegateForOutputs routed to speaker")
            AudioManager.shared().routeAudioTo(device: .speaker, force: true);
            break;
        default:
            NSLog("****triggerDelegateForOutputs routed to default speaker")
            AudioManager.shared().routeAudioTo(device: .speaker, force: true);
            break;
            //           default:
            //             AudioManager.shared().routeAudioTo(device: .speaker, force: true);
            //             break;
        }
        
        result(true)
    }
    func isCallConnected(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        result(CallManager.isCallConnected())
    }
    func isVideoCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func isAudioCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func isCallNotConnected(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func isUserAudioMuted(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["userJid"] as? String ?? ""
        let status = (jid == AppUtils.shared.getMyJid() || jid == "") ? CallManager.isAudioMuted() : CallManager.isRemoteAudioMuted(jid)
        
        result(status)
    }
    func isUserVideoMuted(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["userJid"] as? String ?? ""
        NSLog("isUserVideoMuted jid \(jid)")
        
        let status = (jid == AppUtils.shared.getMyJid() || jid.isEmpty) ? CallManager.isVideoMuted() : CallManager.isRemoteVideoMuted(jid)
        
        //        if let mirrorFlyViewId = factory?.getUniqueID(forString: jid.isEmpty ? AppUtils.getMyJid() : jid) {
        //                    if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
        //                        mirrorflyView.updateVideoTrack(userJid: jid.isEmpty ? AppUtils.getMyJid() : jid, updateType: status ? MuteEvent.REMOTE_VIDEO_MUTE : MuteEvent.REMOTE_VIDEO_UN_MUTE)
        //                    } else {
        //                        NSLog("\(Constants.callTag) ACTION_LOCAL_VIDEO_MUTE --> View is not Found")
        //                    }
        //                } else {
        //                    NSLog("\(Constants.callTag) ACTION_LOCAL_VIDEO_MUTE --> Unique ID is not Found")
        //                }
        
        NSLog("isUserVideoMuted \(jid == AppUtils.shared.getMyJid() || jid.isEmpty)")
        NSLog("isUserVideoMuted status \(status)")
        result(status)
        
    }
    
    func isOnGoingCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        //        //Method Needed for Android inorder to Launch Ongoing Call Screen
        //        result(false)
        result(CallManager.isOngoingCall())
    }
    
    //    func disconnectCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
    //        NSLog("\(Constants.callTag) Disconnecting Call")
    //        NSLog("\(Constants.callTag) clearing Mirrorfly Views in method call")
    //        factory?.clearMirrorflyView(userJID: AppUtils.getMyJid())
    //        CallManager.incomingUserJidArr.removeAll()
    //        CallManager.disconnectCall()
    //        result(true)
    //    }
    
    
    
    func getErrorMessage(description: String) -> String {
        
        let split = description.components(separatedBy: "ErrorCode")
        let errorMessage = split.isEmpty ? description : split[0].replacingOccurrences(of: ":", with: "")
        return errorMessage
    }
    
    func getErrorCodeWithMessage(message: String) -> (errorCode: String?, errorMessage: String) {
        let split = description.components(separatedBy: "ErrorCode")
        let errorMessage = split.isEmpty ? description : split.first
        print("Error Code With Message \(String(describing: errorMessage))")
        let errorCode = split.count > 1 ? split[1].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ":", with: "") : nil
        return (errorCode, message)
    }
    
    
    func getUnreadMissedCallCount(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        let missedCallCount = CallLogManager.getUnreadMissedCallCount()
        NSLog("\(Constants.callTag) getUnreadMissedCallCount --> \(String(describing: getUnreadMissedCallCount))")
        result(missedCallCount)
    }
    
    func requestVideoCallSwitch(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallManager.requestVideoCallSwitch { isSuccess in
            if isSuccess{
                result(isSuccess)
            }else{
                result(FlutterError(code: FLErrorCode.CALL_FAILED, message: FLErrorMessage.SWITCH_FAILED_MESSAGE, details: nil))
            }
        }
    }
    
    func cancelVideoCallSwitch(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallManager.cancelVideoCallSwitch()
        result(true)
    }
    
    func declineVideoCallSwitchRequest(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallManager.declineVideoCallSwitchRequest()
        result(true)
    }
    
    func acceptVideoCallSwitchRequest(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallManager.acceptVideoCallSwitchRequest()
        CallManager.muteVideo(false)
        CallManager.setCallType(callType: .Video)
        AudioManager.shared().autoReRoute()
        result(true)
    }
    func getMaxCallUsersCount(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        result(8)
    }
    
    func getInvitedUsersList(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        let invitedUserList = CallManager.getInvitedUsersList()
        NSLog("\(Constants.callTag) getInvitedUsersList \(String(describing: invitedUserList.toJson()))")
        result(invitedUserList.toJson())
    }
    
    func getCallLogsList(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        let args = call.arguments as! Dictionary<String, Any>
        let pageNumber = args["currentPage"] as? Int ?? 1
        
        NSLog("\(Constants.callTag) getCallLogsList fetchCallLogList pageNumber \(pageNumber)");
        callLogManager.getCallLogs(pageNumber: pageNumber) { isSuccess, error, data in
            
            var flyData = data
            print("\(Constants.callTag) getCallLogsList plugin \(String(describing: flyData))")
            
            
            
            if isSuccess{
                if flyData["data"] is [String : Any]{
                    
                    guard let data = flyData["data"] as? [String: Any] else {
                        print("Error: Unable to extract 'data' from originalData.")
                        //                        result "{\"data\" : [], \"total_pages\" : 0}";
                        return
                    }
                    
                    guard let callList = data["callList"] as? [CallLog] else {
                        print("Error: Unable to extract 'callList' from 'data'.")
                        print("Error: data: \(data)")
                        //                        return [:]
                        return
                    }
                    var callListConverted: [String: Any]?
                    var callListJson: String?
                    
                    if pageNumber == 1 {
                        self.callLogArray.removeAll()
                        self.callLogArray.append(contentsOf: callList)
                        
                        callListConverted = getCallLogs(callList: callList, totalPages: data["totalPages"])
                        callListJson = callListConverted?.dictToJson()
                    }else{
                        let filteredNewCallLogs = callList.filter { newValue in
                            return !self.callLogArray.contains { existingValue in
                                return existingValue.callLogId == newValue.callLogId
                            }
                        }
                        self.callLogArray.append(contentsOf: filteredNewCallLogs)
                        
                        callListConverted = getCallLogs(callList: filteredNewCallLogs, totalPages: data["totalPages"])
                        callListJson = callListConverted?.dictToJson()
                    }
                    
                    print("Returning getCallLogsList fetchCallLogList \(String(describing: callListJson))")
                    result(callListJson)
                    
                }else{
                    
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyData.getMessage()))
                }
            }else{
                if case let .unexpected(message, _) = error {
                    //.unexpected handled here
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    
                }else if case let .xmpp_connection_not_available(message, code) = error {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error?.localizedDescription))
                }
                //                result(FlutterError(code: "500", message: "Call Log List Fetch Failed", details: flyData.getMessage()))
            }
        }
    }
    
    func getLocalCallLogs(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        let callLogArray = CallLogManager.getAllCallLogs()
        print("\(Constants.callTag) getLocalCallLogs \(String(describing: callLogArray))")
        if callLogArray.isEmpty{
            result("{\"data\" : [], \"total_pages\" : 0}");
        }else{
            
            let callListConverted = getCallLogs(callList: callLogArray, totalPages: 0)
            print("\(Constants.callTag) getCallLogsList converted \(callListConverted)")
            let callListJson = callListConverted.dictToJson()
            print("\(Constants.callTag) getCallLogsList converted json\(String(describing: callListJson))")
            result(callListJson)
            
        }
        
    }
    
    func deleteCallLog(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        let args = call.arguments as! Dictionary<String, Any>
        let isClearAll = args["isClearAll"] as? Bool ?? false
        let jidList = args["jidList"] as? [String] ?? []
        NSLog("\(Constants.tag) deleteCallLog isClearAll \(isClearAll)")
        
        
        ChatManager.deleteCallLog(isClearAll: isClearAll, callLogIds: jidList) { isSuccess, error, data in
            var flyData = data
            if isSuccess {
                if isClearAll{
                    CallLogManager().deleteCallLogs()
                }
                let deleteMessage = flyData.getMessage() as? String
                print("\(Constants.tag) deleteCallLog \(String(describing: deleteMessage))")
                result(isSuccess)
            }else{
                
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error?.localizedDescription))
            }
        }
    }
    
    func syncCallLogs(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallLogManager().syncCallLogs { isSuccess, error, data in
            
            if isSuccess {
                var flyData = data
                _ = flyData.getMessage() as? String
                _ = flyData.getData() as? [CallLog]
                result(isSuccess)
            }else{
                if case let .unexpected(message, _) = error {
                    //.unexpected handled here
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .xmpp_connection_not_available(message, code) = error {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error?.localizedDescription))
                }
            }
        }
    }
    
    func isCallConversionRequestAvailable(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        result(CallManager.isCallConversionRequestAvailable())
    }
    
    func markAllUnreadMissedCallsAsRead(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallLogManager.resetUnreadMissedCallCount()
        result(true)
    }
    //    func changeCallType(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
    //        let args = call.arguments as! Dictionary<String, Any>
    //        let callType = args["callType"] as? String ?? ""
    //        print("***callType \(callType)")
    //        if callType == "video"{
    //
    //            CallManager.setCallType(callType: .Video)
    //            CallManager.muteVideo(false)
    //            CallManager.enableVideo()
    //            AudioManager.shared().autoReRoute()
    //        }else{
    //            CallManager.setCallType(callType: .Audio)
    //            CallManager.muteVideo(true)
    //            CallManager.disableVideo()
    //            AudioManager.shared().autoReRoute()
    //        }
    //        result(true)
    //    }
    //
    //    func reRouteAudio(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
    //        AudioManager.shared().autoReRoute()
    //    }
    
    
    private func handleCallFailure(flyError: FlyError? = nil, customError: String? = nil) {
        let errorMessage: String
        
        if let flyError = flyError {
            errorMessage = getErrorMessage(description: flyError.description)
        } else if let customError = customError {
            errorMessage = customError
        } else {
            errorMessage = "Unknown error occurred"
        }
        
        print("#CALL CHECK failed \(errorMessage)")
        NSLog("MirroflyCall making call error--->\(errorMessage)")
        
        let jsonObject: NSMutableDictionary = [
            "callStatus": "Call_Failed",
            "userJid": AppUtils.shared.getMyJid(),
            "callMode": "onetoone",
            "callType": "audio",
            "error": errorMessage
        ]
        
        let callStatusUpdateJson = pluginDictToJson(dictionary: jsonObject)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.eventChannelInitializer.updateSinkValue(forChannel: Constants.onCallStatusUpdateChannel, value: callStatusUpdateJson)
        }
    }
    
    private func addObserverForConnectionStatus(jid: String? = nil, jidList: [String]? = nil, groupJid: String? = nil, callType: String) {
        guard jid != nil || (jidList != nil && groupJid != nil) else {
            print("Either jid or jidList or groupJid must be provided")
            return
        }
        print("#CALL CHECK Adding observer")
        self.observerToken = NotificationCenter.default.addObserver(forName: .connectionStatusChanged, object: nil, queue: nil) { notification in
            guard let status = notification.userInfo?["status"] as? String else { return }
            print("#CALL CHECK Connection Status: \(status)")
            
            if status == "connected" {
                self.removeObserver()
                
                if let jid = jid {
                    if (callType == "voice"){
                        self.initiateVoiceCall(jid: jid)
                    }else if(callType == "video"){
                        self.initiateVideoCall(jid: jid)
                    }
                } else if let jidList = jidList {
                    if (callType == "voice"){
                        self.initiateGroupVoiceCall(jidList: jidList, groupJid: groupJid ?? "")
                    }else if(callType == "video"){
                        self.initiateGroupVideoCall(jidList: jidList, groupJid: groupJid ?? "")
                    }
                }
                
                
            } else if status == "failed" {
                self.removeObserver()
            } else {
                print("#ChatManager Connection Default Status: \(status)")
            }
        }
    }
    
    private func removeObserver() {
        if let observerToken = observerToken {
            NotificationCenter.default.removeObserver(observerToken)
            self.observerToken = nil
        }
    }
    
    private func initiateVoiceCall(jid: String) {
        print("#CALL CHECK Calling makeVoiceCall")
        
        try! CallManager.makeVoiceCall(jid) { isSuccess, flyError in
            if isSuccess {
                print("#CALL CHECK make call success")
            } else {
                self.handleCallFailure(flyError: flyError)
            }
        }
    }
    
    private func initiateVideoCall(jid: String) {
        print("#CALL CHECK Calling makeVoiceCall")
        
        try! CallManager.makeVideoCall(jid) { isSuccess , flyError in
            NSLog("call result --> \(isSuccess) messsage --> \(String(describing: flyError))")
            if (isSuccess){
                NSLog("MirrorflyCall Success")
                print("#CALL CHECK make video call success")
            }else{
                self.handleCallFailure(flyError: flyError)
                
            }
        }
    }
    
    private func initiateGroupVideoCall(jidList: [String], groupJid: String){
        do {
            try CallManager.makeGroupVideoCall(jidList, groupID: groupJid) { isSuccess, flyError in
                
                if isSuccess{
                    print("#CALL CHECK make Group Video call success")
                }else{
                    let errorMessage = flyError?.localizedDescription
                    NSLog("MirroflyCall Group Video Call error--->\(String(describing: errorMessage))")
                    
                    self.handleCallFailure(flyError: flyError)
                }
            }
        }catch(let error ) {
            NSLog("***makeGroupVideoCall Error \(error.localizedDescription)")
            self.handleCallFailure(customError: error.localizedDescription)
        }
    }
    
    private func initiateGroupVoiceCall(jidList: [String], groupJid: String){
        do {
            try CallManager.makeGroupVoiceCall(jidList, groupID: groupJid) { isSuccess, flyError in
                if isSuccess{
                    print("#CALL CHECK make Group Voice call success")
                }else{
                    let errorMessage = flyError?.localizedDescription
                    NSLog("MirroflyCall Group Video Call error--->\(String(describing: errorMessage))")
                    self.handleCallFailure(flyError: flyError)
                }
            }
        }catch(let error ) {
            NSLog("***makeGroupVideoCall Error \(error.localizedDescription)")
            self.handleCallFailure(customError: error.localizedDescription)
        }
    }
    
    func createMeetLink(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallManager.createMeetLink { isSuccess, error, response in
            if isSuccess{
                var link = response
                let meetLink = link.getData() as? String ?? emptyString()
                result(meetLink)
            }else{
                if case let .unexpected(message, _) = error {
                    result(FlutterError(code: FLErrorCode.MEET_INITIALIZATION_FAILED, message: FLErrorMessage.MEET_INITIALIZATION_FAILED_MESSAGE, details: message))
                }else {
                    result(FlutterError(code: FLErrorCode.MEET_INITIALIZATION_FAILED, message: FLErrorMessage.MEET_INITIALIZATION_FAILED_MESSAGE, details: error?.localizedDescription))
                }
            }
        }
    }
    
    
    func startVideoCapture(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        if(CallManager.isVideoCallPermissionsGranted() && CallManager.isAudioCallPermissionsGranted()){
            CallManager.startVideoCapture()
            result(true)
        }else{
            result(FlutterError(code: FLErrorCode.PERMISSION_NOT_GRANTED, message: FLErrorMessage.MICROPHONE_CAMERA_PERMISSION_NOT_ENABLED, details: nil))
        }
    }
    
    func initializeMeet(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        let args = call.arguments as! Dictionary<String, Any>
        
        let callLink = args["callLink"] as? String ?? ""
        let userName = args["userName"] as? String ?? ""
        
        
        if !CallManager.isConnectedToLinkServer(){
            CallManager.setupJoinCallViaLink()
            meetLinkServerObserverToken = NotificationCenter.default.addObserver(forName: .signalConnected, object: nil, queue: nil) { notification in
                print("isConnectedToLinkServer isConnectedToLinkServer observer returned")
                if let token = self.meetLinkServerObserverToken {
                    NotificationCenter.default.removeObserver(token)
                    self.meetLinkServerObserverToken = nil
                }
                self.subscribeCallEvents(callLink: callLink, userName: userName, result: result)
            }
            
            
        }else{
            print("isConnectedToLinkServer isConnectedToLinkServer else")
            subscribeCallEvents(callLink: callLink, userName: userName, result: result)
        }
        
        
    }
    
    private func subscribeCallEvents(callLink: String, userName: String, result: @escaping FlutterResult) {
        print("isConnectedToLinkServer subscribeCallEvents")
        CallManager.subscribeToCallEvents(link: callLink, name: userName) { isSuccess, flyError in
            if isSuccess{
                print("isConnectedToLinkServer subscribeCallEvents issuccess")
                result(isSuccess)
            }else{
                print("isConnectedToLinkServer subscribeCallEvents failed")
                if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                        result(FlutterError(code: FLErrorCode.MEET_INITIALIZATION_FAILED, message: FLErrorMessage.MEET_INITIALIZATION_FAILED_MESSAGE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MEET_INITIALIZATION_FAILED_MESSAGE, details: message))
                    }
                }else if case let .invalid_call_link(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.MEET_INITIALIZATION_FAILED, message: FLErrorMessage.MEET_INITIALIZATION_FAILED_MESSAGE, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.MEET_INITIALIZATION_FAILED, message: FLErrorMessage.MEET_INITIALIZATION_FAILED_MESSAGE, details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func getCallLink(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        result(CallManager.getCallLink())
    }
    
    func disposePreview(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallManager.cleanUpJoinCallViaLink()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            result(true)
        }
    }
    
    
    func getMeetUsername(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
     
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["userJid"] as? String ?? ""
        
        result(CallManager.getUserName(userId: userJid))
        
    }
    
    
    func joinCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        
        CallManager.joinCall{ isSuccess, flyError in
          if isSuccess {
             result(isSuccess)
          }else{
              
//              if let error = flyError {
              result(FlutterError(code: FLErrorCode.MEET_INITIALIZATION_FAILED, message: FLErrorMessage.MEET_INITIALIZATION_FAILED_MESSAGE, details: flyError?.localizedDescription))
//              }
              
          }
        }
    }
    
}
