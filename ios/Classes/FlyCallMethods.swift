//
//  FlyCallMethods.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import Flutter
import MirrorFlySDK


@objc class FlyCallMethods : NSObject{
    
    let tag = "#MirrorFlyCall"
    
    func getCallUsersList(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
        let userListStatus = CallManager.getCallUsersWithStatus()
        let userList = CallManager.getCallUsersList()
        
        NSLog("userListStatus \(userListStatus)")
        NSLog("userlist \(String(describing: userList))")
        
//        let userListStatusJson = userListStatus.dictToJson()
        
//        ["917010279986@xmpp-uikit-qa.contus.us": MirrorFlySDK.CALLSTATUS.CONNECTED]
        
        var jsonArray: [[String: Any]] = []
        
        
            
        for (memberJid,status) in CallManager.getCallUsersWithStatus() {
            NSLog("\(tag) \(memberJid) \(status)")
            let jsonObject: [String: Any] = [
                "userJid": memberJid,
                "callStatus": status.rawValue,
                "isAudioMuted" : CallManager.isRemoteAudioMuted(memberJid),
                "isVideoMuted" : CallManager.isRemoteVideoMuted(memberJid)
//                "isAudioMuted" : CallManager.isRemoteAudioMuted(memberJid)
            ]
            NSLog("#MirrorflyCall Call Status Updated--> Appending CallUsersList \(jsonObject)")
            jsonArray.append(jsonObject)
        }
        
        let localJIDJson: [String: Any] = [
            "userJid": AppUtils.getMyJid(),
            "callStatus": CallManager.getCallDirection() == .Incoming ? (CallManager.isCallConnected() ? "Connected" : "Connecting") : (CallManager.isCallConnected() ? "Connected" : "Calling"),
            "isAudioMuted" : CallManager.isAudioMuted(),
            "isVideoMuted" : CallManager.isVideoMuted()
//            "isAudioMuted" : CallManager.isAudioMuted()
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
        AudioManager.shared().autoReRoute()
        
        if !CallManager.isOneToOneCall() && !muteStatus{
            CallManager.enableVideo()
        }else if !CallManager.isOneToOneCall() && muteStatus{
            CallManager.disableVideo()
        }
        
        if let mirrorFlyViewId = factory?.getUniqueID(forString: AppUtils.getMyJid()) {
            if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
                mirrorflyView.updateVideoTrack(userJid: AppUtils.getMyJid(), updateType: muteStatus ? MuteEvent.ACTION_LOCAL_VIDEO_MUTE : MuteEvent.ACTION_LOCAL_VIDEO_UN_MUTE)
            } else {
                NSLog("\(Constants.callTag) ACTION_LOCAL_VIDEO_MUTE --> View is not Found")
            }
        } else {
            NSLog("\(Constants.callTag) ACTION_LOCAL_VIDEO_MUTE --> Unique ID is not Found")
        }
        
        result(true)
    }
    
    func getAudioDevices(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
           
    }
    //Moved to FlyCall Class to get from Delegate
//    func selectedAudioDevice(call: FlutterMethodCall, result: @escaping FlutterResult) {
//
//        NSLog("selectedAudioDevice \(selectedAudioDevice)")
//    }
    func selectAudioDevice(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func makeCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["user_jid"] as? String ?? ""
        
        try! CallManager.makeVoiceCall(jid) { [weak self] (isSuccess , message)  in
           if isSuccess  {
               if(!CallManager.isAudioCallPermissionsGranted()){
                   NSLog("MirrorflyCall Audio call permission not granted")
                   result(FlutterError(code: "500", message: "Microphone Permission not enabled", details: nil))
                   return
               }
               if isSuccess == false {
                   let errorMessage = self?.getErrorMessage(description: message)
                   NSLog("MirroflyCall making call error--->\(errorMessage ?? "make voice call error")")
               }else{
                   NSLog("MirrorflyCall Success -->")
//                   result(isSuccess)
               }
            }
         }
        result(true)
    }
    func makeVideoCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["user_jid"] as? String ?? ""
        NSLog("making video call")
        
        if(!CallManager.isAudioCallPermissionsGranted()){
            NSLog("MirrorflyCall Audio call permission not granted")
            result(FlutterError(code: "500", message: "Microphone Permission not enabled", details: nil))
            return

        }
        if(!CallManager.isVideoCallPermissionsGranted()){
            NSLog("MirrorflyCall Video call permission not granted")
            result(FlutterError(code: "500", message: "Camera Permission not enabled", details: nil))
            return
        }
        try! CallManager.makeVideoCall(jid) { isSuccess , message in
            NSLog("call result --> \(isSuccess) messsage --> \(message)")
            if (isSuccess){
                NSLog("MirrorflyCall Success")
//                result(isSuccess)
            }
        }
        result(true)
    }
    func answerCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func declineCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        NSLog("\(Constants.callTag) declineCall")
        NSLog("\(Constants.callTag) clearing Mirrorfly Views in method call")
        factory?.clearMirrorflyView(userJID: AppUtils.getMyJid())
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
    func isVideoMuted(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func isRemoteVideoMuted(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func isRemoteVideoPaused(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func makeGroupVideoCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["groupJid"] as? String ?? ""
        let jidList = args["jidList"] as? [String] ?? []
        
        NSLog("***making group call")
        do {
            try CallManager.makeGroupVideoCall(jidList, groupID: groupJid) { (isSuccess, message) in
                
                
                if isSuccess{
                    NSLog("***Make Group Video Call Success")
                }else{
                    NSLog("***Make Group Video Call Failed \(message)")
                }
            }
        }catch(let error ) {
            NSLog("***makeGroupVideoCall Error \(error.localizedDescription)")
        }
        result(true)
    }
    func makeGroupVoiceCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["groupJid"] as? String ?? ""
        let jidList = args["jidList"] as? [String] ?? []
        
        NSLog("***making group call")
        do {
            try CallManager.makeGroupVoiceCall(jidList, groupID: groupJid) { (isSuccess, message) in
                if isSuccess{
                    NSLog("***Make Group Voice Call Success")
                }else{
                    NSLog("***Make Group Voice Call Failed \(message)")
                }
            }
        }catch(let error ) {
            NSLog("***makeGroupVideoCall Error \(error.localizedDescription)")
        }
        result(true)
    }
    func inviteUsersToOngoingCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let args = call.arguments as! Dictionary<String, Any>
        let jidList = args["jidList"] as? [String] ?? []
        
        CallManager.inviteUsersToOngoingCall(jidList) { isSuccess, message in
            if isSuccess {
                NSLog("inviteUsersToOngoingCall Success")
                result(true)
            } else {
                let errorMessage = self.getErrorMessage(description: message)
                NSLog("inviteUsersToOngoingCall Error\(errorMessage.description) ")
                result(FlutterError(code: "500", message: "Invite Users To OngoingCall Failed", details: errorMessage.description))
            }
        };
    }
    func switchCamera(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        CallManager.switchCamera {
            result(true)
        }
    }
    func isCallOnHold(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func isOneToOneCall(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
    }
    func getCallType(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        result(CallManager.getCallType().rawValue)
    }
    func getGroupID(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        let groupID = CallManager.getGroupID()
        print("getGroupID \(groupID)")
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
        let availableAudioListJson = jsonArray.convertToJson()
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
        let status = (jid == AppUtils.getMyJid() || jid == "") ? CallManager.isAudioMuted() : CallManager.isRemoteAudioMuted(jid)

        result(status)
    }
    func isUserVideoMuted(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?) {
        
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["userJid"] as? String ?? ""
        NSLog("isUserVideoMuted jid \(jid)")
       
        let status = (jid == AppUtils.getMyJid() || jid.isEmpty) ? CallManager.isVideoMuted() : CallManager.isRemoteVideoMuted(jid)
        
//        if let mirrorFlyViewId = factory?.getUniqueID(forString: jid.isEmpty ? AppUtils.getMyJid() : jid) {
//                    if let (_, mirrorflyView) = factory?.mirrorflyViews[mirrorFlyViewId] {
//                        mirrorflyView.updateVideoTrack(userJid: jid.isEmpty ? AppUtils.getMyJid() : jid, updateType: status ? MuteEvent.REMOTE_VIDEO_MUTE : MuteEvent.REMOTE_VIDEO_UN_MUTE)
//                    } else {
//                        NSLog("\(Constants.callTag) ACTION_LOCAL_VIDEO_MUTE --> View is not Found")
//                    }
//                } else {
//                    NSLog("\(Constants.callTag) ACTION_LOCAL_VIDEO_MUTE --> Unique ID is not Found")
//                }
        
        NSLog("isUserVideoMuted \(jid == AppUtils.getMyJid() || jid.isEmpty)")
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
        let errorMessage = split.isEmpty ? description : split[0]
        return errorMessage
    }
    
    
    func getUnreadMissedCallCount(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        let missedCallCount = CallLogManager.getUnreadMissedCallCount()
        NSLog("\(Constants.callTag) getUnreadMissedCallCount --> \(String(describing: getUnreadMissedCallCount))")
        result(missedCallCount)
    }
    
    func requestVideoCallSwitch(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        CallManager.requestVideoCallSwitch { isSuccess in
           result(isSuccess)
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
        
        NSLog("\(Constants.callTag) getCallLogsList pageNumber \(pageNumber)");
        CallLogManager().getCallLogs(pageNumber: pageNumber) { isSuccess, error, data in
            
            var flyData = data
//            NSLog("\(Constants.callTag) getCallLogsList \(String(describing: flyData))")
            print("\(Constants.callTag) getCallLogsList \(String(describing: flyData))")
           
    
            
            if isSuccess{
//                result(callLogList.)
                if flyData["data"] is [String : Any]{
                   
                    let callListConverted = getCallLogs(flyData: flyData)
                    print("\(Constants.callTag) getCallLogsList converted \(callListConverted)")
                    let callListJson = callListConverted.dictToJson()
                    print("\(Constants.callTag) getCallLogsList converted json\(String(describing: callListJson))")
                    result(callListJson)
                    
                }else{
                    result(FlutterError(code: "500", message: "Call Log List Fetch Failed", details: flyData.getMessage()))
                }
            }else{
                result(FlutterError(code: "500", message: "Call Log List Fetch Failed", details: flyData.getMessage()))
            }
        }
    }
    
    func deleteCallLog(call: FlutterMethodCall, result: @escaping FlutterResult, factory: MirrorflyViewFactory?){
        let args = call.arguments as! Dictionary<String, Any>
        let isClearAll = args["isClearAll"] as? Bool ?? false
        let jidList = args["jidList"] as? [String] ?? []
        
        ChatManager.deleteCallLog(isClearAll: isClearAll, callLogIds: jidList) { isSuccess, error, data in
            var flyData = data
            if isSuccess {
                let successMessage = flyData.getMessage() as? String
                result(isSuccess)
            }else{
                result(FlutterError(code: "500", message: "Call Log Delete Failed", details: flyData.getMessage()))
            }
        }
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
}
