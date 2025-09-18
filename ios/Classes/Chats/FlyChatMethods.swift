//
//  FlySdkMethodCalls.swift
//  fly_chat
//
//  Created by user on 23/03/23.
//

import Foundation
import Flutter
import Photos
import Contacts
import ContactsUI
import MirrorFlySDK
import UIKit
import libPhoneNumber_iOS

#if DEBUG
let ISEXPORT = false
#else
let ISEXPORT = true
#endif

@objc public class FlyChatMethods : NSObject{
    
    var isTrialLicenceKey : Bool = true;
    var chatHistoryEnable : Bool = false;
    
    //    var userlist = [ProfileDetails]()
    
    var recentChatListParams = RecentChatListParams(limit: 15)
    
    var recentChatListBuilder: RecentChatListBuilder?
    
    
    var bestAttemptContent: UNMutableNotificationContent?
    var contentHandler: ((UNNotificationContent) -> Void)?
    
    var messageListParams = FetchMessageListParams()
    var messageListQuery : FetchMessageListQuery? = nil
    
    //Need to alter this below two lines based on RecentChat list
    var topicChatListParams = TopicChatListParams(limit: 15)
    var topicChatListBuilder : TopicChatListBuilder?

    var observerToken: NSObjectProtocol?
    
    var firstMessageID : String = emptyString()
    var lastMessageID : String = emptyString()
    
    
    // Singleton instance
    static let shared = FlyChatMethods()
    
    // Private initializer to prevent creating new instances
    private override init() {
        super.init()
    }
    
    func buildChatSDK(call: FlutterMethodCall, result: @escaping FlutterResult) {

            let args = call.arguments as! Dictionary<String, Any>

            let domainBaseUrl = args["domainBaseUrl"] as? String ?? ""
            let licenseKey = args["licenseKey"] as? String ?? ""
            isTrialLicenceKey = args["isTrialLicenceKey"] as? Bool ?? true

            let containerID = args["iOSContainerID"] as? String ?? ""


            chatHistoryEnable = args["chatHistoryEnable"] as? Bool ?? true


            Utility.saveInPreference(key: Constants.licenseKey, value: licenseKey)
            Utility.saveInPreference(key: Constants.containerID, value: containerID)

            let groupConfig = args["groupConfig"] as? [String : Any]

            let groupCreationEnable = groupConfig?["enableGroup"] as? Bool ?? true
            let adminOnlyAddRemoveAccess = groupConfig?["adminOnlyAddRemoveAccess"] as? Bool ?? true
            let maxMembersCount = groupConfig?["maxMembersCount"] as? Int ?? 200

            let sdkGroupConfig = try? GroupConfig.Builder.enableGroupCreation(groupCreation: groupCreationEnable)
                .onlyAdminCanAddOrRemoveMembers(adminOnly: adminOnlyAddRemoveAccess)
                .setMaximumMembersInAGroup(membersCount: maxMembersCount)
                .build()
            assert(sdkGroupConfig != nil)

            try? ChatSDK.Builder.setAppGroupContainerID(containerID: containerID)
                .setLicenseKey(key: licenseKey)
                .isTrialLicense(isTrial: isTrialLicenceKey)
                .setDomainBaseUrl(baseUrl: domainBaseUrl)
                .setGroupConfiguration(groupConfig: sdkGroupConfig!)
                .buildAndInitialize()

        // *** DON'T REMOVE THIS LINE ======================
        // *** USED TO INITIALISE THE CHAT MANAGER IN NEW SDK=========

        _ = ChatManager.shared

        // *** =============================================

        // ChatManager.disableLocalNotification()

            /// Moved Inside SDK
            /*if Utility.getBoolFromPreference(key: Constants.isLoggedIn) {

                DispatchQueue.main.asyncAfter(deadline: .now()+2) {

                    do {
                        try CallManager.initCallSDK()
                    } catch (let error ){
                        print("#FlyCall Exception : \(error.localizedDescription)")
                    }
                }
            }*/

            //        ChatManager.enableContactSync(isEnable: !isTrialLicenceKey)

            ChatManager.enableChatHistory(isEnable: chatHistoryEnable)

        }
    
    func initializeSDK(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let licenseKey = args["licenseKey"] as? String ?? ""
        chatHistoryEnable = args["chatHistoryEnable"] as? Bool ?? true
        let containerID = args["iOSContainerID"] as? String ?? ""
        let enableSDKLog = args["enableDebugLog"] as? Bool ?? false
        let enablePrivateStorage = args["enablePrivateStorage"] as? Bool ?? false
        let enableVoipActivity = args["enableVoipActivity"] as? Bool ?? false

        ///
        /// Moved this setAppGroupContainerId at FlyChatPlugin before initializeEventListeners for logout delegate issue.
        ///
//        ChatManager.setAppGroupContainerId(id: containerID)

        Utility.saveInPreference(key: Constants.licenseKey, value: licenseKey)
        Utility.saveInPreference(key: Constants.containerID, value: containerID)
        Utility.saveInPreference(key: Constants.enableVoipActivity, value: enableVoipActivity)
        
        ChatManager.initializeSDK(licenseKey: licenseKey) { isSuccess, flyError, flyData in
            if isSuccess {
                ChatManager.enableChatHistory(isEnable: self.chatHistoryEnable)
                ChatManager.enablePrivateStorage(enable: enablePrivateStorage)
                CallManager.enableDebugLogs(enable : enableSDKLog)
                NSLog("SDK INITIALISE Success")
                if Utility.getBoolFromPreference(key: Constants.isLoggedIn) && !ChatManager.isChatServerConnected() {
                    ChatManager.connect()
                }
                result(true)
            }else{

                if(ChatManager.getAppConfigDetails().baseURL.isEmpty){
                    NSLog("SDK FAILED TO INITIALISE \(String(describing: flyError?.localizedDescription))")

                    if !isSuccess, case let .unexpected(message, code) = flyError {
                        NSLog("Failed Initialisation message \(message)")
                        if code == ErrorCode.RESPONSE_FAILURE{
                            result(FlutterError(code: FLErrorCode.INVALID_CREDENTAILS, message: FLErrorMessage.INVALID_CREDENTAILS_MESSAGE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INITALIZATION_FAILED, message: FLErrorMessage.INVALID_CREDENTAILS_MESSAGE, details: message))
                        }
                    }
                }else{
                    NSLog("SDK FAILED TO INITIALISE, BUT CONFIG DETAILS ARE ALREADY PRESENT. SO PROCEEDING WITH TRUE CONDITION")
                    result(true)
                }
            }
        }
    }
    
    func getPlistValue(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let key = args["key"] as? String ?? ""
        // Get the path to the Info.plist file
        guard let infoPlistPath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE,
                                message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE,
                                details: "Info.plist file not found"))
            return
        }
        
        // Load the contents of the Info.plist file
        guard let infoDict = NSDictionary(contentsOfFile: infoPlistPath) else {
            result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE,
                                message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE,
                                details: "Failed to load Info.plist"))
            return
        }
        
        // Access the value using the appropriate key
        if let value = infoDict[key] as? String {
            result(value)
        } else {
            result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE,
                                message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE,
                                details: "\(key) key not found in Info plist"))
        }
        
    }
    
    func registerUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        var userIdentifier = args["userIdentifier"] as? String ?? ""
        let deviceToken = args["token"] as? String ?? Utility.getStringFromPreference(key: Constants.googleToken)
        let isForceRegister = args["isForceRegister"] as? Bool ?? true
        let userType = args["userType"] as? String ?? ""

        userIdentifier = userIdentifier.replacingOccurrences(of: "+", with: "")
        
        if(userIdentifier.isEmpty){
            result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.REGISTRATION_FAILED_MESSAGE,details: FLErrorMessage.USER_PARAM_MISSING))
            
            return
        }
        let voipToken = Utility.getStringFromPreference(key: Constants.voipToken)
        
        NSLog("\(Constants.tag) voipToken \(voipToken)")
        NSLog("\(Constants.tag) voipToken.isEmpty \(voipToken.isEmpty)")
        
        NSLog("\(Constants.tag) Register Device Token \(deviceToken)")
        NSLog("\(Constants.tag) ISEXPORT \(ISEXPORT)")
        
        let metaData = args["metaData"] as? [[String: Any]] ?? []
        print("metaData \(String(describing: metaData))")
        var metaDataArray : [MetaData] = []
        for data in metaData {
            let obj = MetaData(key: data["key"] as? String ?? "", value: data["value"] as? String ?? "")
            metaDataArray.append(obj)
        }

        if Utility.getBoolFromPreference(key: Constants.isLoggedIn) {
            ChatManager.disconnect()
        }

        try! ChatManager.registerApiService(for: userIdentifier, deviceToken: deviceToken, voipDeviceToken: voipToken, isExport: ISEXPORT,isForceRegister: isForceRegister,userType: userType, metaData: metaDataArray, pushServerType: .firebase) { isSuccess, flyError, flyData in
            var data = flyData
            if isSuccess {
                
                let registerResponse = [
                    "data": data,
                    "is_new_user": data["newLogin"] as Any,
                    "message" : "Register Trial API Success"
                ] as [String : Any]
                
                print("Register user new login data \(data)")
                Utility.saveInPreference(key: Constants.isLoggedIn, value: true)
                ChatManager.connect()
                
                self.observerToken = NotificationCenter.default.addObserver(forName: .connectionStatusChanged, object: nil, queue: nil) { notification in
                        guard let userInfo = notification.userInfo else { return }
                        if let status = userInfo["status"] as? String {
                            print("#ChatManager Connection Status: \(status)")

                            switch status {
                            case "connected":
                                self.removeObserver()

                                //                do {
                                //                    try CallManager.initCallSDK()
                                //                }
                                //                catch(let error ) {
                                //                    NSLog("\(Constants.callTag) #Init CallManager Exception : \(error.localizedDescription)")
                                //                }
                                
                                if  data["newLogin"] as? Bool ?? false{
                                    NSLog("\(Constants.tag) New User Login so Clearing the Call log in DB")
                                    CallLogManager().deleteCallLogs()
                                    
//                                    GroupManager.shared.getGroups(fetchFromServer: true) { isSuccess, flyError, flyData in
//                                        if isSuccess {
//                                            NSLog("\(Constants.tag) Fetched All groups for new login")
//                                        }else{
//                                            print("getGroups flyError \(String(describing: flyError?.localizedDescription))")
//                                        }
//                                    }
                                    
                                }
                                
//                                if let dataDict = data["data"] as? [String: Any],
                                if  let config = data["config"] as? [String: Any],
                                    let profileIv = config["ivProfile"] as? String {
                                    NSLog("\(Constants.tag) profileIv = \(profileIv)")
                                    Utility.saveStaticString(key: Constants.profileIvKey, value: profileIv)
                                }
                                
                                
                                ChatManager.updateAppLoggedIn(isLoggedin: true)

                                let voipToken = Utility.getStringFromPreference(key: Constants.voipToken);
                                
//                                if !voipToken.isEmpty {
                                    
                                    VOIPManager.sharedInstance.saveVOIPToken(token: voipToken)
                                    
//                                }
                                
//                                if !deviceToken.isEmpty {
                                    VOIPManager.sharedInstance.savePushToken(token: deviceToken)
//                                }
                                
                                VOIPManager.sharedInstance.updateDeviceToken()
                                
                                let resp = registerResponse.dictToJson()
                                if(resp != nil){
                                    NSLog("\(Constants.tag) ChatManager.registerApiService \(String(describing: resp))")
                                    result(resp)
                                }else{
                                    result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.REGISTRATION_FAILED_MESSAGE,details: nil))
                                }

                            case "failed":
                                self.removeObserver()
                                let errorMessage = userInfo["error"] as? String
                                print("#ChatManager Connection Error: \(errorMessage ?? "Connection Failed")")
                                result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.CHATMANAGER_CONNECTION_FAILED_MESSAGE,details: errorMessage))
                            default:
                                print("#ChatManager Connection Default Status: \(status)")
                            }

                        }else{
                            print("---Error in Chat Manager Connect Status")
                        }
                    }
            }else{
                let err = flyError?.description ?? ""
                let error = err.contains("405") ? err : data.getMessage()
                
                NSLog("\(Constants.tag) #chatSDK Error \(error)")
                
                if !isSuccess, case let .data_not_available(message, code) = flyError {
                    switch (code){
                    case 405:
                        result(FlutterError(code: FLErrorCode.MAX_LOGIN_REACHED,message: FLErrorMessage.MAX_LOGIN_REACHED_MESSAGE + " Do you want to continue then set forceRegister as true in registerUser method",details: message))
                        break;
                    case 403:
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION,message: FLErrorMessage.USER_BLOCKED_MESSAGE,details: message))
                        break;
                    case 807, 1000, _:
                        result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.REGISTRATION_FAILED_MESSAGE,details: message))
                        break;
                    }
                }else if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_CREDENTAILS, message: FLErrorMessage.REGISTRATION_FAILED_MESSAGE, details: message))
                }else if case let .fields_empty(message, _) = flyError{
                    result(FlutterError(code: FLErrorCode.ARGUMENTS_EMPTY_OR_NULL, message: FLErrorMessage.MISSING_ARGUMENTS, details: message))
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_CREDENTAILS, message: FLErrorMessage.REGISTRATION_FAILED_MESSAGE, details: error))
                }
                
            }
        }
    }
    
    private func removeObserver() {
        print("---removeObserver")
        if let token = observerToken {
            NotificationCenter.default.removeObserver(token)
            observerToken = nil
        }
    }

    deinit {
        print("---deinit FlySDKMethodCalls")
        removeObserver()
    }

    func refreshAndGetAuthToken(call: FlutterMethodCall, result: @escaping FlutterResult){
        ChatManager.refreshToken { (isSuccess, flyError, resultDict) in
            if (isSuccess) {
                var resp = resultDict
                let tokendata = resp.getData()
                let refreshToken = tokendata as AnyObject
                
                let newToken = refreshToken["token"] as Any
                
                result(newToken)
                
            } else {
                result(FlutterError(code: FLErrorCode.INVALID_CREDENTAILS,message: FLErrorMessage.AUTHTOKEN_REFRESH_FAILED_MESSAGE,details: flyError?.localizedDescription))
            }
        }
    }
    
    func getCurrentAuthToken(call: FlutterMethodCall, result: @escaping FlutterResult){

        let authToken = ChatManager.getAppConfigDetails().authtoken
        print("getCurrentAuthToken==**==\(authToken)")
        result(authToken)
    }
    
    func getJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userName = args["username"] as? String
        if(userName == nil){
            result(FlutterError(code: FLErrorCode.MISSING_PARAMS,message: FLErrorMessage.USER_PARAM_MISSING,details: nil))
            return
        }
        do{
            try result(FlyUtils.getJid(from: userName!))
        }catch let jidError{
            result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.JID_FETCH_FAILED,details: jidError.localizedDescription))
        }
    }
    
    func getJidFromPhoneNumber(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let mobileNumber = args["mobileNumber"] as? String ?? ""
        let countryCode = args["countryCode"] as? String ?? ""
        
        let phoneNumberUtil = NBPhoneNumberUtil()
        
        if mobileNumber.starts(with: "*") {
            NSLog("Invalid PhoneNumber: \(mobileNumber)")
            result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.JID_FETCH_FAILED,details: nil))
        }
        
        do {
            let phoneNumber = try phoneNumberUtil.parse(mobileNumber.replacingOccurrences(of: "^0+", with: ""), defaultRegion: countryCode)
            
            if let unformattedPhoneNumber = try? phoneNumberUtil.format(phoneNumber, numberFormat: .E164).replacingOccurrences(of: "+", with: "") {
                do{
                    try result(FlyUtils.getJid(from: unformattedPhoneNumber))
                }catch _{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.JID_FETCH_FAILED,details: nil))
                }
            }
        } catch let error as NSError {
            result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.JID_FETCH_FAILED,details: error))
        
        }
        
    }

    
    func sendTextMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let txtMessage = args["message"] as? String ?? nil
        let receiverJID = args["JID"] as? String ?? ""
        let replyMessageID = args["replyMessageId"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        _ = args["editMessageId"] as? String ?? ""
        
        if(txtMessage == nil || receiverJID == ""){
            result(FlutterError(code: FLErrorCode.MISSING_PARAMS, message: FLErrorMessage.PARAMS_MISSING, details: nil))
            return
        }
        
        var messageParams = TextMessage()
        messageParams.toId = receiverJID
        messageParams.messageText = txtMessage!.trimmingCharacters(in: .whitespacesAndNewlines)
        messageParams.replyMessageId = replyMessageID // Optional
        messageParams.mentionedUsersIds = []  // Optional
        //        textMessage.metaData = META_DATA // Optional
        messageParams.topicID = topicId
        FlyMessenger.sendTextMessage(messageParams: messageParams){ isSuccess, error, chatMessage in
            if isSuccess {
                if isSuccess {
                    let textMsgResponse = chatMessage.toJson()
                    if(textMsgResponse != nil){
                        result(textMsgResponse)
                    } else {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: nil))
                    }
                }else{
                    if case let .invalid_data(message, _) = error {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if case let .unexpected(message, code) = error {
                        if code == ErrorCode.CANNOT_PROCESS{
                            result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                    }
                    
                }
            }
            
        }
        
    }
    
    func sendLocationMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let latitude = args["latitude"] as? Double ?? 00.0
        let longitude = args["longitude"] as? Double ?? 00.0
        let userJid = args["jid"] as? String ?? nil
        let topicId = args["topicId"] as? String ?? ""
        let replyMessageID = args["replyMessageId"] as? String ?? ""
        
        if(latitude == 00.0 || longitude == 00.0){
            result(FlutterError(code: FLErrorCode.MISSING_PARAMS,message: FLErrorMessage.INVALID_LOCATION,details: nil))
            return
        }
        if(userJid == nil){
            result(FlutterError(code: FLErrorCode.MISSING_PARAMS,message: FLErrorMessage.INVALID_JID,details: nil))
            return
        }
        
        var locationMessageParams = LocationMessageParams()
        locationMessageParams.latitude = latitude
        locationMessageParams.longitude = longitude
        
        var fileMessage = FileMessage()
        fileMessage.toId = userJid
        fileMessage.messageType = MessageType.location
        fileMessage.locationMessage = locationMessageParams
        fileMessage.replyMessageId = replyMessageID // Optional
        //        fileMessage.mentionedUsersIds = MENTION_IDS  // Optional
        //        fileMessage.metaData = META_DATA // Optional
        fileMessage.topicID = topicId // Optional
        
        FlyMessenger.sendMediaFileMessage(messageParams: fileMessage){ isSuccess,error,chatMessage in
            if (isSuccess) {
                let locationResponse = chatMessage?.toJson()
                print("FlyMessenger.sendLocationMessage==**==\(String(describing: locationResponse))")
                result(locationResponse)
            }else{
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
        }
        /// Deprecated
        //        FlyMessenger.sendLocationMessage(toJid: userJid!, latitude: latitude, longitude: longitude, replyMessageId: replyMessageID,topicID: topicId) { isSuccess,error,chatMessage in
        //            if isSuccess {
        //                let locationResponse = chatMessage?.toJson()
        //                print("FlyMessenger.sendLocationMessage==**==\(String(describing: locationResponse))")
        //                result(locationResponse)
        //            }else{
        //                result(FlutterError(code: "500", message: error?.localizedDescription, details: nil))
        //            }
        //        }
    }
    
    func sendImageMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? nil
        let filePath = args["filePath"] as? String ?? ""
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        
        let caption = args["caption"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        
        let imagefileUrl = URL(fileURLWithPath: filePath)
        
        
        var selectedImage : UIImage?
        
        
        let selectedImageData = NSData(contentsOf: imagefileUrl)
        
        if(selectedImageData != nil){
            selectedImage = UIImage(data: selectedImageData! as Data)
        }else{
            print("Selected Image Data is null")
        }
        
        
        if(userJid == nil){
            
            result(FlutterError(code: FLErrorCode.MISSING_PARAMS,message: FLErrorMessage.USER_PARAM_MISSING,details: nil))
            return
        }
        
        var media = MediaData()
        
        if let (_, fileName ,localFilePath,fileKey,fileSize) = MediaUtils.compressImage(imageData : selectedImageData! as Data){
            print("#media size after \(fileSize)")
            media.mediaType = .image
            media.fileURL = localFilePath
            media.fileName = fileName
            media.fileSize = fileSize
            media.fileKey = fileKey
            media.base64Thumbnail = MediaUtils.convertImageToBase64String(img: selectedImage!)
            media.caption = caption
            
        }
        
        FlyMessenger.sendImageMessage(toJid: userJid!, mediaData: media, replyMessageId: replyMessageId, mentionedUsersIds: [],topicID: topicId){isSuccess,error,message in
            if isSuccess{
                let response = message?.toJson()
                result(response)
            }else{
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                        result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
        }
    }
    
    func sendAudioMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        let isRecorded = args["isRecorded"] as? Bool ?? false
        let audiofilePath = args["filePath"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        let audiofileUrl = URL(fileURLWithPath: audiofilePath)
        
        print("audio File URL")
        print(audiofilePath)
        print(audiofileUrl.absoluteString as Any)
        
        MediaUtils.processAudio(url: audiofileUrl) { isSuccess, fileName ,localPath, fileSize, duration, fileKey  in
            print("#media \(duration)")
            if let localPathURL = localPath, isSuccess{
                var mediaData = MediaData()
                mediaData.fileName = fileName
                mediaData.fileURL = localPathURL
                mediaData.fileSize = fileSize
                mediaData.duration = duration
                mediaData.fileKey = fileKey
                mediaData.mediaType = .audio
                
                FlyMessenger.sendAudioMessage(toJid:  userJid, mediaData: mediaData, replyMessageId :  replyMessageId, isRecorded : isRecorded,topicID: topicId) { isSuccess,error,message in
                    if isSuccess && message != nil {
                        
                        let audioResponse = message?.toJson()
                        print("FlyMessenger.sendAudioMessage==**==\(String(describing: audioResponse))")
                        result(audioResponse)
                        
                    }else{
                        if case let .invalid_data(message, _) = error {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                        }else if case let .unexpected(message, code) = error {
                            if code == ErrorCode.CANNOT_PROCESS{
                                result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                            }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                                result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE, details: message))
                            }else if code == ErrorCode.NO_NETWORK{
                                result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                            }else if code == ErrorCode.FORBIDDEN{
                                result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                            }else{
                                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                            }
                        }else if case let .invalid_jid(message, _) = error {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                        }
                    }
                }
            }
        }
        
    }
    
    func isArchivedSettingsEnabled(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(ChatManager.isArchivedSettingsEnabled())
    }
    
    
    func downloadMedia(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let mediaMessageId = args["mediaMessage_id"] as? String ?? ""
        
        
        FlyMessenger.downloadMedia(messageId: mediaMessageId){ isSuccess,error,message in
            
            if isSuccess {
                result(isSuccess)
            }else{
                if case let .unexpected(message, code) = error {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.DOWNLOAD_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.DOWNLOAD_FAILED, details: error?.localizedDescription))
                }
            }
        }
    }
    
    func iOSFileExist(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let filePath = args["file_path"] as? String ?? ""
        
        let fileManagerr = FileManager.default
        
        let existsOrNot = fileManagerr.fileExists(atPath: filePath)
        
        result(existsOrNot)
    }
    
    func updateFavouriteStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        
        let messageID = args["messageID"] as? String ?? ""
        let chatUserJID = args["chatUserJID"] as? String ?? ""
        let chatType = args["chatType"] as? String ?? ""
        let isFavourite = args["isFavourite"] as? Bool ?? false
        
        var favChatType : ChatType
        if(chatType == "chat"){
            favChatType = .singleChat
        }else{
            favChatType = .groupChat
        }
        
        ChatManager.updateFavouriteStatus(messageId: messageID, chatUserId: chatUserJID, isFavourite: isFavourite, chatType: favChatType) { (isSuccess, flyError, data) in
            
            if isSuccess{
                result(isSuccess)
            }else{
                if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
            
        }
    }
    
    func getUserList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let pageNumber = args["page"] as? Int ?? 1
        let searchTerm = args["search"] as? String ?? ""
        
        let perPageResultSize = args["perPageResultSize"] as? Int ?? 20

        let metaData = args["metaDataUserList"] as? Dictionary<String, Any> ?? [:]
        print("metaData \(String(describing: metaData))")

        ContactManager.shared.getUsersList(pageNo: pageNumber, pageSize: perPageResultSize, search: searchTerm, metaData: MetaDataUserList(key: metaData["key"] as? String ?? "", value: metaData["value"] as? [String] ?? [])){ isSuccess,flyError,flyData in
            if isSuccess {
                var userList = flyData
                
                print("getUsersList\(userList)")
                if let userData = userList.getData() as? [ProfileDetails] {
                    let userDataJson = userData.toJson()
                    print("userDataJson\(String(describing: userDataJson))")
                    let totalPages = userList["totalPages"] as! Int
                    let message = userList["message"] as! String
                    var userlistJson = ""
                    if((userDataJson?.isEmpty) == nil){
                        userlistJson = "{\"total_pages\": " + String(totalPages) + ",\"message\" : \"" + message + "\",\"status\" : true,\"data\":[]}"
                    }else{
                        userlistJson = "{\"total_pages\": \(totalPages), \"message\": \"\(message)\", \"status\": true, \"data\": \(userDataJson ?? "[]")}"
                        
                    }
                    print("ContactManager.shared.getUsersList==**==\(String(describing: userlistJson))")
                    result(userlistJson)
                }
            }else{
                if case let .unexpected(message, _) = flyError {
                    
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
        
    }
    
    func getRegisteredUsers(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as? Dictionary<String, Any>
        let fromServer = args?["server"] as? Bool ?? false
        
        ContactManager.shared.getRegisteredUsers(fromServer: fromServer) {  isSuccess, flyError, flyData in
            var data  = flyData
            var list = data.getData() as? [ProfileDetails]
            list = list?.sorted { $0.nickName < $1.nickName }
            print("user list \(String(describing: list))")
            if isSuccess {
                var userData = "[]"
                if((data.getData() as? [ProfileDetails])?.count != 0){
                    userData = (list?.toJson())!
                }
                result("{\"data\":" + userData + "}")
            } else{
                if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func sendVideoMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        let caption = args["caption"] as? String ?? ""
        
        let filePath = args["filePath"] as? String ?? ""
        
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        _ = args["topicId"] as? String ?? ""
        
        let videoFileUrl = URL(fileURLWithPath: filePath)
        
        var thumbnail : UIImage?
        do {
            let asset = AVURLAsset(url: videoFileUrl, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            thumbnail = UIImage(cgImage: cgImage)
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        
        let base64Img = MediaUtils.convertImageToBase64(img: thumbnail!)
        
        
        var media = MediaData()
        
        MediaUtils.compressVideo(videoURL: videoFileUrl) { isSuccess, url, fileName, fileKey, fileSize , duration in
            if let compressedURL = url{
                
                media.mediaType = .video
                media.fileURL = compressedURL
                media.fileName = fileName
                media.fileSize = fileSize
                media.fileKey = fileKey
                media.duration = duration
                media.base64Thumbnail = base64Img
                media.caption = caption
                
                FlyMessenger.sendVideoMessage(toJid: userJid, mediaData: media, replyMessageId: replyMessageId, mentionedUsersIds: []){ isSuccess,error,message in
                    if isSuccess{
                        if let chatMessage = message {
                            let sendVideoResponse = chatMessage.toJson()
                            print("FlyMessenger.sendVideoMessage==**==\(String(describing: sendVideoResponse))")
                            result(sendVideoResponse)
                            
                        }
                    }else{
                        if case let .invalid_data(message, _) = error {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                        }else if case let .unexpected(message, code) = error {
                            if code == ErrorCode.CANNOT_PROCESS{
                                result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                            }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                                result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE, details: message))
                            }else if code == ErrorCode.NO_NETWORK{
                                result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                            }else if code == ErrorCode.FORBIDDEN{
                                result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                            }else{
                                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                            }
                        }else if case let .invalid_jid(message, _) = error {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                        }
                    }
                }
            }else{
                print("Video Compression Error")
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.COMPRESSION_FAILED, details: nil))
            }
        }
    }
    
    func generateVideoThumnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func sendContactMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        let contactName = args["contact_name"] as? String ?? ""
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        let contactList = args["contact_list"] as? [String] ?? []
        
        FlyMessenger.sendContactMessage(toJid: userJid, contactName: contactName, contactNumbers: contactList, replyMessageId: replyMessageId,topicID: topicId){ isSuccess,error,message  in
            if isSuccess{
                if message != nil {
                    let contactMessageResponse = message?.toJson()
                    print("FlyMessenger.sendContactMessage==**==\(String(describing: contactMessageResponse))")
                    result(contactMessageResponse)
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }else{
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                        result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
            
        }
    }
    
    
    func sendDocumentMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        
        let documentFilePath = args["file"] as? String ?? ""
        let documentFileUrl = URL(fileURLWithPath: documentFilePath)
        
        
        MediaUtils.processDocument(url: documentFileUrl){ isSuccess,localPath,fileSize,fileName, errorMessage in
            if !isSuccess {
                if !errorMessage.isEmpty {
                    
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: errorMessage.description))
                }
                return
            }
            if let localPathURL = localPath, isSuccess {
                var mediaData = MediaData()
                mediaData.fileName = fileName
                mediaData.fileURL = localPathURL
                mediaData.fileSize = fileSize
                mediaData.mediaType = .document
                
                FlyMessenger.sendDocumentMessage(toJid: userJid,mediaData: mediaData,replyMessageId: replyMessageId,topicID: topicId) { isSuccess, error, message in
                    if isSuccess {
                        if message != nil {
                            let documentMessageResponse = message?.toJson()
                            result(documentMessageResponse)
                            
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                        }
                    }else{
                        if case let .invalid_data(message, _) = error {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                        }else if case let .unexpected(message, code) = error {
                            if code == ErrorCode.CANNOT_PROCESS{
                                result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                            }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                                result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE, details: message))
                            }else if code == ErrorCode.NO_NETWORK{
                                result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                            }else if code == ErrorCode.FORBIDDEN{
                                result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                            }else{
                                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                            }
                        }else if case let .invalid_jid(message, _) = error {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                        }
                    }
                }
                
            } else {
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: nil))
            }
        }
    }
    
    func getProfileStatusList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let profileStatus = ChatManager.getAllStatus()
        if(profileStatus.isEmpty){
            result("[]")
        }
        
        let profileStatusJson = profileStatus.toJson()
        print("getProfileStatusList==**==\(String(describing: profileStatusJson))")
        result(profileStatusJson)
        
    }

    func insertDefaultStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let status = args["status"] as? String ?? ""
        
        ChatManager.saveProfileStatus(statusText: status, currentStatus: false) { isSuccess,error,data in
            if (isSuccess) {
                result(true)
            } else {
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: nil))
            }
        }
    }
    
    func insertNewProfileStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let newStatus = args["status"] as? String ?? ""
        
        var isAlreadyExists = false

        let dispatchGroup = DispatchGroup()

        var getAllStatus: [ProfileStatus] = []
        getAllStatus = ChatManager.getAllStatus()
        

        for status in getAllStatus {
            if(status.status == newStatus){
                isAlreadyExists = true
                dispatchGroup.enter()
                ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: true) { isSuccess,error,data in
                    if isSuccess {
                        print("#insertNewProfileStatus -> updateStatus response \(data)")
                    } else {
                        print("#insertNewProfileStatus -> updateStatus error \(String(describing: error?.localizedDescription))")
                    }
                    dispatchGroup.leave()
                }
            }else{
                dispatchGroup.enter()
                ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: false) { isSuccess,error,data in
                    if isSuccess {
                        print("#insertNewProfileStatus -> updateStatus response \(data)")
                    } else {
                        print("#insertNewProfileStatus -> updateStatus error \(String(describing: error?.localizedDescription))")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        if(!isAlreadyExists){
            dispatchGroup.enter()
            ChatManager.saveProfileStatus(statusText: newStatus, currentStatus: true) { isSuccess,error,data in
                dispatchGroup.leave()
            }
        }
            dispatchGroup.notify(queue: .main) {
                result(true)
            }

    }

    func isTrailLicence(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(isTrialLicenceKey)
    }
    
    func setMyProfileStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let statusText = args["status"] as? String ?? ""
        let statusId = args["statusId"] as? String ?? ""
        let dispatchGroup = DispatchGroup()
        var getAllStatus: [ProfileStatus] = []
        getAllStatus = ChatManager.getAllStatus()

        for status in getAllStatus {
            if(status.id == statusId) {
                dispatchGroup.enter()
                ChatManager.updateStatus(statusId: statusId ,statusText: statusText,currentStatus: true) { isSuccess,error,data in
                    if isSuccess {
                        print("#setMyProfileStatus -> updateStatus to true response \(data)")
                    } else {
                        print("#setMyProfileStatus -> updateStatus to true error \(String(describing: error?.localizedDescription))")
                    }
                    dispatchGroup.leave()
                }
            }
            else{
                dispatchGroup.enter()
                ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: false) {isSuccess,error,data in
                    if isSuccess {
                        print("#setMyProfileStatus -> updateStatus to false response \(data)")
                    } else {
                        print("#setMyProfileStatus -> updateStatus to false error \(String(describing: error?.localizedDescription))")
                    }
                    dispatchGroup.leave()
                }
            }
        }
            dispatchGroup.notify(queue: .main) {
                let statusUpdateJSON = "{\"message\": \"Status Update Success\",\"status\": true}"
                result(statusUpdateJSON)
            }
        
    }
    
    func getStatus() -> [ProfileStatus] {
        let profileStatus = ChatManager.getAllStatus()
        return profileStatus
    }
    
    func deleteProfileStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let statusId = args["id"] as? String ?? ""
        let deleteStatusResponse = ChatManager.deleteStatus(statusId: statusId)
        
        print("\(Constants.tag) deleteStatusResponse \(deleteStatusResponse)")
        
        result(true)
        
    }
    
    func isUserUnArchived(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        
        let isUserUnarchived : Bool = ChatManager.shared.isUserUnArchived(jid: userJid)
        result(isUserUnarchived)
        
    }
    func forwardMessagesToMultipleUsers(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let messageIDList = args["message_ids"] as? [String] ?? []
        let userList = args["userList"] as? [String] ?? []
        
        FlyMessenger.composeForwardMessage(messageIds: messageIDList, toJidList: userList, completionHandler: { isSuccess, flyError, flyData in
            if isSuccess{
                result(true)
            }else{
                if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: nil))
                }
            }
        })
        
    }
    
    func isMemberOfGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJid = args["jid"] as? String ?? ""
        let currentJid = AppUtils.shared.getMyJid()
        let participantJid = args["userjid"] as? String ?? currentJid
        
        
        let isMember = GroupManager.shared.isParticiapntExistingIn(groupJid: groupJid,
                                                                   participantJid: participantJid)
        
        result(isMember.doesExist)
        
    }
    func getGroupMembersList(call: FlutterMethodCall, result: @escaping FlutterResult){
            let args = call.arguments as! Dictionary<String, Any>
            let groupJid = args["jid"] as? String ?? ""
            let fetchFromServer = args["server"] as? Bool ?? false

            if(fetchFromServer){
                NotificationCenter.default.addObserver(forName: .fetchGroupMembersCompleted, object: nil, queue: .main) { notification in

                    guard let userInfo = notification.userInfo as? [String: Any],
                          let completedGroupJid = userInfo["groupJid"] as? String,
                          completedGroupJid == groupJid else {
                        print("getGroupMembersList NotificationCenter Ignoring notifications for other groupJids")
                        return
                    }

                    self.fetchGroupMembers(groupJid: groupJid, result: result)
                    NotificationCenter.default.removeObserver(self, name: .fetchGroupMembersCompleted, object: nil)
                }
                GroupManager.shared.getParticipants(groupJID: groupJid)

            }else{

                self.fetchGroupMembers(groupJid: groupJid, result: result)
            }

        }


        private func fetchGroupMembers(groupJid: String, result: @escaping FlutterResult) {

            var groupMembers = [GroupParticipantDetail]()

            groupMembers = GroupManager.shared.getGroupMemebersFromLocal(groupJid: groupJid).participantDetailArray.filter { $0.memberJid != AppUtils.shared.getMyJid() }
            let myJid = GroupManager.shared.getGroupMemebersFromLocal(groupJid: groupJid).participantDetailArray.filter { $0.memberJid == AppUtils.shared.getMyJid() }

            groupMembers = groupMembers.sorted(by: { $0.profileDetail?.name.lowercased() ?? "" < $1.profileDetail?.name.lowercased() ?? "" })
            if !myJid.isEmpty {
                groupMembers.append(contentsOf: myJid)
            }

            var groupMemberProfile: String = "["

            groupMembers.forEach { groupMember in
                if let profileDetail = groupMember.profileDetail {
                    let profileDetailJson = profileDetail.toJson()
                    print("---group members json--- \(String(describing: profileDetailJson))")
                    groupMemberProfile += (profileDetailJson ?? "") + ","
                }
            }

            if !groupMembers.isEmpty {
                groupMemberProfile = groupMemberProfile.dropLast() + "]"
            } else {
                groupMemberProfile += "]"
            }

            print("getGroupMembersList==**== \(String(describing: groupMemberProfile))")
            result(groupMemberProfile)
        }


    func enableDisableArchivedSettings(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let enableArchive = args["enable"] as? Bool ?? false
        ChatManager.enableDisableArchivedSettings(enableArchive) { isSuccess, error, data in
            if isSuccess {
                result(isSuccess)
            }else{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: nil))
            }
        }
    }
    
    func getFavouriteMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let starredMessages =  ChatManager.getFavouriteMessages()
        
        let starredMessagesJson = starredMessages.toJson()
        print("starredMessagesJson==**==\(String(describing: starredMessagesJson))")
        result(starredMessagesJson)
    }
    
    func clearAllConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        ChatManager.shared.clearAllConversation{ isSuccess, error, data in
            if isSuccess{
                result(isSuccess)
            }else{
                if case let .xmpp_connection_not_available(message, code) = error {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error?.localizedDescription))
                }
            }
            
        }
    }
    
    func getUnsentMessageOfAJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userjid = args["jid"] as? String ?? ""
        
        let savedMessage = FlyMessenger.getUnsentMessageOf(id: userjid)
        print("savedMessage\(savedMessage)")
        result(savedMessage.textContent)
        
    }
    
    func getUnsentMessageOf(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userjid = args["jid"] as? String ?? ""
        
        let savedMessage = FlyMessenger.getUnsentMessageOf(id: userjid)
        let getUnsentMessageJSON = "{\"textContent\" : \"\(savedMessage.textContent)\",\"mentionedUsers\": " + (savedMessage.mentionedUsers.toJson() ?? "[]") + "}"
        print("savedMessage toJson : \(String(describing: savedMessage.toJson()))")
        print("savedMessage : \(getUnsentMessageJSON)")
        result(getUnsentMessageJSON)
        
    }
    
    func saveUnsentMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userjid = args["jid"] as? String ?? ""
        let texMessage = args["texMessage"] as? String ?? ""
        let mentionedUsers = args["mentionedUsers"] as? [String] ?? []
        FlyMessenger.saveUnsentMessage(id: userjid, message: texMessage,mentionedUsers: mentionedUsers)
    }
    
    func getRingtoneName(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        result("[]")
        
    }
    func getDefaultNotificationUri(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        result("[]")
        
    }
    
    func verifyToken(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
        result("")
        
    }
    
    func getUserProfile(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let server = args["server"] as? Bool ?? false
        let userjid = args["jid"] as? String ?? ""
        let saveasfriend = args["saveasfriend"] as? Bool ?? false
        
        print("getting user profile from userjid-->\(userjid)")
        print("getting user profile from server-->\(server)")
        do {
            try ContactManager.shared.getUserProfile(for: userjid, fetchFromServer: server, saveAsFriend: saveasfriend){ isSuccess, flyError, flyData in
                var data  = flyData
                let profileData = data.getData() as? ProfileDetails
                print("***getUserProfile\(String(describing: profileData))")
                
                print("***getUserProfile dict\(String(describing: profileData.toJson()))")
                if isSuccess {
                    let profileJSON = "{\"data\" : " + (profileData.toJson() ?? "[]") + ",\"status\": true}"
                    print("ContactManager.shared.getUserProfile==**==\(profileJSON)")
                    result(profileJSON)
                } else{
                    
                    if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            }
        }catch{
            print("Error while calling User Profile Details")
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: nil))
        }
        
    }
    
    func updateMyProfile(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let email = args["email"] as? String ?? ""
        let mobile = args["mobile"] as? String ?? ""
        let nickName = args["name"] as? String ?? ""
        let status = args["status"] as? String ?? ""
        let image = args["image"] as? String ?? nil
        let userJid = AppUtils.shared.getMyJid()
        
        NSLog("update my profile image path --> \(String(describing: image))")
        
        if (nickName.isEmpty && mobile.isEmpty && email.isEmpty) {
            result(FlutterError(code: "400", message: "Fill All details", details: nil))
        }
        var myProfile = FlyProfile(jid: userJid)
        
        myProfile.email = email
        
        myProfile.mobileNumber = mobile
        
        myProfile.nickName = nickName
        myProfile.name = nickName
        
        myProfile.status = status
        
        if(image != nil){
            print("Image is not null if condition")
            myProfile.image = image!
        }else{
            print("Image is null else condition")
        }
        
        ContactManager.shared.updateMyProfile(for: myProfile){ isSuccess, flyError, flyData in
            if isSuccess {
                var data = flyData
                
                let message = data.getMessage()
                print("***profile Data\(data.getData() as? FlyProfile)")
                let profileUpdateResponse = data.getData() as? FlyProfile
                let profileDataJson = profileUpdateResponse?.toJson()
                print("***profile Data json \(String(describing: profileDataJson))")
                
                let profileResponseJson = "{\"status\": true ,\"message\" : \"\(message)\" ,\"data\": \(profileDataJson ?? "[]") }"
                
                print("ContactManager.shared.updateMyProfile==**==\(profileResponseJson)")
                result(profileResponseJson)
            } else{
                if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else if case let .invalid_auth_token(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_CREDENTAILS, message: FLErrorMessage.AUTHTOKEN_EXPIRED, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
                
            }
        }
        
    }
    
    func removeProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        ContactManager.shared.removeProfileImage(){ isSuccess, flyError, flyData in
            if isSuccess {
                result(isSuccess)
            } else{
                if case let .data_not_available(message, code) = flyError {
                    switch (code){
                    case 403:
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION,message: FLErrorMessage.USER_BLOCKED_MESSAGE,details: message))
                        break;
                    case _:
                        result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.METHOD_FETCH_FAILED,details: message))
                        break;
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA,message: FLErrorMessage.METHOD_FETCH_FAILED,details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func saveMyProfileDataToUserDefaults(profile : FlyProfile){
        
        self.saveMyJidAsContacts()
    }
    
    func saveMyJidAsContacts() {
        
        let profileData = ProfileDetails(jid: AppUtils.shared.getMyJid())
        profileData.name = ContactManager.getMyProfile().name
        profileData.nickName = ContactManager.getMyProfile().nickName
        profileData.mobileNumber  = ContactManager.getMyProfile().mobileNumber
        profileData.email = ContactManager.getMyProfile().email
        profileData.status = ContactManager.getMyProfile().status
        profileData.image = ContactManager.getMyProfile().image
        
        //        ContactManager.shared.saveUser(profileDetails: profileData, saveAs: .live)
    }
    
    func getMediaEndPoint(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let urlString = ChatManager.getAppConfigDetails().baseURL + "" + "media" + "/"
        result(urlString)
        
    }
    
    func updateMyProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let profileImage = args["image"] as? String ?? ""
//        let fileName = (profileImage as NSString).lastPathComponent
        
        ContactManager.shared.updateMyProfileImage(image:  profileImage){ isSuccess, flyError, flyData in
                        if isSuccess {
                            var data = flyData
                            // Profile Image updated successfully update the UI
                            NSLog("updateMyProfileImage success response\(data)")
                            let message = data.getMessage()
                            var profileUpdateResponse = data.getData() as? FlyProfile
                            let fileArray = profileUpdateResponse?.image.components(separatedBy: "/")
        
                            if let fileName = fileArray?.last {
                                profileUpdateResponse?.image = fileName
                                NSLog("updateMyProfileImage success fileName\(fileName)")
                            }
        
                            let profileDataJson = profileUpdateResponse?.toJson()
                            print("***profile Data json \(String(describing: profileDataJson))")
                            let profileResponseJson = "{\"status\": true ,\"message\" : \"\(message)\" ,\"data\": \(profileDataJson ?? "[]") }"
                            result(profileResponseJson)
                        } else{
                            NSLog("updateMyProfileImage Error\(flyError!.localizedDescription)")
                            result(FlutterError(code: "500", message: flyError!.localizedDescription, details: nil))
                        }
                }
        
    }
    
    
    
    func revokeContactSync(call: FlutterMethodCall, result: @escaping FlutterResult){
        // in iOS there is no method for Contact revoke. so passing default true value
        result(true)
        
    }
    func getUsersWhoBlockedMe(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let isFetchFromServer = args["server"] as? Bool ?? false
        
        ContactManager.shared.getUsersWhoBlockedMe(fetchFromServer: isFetchFromServer){ isSuccess, flyError, flyData in
            
            var data  = flyData
            
            if isSuccess {
                let blockedprofileDetailsArray = data.getData() as! [ProfileDetails]
                let blockedProfileJson = blockedprofileDetailsArray.toJson()
                result(blockedProfileJson)
            } else{
                if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    func getUnKnownUserProfiles(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
    }
    func getMyProfileStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
    }
    
    func getMyBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let busyStatus = ChatManager.shared.getMyBusyStatus()
        let busyStatusJson = busyStatus.toJson()
        result(busyStatusJson)
    }
    
    func setMyBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userStatus = args["status"] as? String ?? ""
        
        ChatManager.shared.setMyBusyStatus(userStatus) { isSuccess, error, data in
            if isSuccess{
                result(isSuccess)
            }else{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error?.localizedDescription))
            }
        }
    }
    func enableDisableBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let busyStatusVal = args["enable"] as? Bool ?? false
        
        ChatManager.shared.enableDisableBusyStatus(busyStatusVal){ isSuccess, error, data in
            if isSuccess{
                result(isSuccess)
            }else{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error?.localizedDescription))
            }
        }
        
    }
    
    func insertBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let busyStatus = args["busy_status"] as? String ?? ""
        print("setting busy status\(busyStatus)")
        ChatManager.shared.setMyBusyStatus(busyStatus){ isSuccess, error, data in
            if isSuccess{
                result(isSuccess)
            }else{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error?.localizedDescription))
            }
        }
    }
    
    func getBusyStatusList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let busyStatusList = ChatManager.shared.getBusyStatusList()
        print("Get Status Started profileList Count \(busyStatusList.count)")
        let busyStatusJsonList = busyStatusList.toJson()
        print("getBusyStatusList==**==\(String(describing: busyStatusJsonList))")
        result(busyStatusJsonList)
    }
    
    func deleteBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let busyId = args["id"] as? String ?? ""
        let status = args["status"] as? String ?? ""
        let isCurrentStatus = args["isCurrentStatus"] as? Bool ?? false
        
        let busyStatus = BusyStatus(statusText: status, isCurrentStatus: isCurrentStatus)
        
        print("deleteBusyStatus==**==\(busyStatus)")
        
        ChatManager.shared.deleteBusyStatus(statusId: busyId)
        
        result(true)
        
        
    }
    func enableDisableHideLastSeen(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let enableLastSeen = args["enable"] as? Bool ?? false
        
        ChatManager.enableDisableHideLastSeen(EnableLastSeen: enableLastSeen) { isSuccess, flyError, flyData in
            
            if isSuccess{
                result(isSuccess)
            }else{
                if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    func isHideLastSeenEnabled(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        result(ChatManager.isLastSeenEnabled())
    }
    func deleteMessagesForMe(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["jid"] as? String ?? ""
        let chatType = args["chat_type"] as? String ?? ""
        let isMediaDelete = args["isMediaDelete"] as? Bool ?? false
        let messageIDList = args["message_ids"] as? [String] ?? []
        
        var deleteChatType : ChatType
        if(chatType == "chat"){
            deleteChatType = .singleChat
        }else{
            deleteChatType = .groupChat
        }
        
        ChatManager.deleteMessagesForMe(toJid: jid, messageIdList: messageIDList, deleteChatType: deleteChatType,isRevokeMediaAccess: isMediaDelete) { (isSuccess, error, data) in
            if isSuccess{
                result(isSuccess)
            }else{
                if case let .unexpected(message, code) = error {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_DELETE_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_DELETE_FAILED, details: error?.localizedDescription))
                }
            }
            
        }
        
    }
    func deleteMessagesForEveryone(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let jid = args["jid"] as? String ?? ""
        let chatType = args["chat_type"] as? String ?? ""
        let isMediaDelete = args["isMediaDelete"] as? Bool ?? false
        let messageIDList = args["message_ids"] as? [String] ?? []
        
        var deleteChatType : ChatType
        if(chatType == "chat"){
            deleteChatType = .singleChat
        }else{
            deleteChatType = .groupChat
        }
        
        print("jid\(jid)")
        print("chatType\(chatType)")
        print("isMediaDelete\(isMediaDelete)")
        print("messageIDList\(messageIDList)")
        
        ChatManager.deleteMessagesForEveryone(toJid: jid, messageIdList: messageIDList, deleteChatType: deleteChatType,isRevokeMediaAccess: isMediaDelete) { (isSuccess, error, data) in
            if isSuccess{
                print("deleteMessagesForEveryone result\(isSuccess)")
                result(isSuccess)
            }else{
                if case let .unexpected(message, code) = error {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGES_DELETE_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGES_DELETE_FAILED, details: error?.localizedDescription))
                }
            }
        }
        
    }
    func markAsRead(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        
        
        ChatManager.markConversationAsRead(for: [jid])
        result(true)
    }
    func markConversationAsUnread(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jidList = args["jidlist"] as? [String] ?? []
        
        print("markConversationAsUnread jid list --> \(jidList)")
        
        ChatManager.markConversationAsUnread(for: jidList)
        result(true)
    }
    func markConversationAsRead(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jidList = args["jidlist"] as? [String] ?? []
        
        print("markConversationAsRead jid list --> \(jidList)")
        
        ChatManager.markConversationAsRead(for: jidList)
        result(true)
    }
    func getMessagesOfJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["JID"] as? String ?? ""
        print(userJid)
        let messages : [ChatMessage] = FlyMessenger.getMessagesOf(jid: userJid)
        
        if let chatJson = messages.toJson() {
            print("getMessagesOfJid==**==\(chatJson)")
            result(chatJson)
        } else {
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: nil))
        }
        
    }
    
    func markAsReadDeleteUnreadSeparator(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        
        ChatManager.markConversationAsRead(for: [jid])
        FlyMessenger.shared.deleteUnreadMessageSeparatorOfAConversation(jid: jid)
        
        result(true)
    }
    
    func deleteUnreadMessageSeparatorOfAConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        FlyMessenger.shared.deleteUnreadMessageSeparatorOfAConversation(jid: jid)
        
        result(true)
        
    }
    func getRecalledMessagesOfAConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
        //        let args = call.arguments as! Dictionary<String, Any>
        
        //        let jid = args["jid"] as? String ?? nil
        
        
    }
    func uploadMedia(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let messageid = args["messageid"] as? String ?? ""
        
        FlyMessenger.uploadMedia(messageId: messageid) { isSuccess, error, chatMessage in
            if isSuccess{
                result(true)
            }else{
                result(false)
            }
        }
        
    }
    func getMessagesUsingIds(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageIds = args["MessageIds"] as? [String] ?? []
        
        let messagesList = FlyMessenger.getMessagesUsingIds(messageIds: messageIds)
        if let chatJson = messagesList.toJson() {
            result(chatJson)
        } else {
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
        }
        
    }
    func updateMediaDownloadStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
    }
    func updateMediaUploadStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
    }
    func cancelMediaUploadOrDownload(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageId = args["messageId"] as? String ?? ""
        
        FlyMessenger.cancelMediaUploadOrDownload(messageId: messageId){ isSuccess in
            if isSuccess{
                result(true)
            }else{
                result(false)
            }
        }
        
    }
    func setMediaEncryption(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let isEncryptionEnable = args["encryption"] as? Bool ?? true
        
        ChatManager.setMediaEncryption(isEnable: isEncryptionEnable)
    }
    func deleteAllMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        _ = call.arguments as! Dictionary<String, Any>
        
    }
    func getGroupJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupId = args["groupId"] as? String ?? ""
        
        do
        {
            let groupIDResponse = try FlyUtils.getGroupJid(groupId: groupId)
            result(groupIDResponse)
            
        }catch let sdkError{
            print("\(Constants.tag) getGroupJid sdkError \(sdkError)")
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.GROUP_JID_FETCH_FAILED, details: nil))
        }
        
    }
    func updateRecentChatPinStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJID = args["jid"] as? String ?? ""
        let pin_recent_chat = args["pin_recent_chat"] as? Bool ?? false
        
        ChatManager.updateRecentChatPinStatus(jid: userJID, pinRecentChat: pin_recent_chat)
    }
    
    func updateChatMuteStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJID = args["jid"] as? String ?? ""
        let muteStatus = args["mute_status"] as? Bool ?? false
        ChatManager.updateChatMuteStatus(jid: userJID, muteStatus: muteStatus)
    }
    
    func updateChatMuteStatusList(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJidList = args["jidList"] as? [String] ?? []
        let muteStatus = args["mute_status"] as? Bool ?? false
        
        ChatManager.updateChatMuteStatus(jidList: userJidList, mute: muteStatus)
        
    }
        
    func sendTypingStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let toJid = args["to_jid"] as? String ?? ""
        let chattype = args["chattype"] as? String ?? ""
        
        var chatType : ChatType
        if(chattype == "chat"){
            chatType = .singleChat
        }else{
            chatType = .groupChat
        }
        
        ChatManager.sendTypingStatus(to: toJid, chatType: chatType)
    }
    
    func sendTypingGoneStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let toJid = args["to_jid"] as? String ?? ""
        let chattype = args["chattype"] as? String ?? ""
        
        var chatType : ChatType
        if(chattype == "chat"){
            chatType = .singleChat
        }else{
            chatType = .groupChat
        }
        
        ChatManager.sendTypingGoneStatus(to: toJid, chatType: chatType)
    }
    
    func deleteRecentChat(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJID = args["jid"] as? String ?? ""
        
        var userJIDs: [String] = []
        userJIDs.append(userJID)
        
        ChatManager.deleteRecentChats(jids: userJIDs, completionHandler: { isSuccess, flyError, flyData in
            if isSuccess{
                result(isSuccess)
            }else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.RECENT_CHAT_DELETE_FAILED, details: message))
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.RECENT_CHAT_DELETE_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.RECENT_CHAT_DELETE_FAILED, details: flyError?.localizedDescription))
                }
            }
        })
        
    }
    func deleteRecentChats(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJIDList = args["jidlist"] as? [String] ?? []
        
        ChatManager.deleteRecentChats(jids: userJIDList, completionHandler: { isSuccess, flyError, flyData in
            if isSuccess{
                result(isSuccess)
            }else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.RECENT_CHAT_DELETE_FAILED, details: message))
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.RECENT_CHAT_DELETE_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.RECENT_CHAT_DELETE_FAILED, details: flyError?.localizedDescription))
                }
            }
        })
        
    }
    func makeAdmin(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupJID = args["jid"] as? String ?? ""
        let userJID = args["userjid"] as? String ?? ""
        
        do{
            
            try GroupManager.shared.makeAdmin(groupJid: groupJID, userJid: userJID, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess {
                    result(isSuccess)
                } else{
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            })
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    
    func setNotificationSound(call: FlutterMethodCall, result: @escaping FlutterResult){
        
    }
    
    func updateGroupName(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        let groupName = args["name"] as? String ?? ""
        
        do{
            try GroupManager.shared.updateGroupName(groupJid: groupJID, groupName: groupName, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess{
                    result(isSuccess)
                }else{
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            })
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    func updateGroupProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        let groupImageFile = args["file"] as? String ?? ""
        
        do{
            try GroupManager.shared.updateGroupProfileImage(groupJid: groupJID, groupProfileImageUrl: groupImageFile, completionHandler: { isSuccess, flyError, flyData in
                
                if isSuccess{
                    result(isSuccess)
                }else{
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
                
                
            })
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    func removeGroupProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        
        do{
            try GroupManager.shared.removeGroupProfileImage(groupJid: groupJID, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess{
                    result(isSuccess)
                }else{
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            })
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    func addUsersToGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        let members = args["members"] as? [String] ?? []
        
        do{
            try GroupManager.shared.addParticipantToGroup(groupId: groupJID, newUserJidList: members, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess{
                    result(isSuccess)
                }else{
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else if case let .groupMembersValidationMessage(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.ARGUMENTS_EMPTY_OR_NULL, message: FLErrorMessage.MISSING_ARGUMENTS, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
                
            })
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    func removeMemberFromGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        let userJID = args["userjid"] as? String ?? ""
        
        do{
            try GroupManager.shared.removeParticipantFromGroup(groupId: groupJID, removeGroupMemberJid: userJID, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess{
                    result(isSuccess)
                }else{
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else if case let .groupMembersValidationMessage(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.ARGUMENTS_EMPTY_OR_NULL, message: FLErrorMessage.MISSING_ARGUMENTS, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            })
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    
    func getMessageStatusOfASingleChatMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageID = args["messageID"] as? String ?? ""
        let seenReceipt = ChatManager.getSingleChatMessageSeenReceipt(messageId: messageID)
        print("getSingleChatMessageSeenReceipt\(String(describing: seenReceipt))")
        let deliverReceipt = ChatManager.getSingleChatMessageDeliveredReceipt(messageId: messageID)
        print("deliverReceipt\(String(describing: deliverReceipt))")
        let acknowledgeReceipt = ChatManager.getSingleChatMessageAcknowledgeReceipt(messageId: messageID)
        print("acknowledgeReceipt\(String(describing: acknowledgeReceipt))")
        
        let seenResponse = String(format: "%.0f",seenReceipt?.time ?? "")
        let deliveredResponse = String(format: "%.0f",deliverReceipt?.time ?? "")
        let acknowledgeResponse = String(format: "%.0f",acknowledgeReceipt?.time ?? "")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(seenResponse == "0" ? "" : seenResponse, forKey: "seenTime")
        jsonObject.setValue(deliveredResponse == "0" ? "" : deliveredResponse, forKey: "deliveredTime")
        jsonObject.setValue(acknowledgeResponse == "0" ? "" : acknowledgeResponse, forKey: "sentTime")
        jsonObject.setValue(messageID, forKey: "messageId")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        result(jsonString)
    }
    func exportChatConversationToEmail(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJID = args["jid"] as? String ?? ""
        
        ChatManager.shared.exportChatConversationToEmail(jid: userJID) { chatDataModel in
            
            let mediaAttachmentUri = NSMutableArray()

            if !chatDataModel.mediaAttachmentsUrl.isEmpty {
                for item in chatDataModel.mediaAttachmentsUrl {

                    let file = URL(fileURLWithPath: item.path)
//                    let absolutePath = self.convertToAbsolutePath(file.path)
                    mediaAttachmentUri.add(file.path)

                }
            }


            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue(chatDataModel.subject, forKey: "subject")
            jsonObject.setValue(chatDataModel.messageContent, forKey: "messageContent")
            jsonObject.setValue(mediaAttachmentUri, forKey: "mediaAttachmentsUrl")

            let jsonString = pluginDictToJson(dictionary: jsonObject)
            result(jsonString)
        }
        
    }
    func convertToAbsolutePath(_ path: String) -> String {
        return URL(fileURLWithPath: path).absoluteString
    }
    
    func getAllGroups(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let fetchFromServer = args["server"] as? Bool ?? false
        
        print("calling getAllGroups fetchFromServer \(fetchFromServer) ---> \(ChatManager.isChatServerConnected())")
        GroupManager.shared.getGroups(fetchFromServer: fetchFromServer) { isSuccess, flyError, flyData in
            
            if isSuccess {
                var data  = flyData
                
                let groupData = data.getData() as? [ProfileDetails]
                
                let groupDataJson = groupData?.toJson()
                
            
                result(groupDataJson)
                
            } else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func searchConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let searchKey = args["searchKey"] as? String ?? ""
        _ = args["jidForSearch"] as? String ?? ""
        _ = args["globalSearch"] as? Bool ?? true
        
        let searchedMessages : [SearchMessage] = ChatManager.shared.searchMessage(text: searchKey)
        
        var searchConversationResp = "["
        var index = 0;
        for message in searchedMessages{
            if(index != 0){
                searchConversationResp = searchConversationResp + ","
            }
            index = index + 1;
            let message : ChatMessage? = FlyMessenger.getMessageOfId(messageId: message.messageId)
            
            let messageJson = message?.toJson()
            searchConversationResp = searchConversationResp + (messageJson ?? "")
        }
        
        searchConversationResp = searchConversationResp + "]"
        
        print("searchConversation==**==\(searchConversationResp)")
        
        result(searchConversationResp)
    }
    
    func isMuted(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJID = args["jid"] as? String ?? ""
        //need to check the fn
        //        result(FlyCoreController.shared.isContactMuted(jid: userJID))
        let isMuted = ContactManager.shared.getUserProfileDetails(for: userJID)?.isMuted ?? false
        result(isMuted)
    }
    
    func isBusyStatusEnabled(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(ChatManager.shared.isBusyStatusEnabled())
    }
    
    func getUserLastSeenTime(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        
        ChatManager.getUserLastSeen( for: jid) { isSuccess, flyError, flyData in
            var data  = flyData
            if isSuccess {
                let lastseenSeconds = data.getData() as? String
                if let seconds = Int(lastseenSeconds ?? "0") {
                    if (seconds == 0){
                        result("0")
                    }else{
                        let timestamp = self.subtractSecondsAndGetTimestamp(seconds: TimeInterval(seconds))
                        
                        result(String(Int(timestamp)))
                    }
                }
                
            } else{
                
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else if case let .invalid_jid(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
                
            }
        }
    }
    func subtractSecondsAndGetTimestamp(seconds: TimeInterval) -> TimeInterval {
        let currentDate = Date()
        let earlierDate = currentDate.addingTimeInterval(-seconds)
        let timestamp = earlierDate.timeIntervalSince1970 * 1000
        return timestamp
    }
    func getRecentChatList(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        ChatManager.getRecentChatList { (isSuccess, flyError, resultDict) in
            if (isSuccess) {
                var recentlist = resultDict
                let recentChatList = recentlist.getData() as? [RecentChat] ?? []
                
                if(recentChatList.isEmpty){
                    result("{\"data\": [] }")
                }else{
                    if let recentChatJson = recentChatList.toJson() {
                        let recentChatListJson = "{\"data\":" + recentChatJson + "}"
                        
                        print("ChatManager.getRecentChatList==**==\(recentChatListJson)")
                        result(recentChatListJson)
                    } else {
                        print("Failed to convert object to JSON")
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
                    }
                }
            } else {
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func getRecentChatListHistory(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let isFirstSet = args["firstSet"] as? Bool ?? true
        
        let limit = args["limit"] as? Int ?? 15
        
        recentChatListParams.limit = limit
        
        print(ChatManager.getAppConfigDetails().authtoken)

        if(recentChatListBuilder == nil){
            print("recentChatListBuilder is nil")
            recentChatListBuilder =  RecentChatListBuilder(recentChatListParams: recentChatListParams)
        }else{
            print("recentChatListBuilder already set")
        }
        if(isFirstSet){
            recentChatListBuilder =  RecentChatListBuilder(recentChatListParams: recentChatListParams)
            print("loading first set")
            recentChatListBuilder!.loadRecentChatList { isSuccess, flyError, flyData in
                var data  = flyData
                print("getRecentChatListHistory ios \(String(describing: data))")
                if (isSuccess) {
                    let recentChatArray  = data.getData() as? [RecentChat] ?? []
                    if(recentChatArray.isEmpty){
                        print("recentChatList is Empty")
                        result("{\"data\": [] }")
                    }else{
                        print("recentChatList count \(recentChatArray.count)")
                        if let recentChatJson = recentChatArray.toJson() {
                            let recentChatListJson = "{\"data\":" + recentChatJson + "}"
                            print("ChatManager.getRecentChatList==**==\(recentChatListJson)")
                            result(recentChatListJson)
                        } else {
                            print("Failed to convert object to JSON")
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
                        }
                        
                    }
                } else {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }else{
            print("loading next set")
            if(recentChatListBuilder!.hasNextRecentChatData()){
                print("Next set has data")
                recentChatListBuilder!.nextSetOfData { isSuccess, flyError, flyData in
                    var data  = flyData
                    if (isSuccess) {
                        let recentChatArray  = data.getData() as? [RecentChat] ?? []
                        
                        if(recentChatArray.isEmpty){
                            print("returning empty data")
                            result("{\"data\": [] }")
                        }else{
                            if let recentChatJson = recentChatArray.toJson() {
                                let recentChatListJson = "{\"data\":" + recentChatJson + "}"
                                print("ChatManager.getRecentChatList==**==\(recentChatListJson)")
                                result(recentChatListJson)
                            } else {
                                print("Failed to convert object to JSON")
                                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
                            }
                            
                        }
                    } else {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            }else{
                print("Next set data is not available")
                result("{\"data\": [] }")
            }
            
            
        }
    }
    
    func getRecentChatListHistoryByTopic(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let isFirstSet = args["firstSet"] as? Bool ?? true
        
        let limit = args["limit"] as? Int ?? 15
        
        let topicId = args["topicId"] as? String ?? ""
        
        topicChatListParams.limit = limit
        topicChatListParams.topicID = topicId
        
        if(topicChatListBuilder == nil){
            print("topicChatListBuilder is nil")
            topicChatListBuilder =  TopicChatListBuilder(topicChatListParams: topicChatListParams)
        }else{
            print("topicChatListBuilder already set")
        }
        if(isFirstSet){
            topicChatListBuilder =  TopicChatListBuilder(topicChatListParams: topicChatListParams)
            print("loading first set")
            topicChatListBuilder!.loadTopicBasedChatList{ isSuccess, flyError, flyData in
                var data  = flyData
                if (isSuccess) {
                    let recentChatArray  = data.getData() as? [RecentChat] ?? []
                    if(recentChatArray.isEmpty){
                        result("{\"data\": [] }")
                    }else{
                        if let recentChatJson = recentChatArray.toJson() {
                            let recentChatListJson = "{\"data\":" + recentChatJson + "}"
                            print("topicrecentChatList==**==\(recentChatListJson)")
                            result(recentChatListJson)
                        } else {
                            
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
                        }
                        
                    }
                } else {
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            }
        }else{
            print("loading next set")
            //            if(topicChatListBuilder!.hasNextRecentChatData()){
            print("Next set has data")
            topicChatListBuilder!.nextSetOfTopicBasedChatList { isSuccess, flyError, flyData in
                var data  = flyData
                if (isSuccess) {
                    let recentChatArray  = data.getData() as? [RecentChat] ?? []
                    
                    if(recentChatArray.isEmpty){
                        print("returning empty data")
                        result("{\"data\": [] }")
                    }else{
                        if let recentChatJson = recentChatArray.toJson() {
                            let recentChatListJson = "{\"data\":" + recentChatJson + "}"
                            print("topicrecentChatList==**==\(recentChatListJson)")
                            result(recentChatListJson)
                        } else {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
                        }
                        
                    }
                } else {
                    
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            }
            
        }
    }
    
    func initializeMessageList(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        
        if let messageId = args["messageId"] as? String {
            messageListParams.messageId = messageId
            
            ///setting this value for loading previos and next messages properly
            firstMessageID = messageListParams.messageId
        }else{
            messageListParams.messageId = emptyString()
            firstMessageID = emptyString()
        }
        
        if let chatId = args["userJid"] as? String {
            messageListParams.chatId = chatId
        }
        if let messageTime = args["messageTime"] as? Double {
            messageListParams.messageTime = messageTime
        }
        if let exclude = args["exclude"] as? Bool {
            messageListParams.exclude = exclude
        }
        let limit = args["limit"] as? Int ?? 50
        messageListParams.limit = limit
        
        let ascendingOrder = args["ascendingOrder"] as? Bool ?? true
        
        print("Ascending order value \(ascendingOrder)")
        
        messageListParams.ascendingOrder = ascendingOrder
        
        if let topicId = args["topicId"] as? String {
            messageListParams.topicID = topicId
        }
        

//        if let metaDataArray = args["metaDataMessageList"] as? [String: Any] {
//            let key = metaDataArray["key"] as? String ?? ""
//            let value = metaDataArray["value"] as? [String] ?? []
//            messageListParams.metaData = MetaDataMessageList(key: key, value: value)
//        }

        messageListQuery = FetchMessageListQuery(fetchMessageListParams: messageListParams)

        result(true)
        
    }
    
    func loadMessages(call: FlutterMethodCall, result: @escaping FlutterResult){

        if(messageListQuery == nil){
            NSLog("\(Constants.tag) Message List Not Initialized")
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: FLErrorMessage.MESSAGE_QUERY_EMPTY))
        }
        if(messageListQuery?.isFetchingInProgress() ?? false){
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: FLErrorMessage.MESSAGE_QUERY_PROCESSING))
        }
        messageListQuery?.loadMessages { isSuccess, flyError, flyData in
            var data  = flyData
            if (isSuccess) {
                let messageList  = data.getData() as? [ChatMessage]

                self.lastMessageID = messageList?.last?.messageId ?? emptyString()
                self.setLastMessage()
                self.firstMessageID = messageList?.first?.messageId ?? emptyString()
                self.setFirstMessage()
                
                if let chatJson = messageList.toJson() {
                    NSLog("\(Constants.tag) Initial Message List ios \(chatJson)")
                    print("\(Constants.tag) Initial Message List ios print \(chatJson)")
                    result(chatJson)
                } else {
                    NSLog("\(Constants.tag) Initial Message List Load Failed")
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
                }
            } else {
                NSLog("\(Constants.tag) Initial Message List Load Failed")
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
            }
        }
    }
    
    func loadPreviousMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        print("calling previous message")
        if(messageListQuery == nil){
            NSLog("\(Constants.tag) Message List Not Initialized")
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: FLErrorMessage.MESSAGE_QUERY_EMPTY))
            
        }
        
        if(messageListQuery?.isFetchingInProgress() ?? false){
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: FLErrorMessage.MESSAGE_QUERY_PROCESSING))
            
        }
        
        if (!(messageListQuery?.hasPreviousMessages() ?? false)){
            result("[]")
            return
        }

        messageListQuery?.setFirstMessage(messageId: firstMessageID)
        messageListQuery?.loadPreviousMessages { isSuccess, flyError, flyData in
            var data  = flyData
            if (isSuccess) {
                let messageList  = data.getData() as? [ChatMessage]


                /// Message Duplicate in load Previous workaround
                if (messageList?.count == 1 && messageList?.first?.messageId == self.firstMessageID){

                    result("[]");
                    return;

                }

                if (!(messageList?.isEmpty ?? true)) {
                    /// Changing the first message ID here, bcz the new set will be inserted at top of the chat array list,
                    /// so we need to update the first message ID to fetch the previous set of messages again from this message ID
                    self.firstMessageID = messageList?.first?.messageId ?? emptyString()
                    self.setFirstMessage()
                }else{
                    print("\(Constants.tag) prev message -> Next Message List previous message id is not setting as the list is empty")
                }

                if let chatJson = messageList.toJson() {
                    print("\(Constants.tag) Previous Message List \(chatJson)")
                    
                    result(chatJson)
                    
                } else {
                    NSLog("\(Constants.tag) Previous Message List Load Failed")
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
                }
            } else {
                NSLog("\(Constants.tag) Initial Message List Load Failed")
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
            }
        }
    }

    func loadNextMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        if(messageListQuery == nil){
            NSLog("\(Constants.tag) Message List Not Initialized")
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: FLErrorMessage.MESSAGE_QUERY_EMPTY))
            return
        }
        
        if (!(messageListQuery?.hasNextMessages() ?? false)){
            result("[]")
            return
        }
        
        messageListQuery?.loadNextMessages { isSuccess, flyError, flyData in
            var data  = flyData
            if (isSuccess) {
                let messageList  = data.getData() as? [ChatMessage]
                
                if (!(messageList?.isEmpty ?? true)){
                    /// Changing the last message ID here, bcz the new set will be appended to the chat array list,
                    /// so we need to update the last message ID to fetch the next set of messages again from this message ID
                    self.lastMessageID = messageList?.last?.messageId ?? emptyString()
                    self.setLastMessage()
                }else{
                    print("\(Constants.tag) Next Message List last message id is not setting as the list is empty")
                }
                if(self.firstMessageID.isEmpty){
                    self.firstMessageID = messageList?.first?.messageId ?? emptyString()
                    self.setFirstMessage()
                }

                if let chatJson = messageList.toJson() {
                    print("\(Constants.tag) Next Message List \(chatJson)")
                    result(chatJson)
                } else {
                    NSLog("\(Constants.tag) Next Message List Load Failed")
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.JSON_PARSING_ERROR, details: nil))
                }
            } else {
                NSLog("\(Constants.tag) Initial Message List Load Failed")
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
            }
        }
    }
    
    func setLastMessage(messageID: String? = nil){
        messageListQuery?.setLastMessage(messageId: messageID ?? lastMessageID)
        if messageID != nil {
            lastMessageID = messageID ?? emptyString()
        }
    }
    
    func setFirstMessage(messageID: String? = nil){
        messageListQuery?.setFirstMessage(messageId: messageID ?? firstMessageID)
        if messageID != nil {
            firstMessageID = messageID ?? emptyString()
        }
    }
    
    
    func getRecentChatListIncludingArchived(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let recentChatList = ChatManager.getRecentChatListIncludingArchived()
        let recentChatListJson = recentChatList.toJson()
        print("getRecentChatListIncludingArchived==**==\(String(describing: recentChatListJson))")
        result(recentChatListJson)
    }
    
    func getRecentChatOf(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        print("getRecentChatOf jid --> \(String(describing: jid))")
        let recentChat = ChatManager.getRecentChatOf(jid:jid)
        print("recentChat-->\(String(describing: recentChat))")
        if(recentChat == nil){
            result(nil)
            return
        }
        
        let recentChatJson = recentChat?.toJson()
        print("getRecentChatOf==**==\(String(describing: recentChatJson))")
        result(recentChatJson)
    }
    func recentChatPinnedCount(call: FlutterMethodCall, result: @escaping FlutterResult){
        let recentPinCount = ChatManager.recentChatPinnedCount()
        result(recentPinCount)
    }
    
    func setOnGoingChatUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        ChatManager.setOnGoingChatUser(jid: userJid)
    }
    func reportUserOrMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        
        let reportMessage : ReportMessage? = ChatManager.getMessagesForReporting(chatUserJid: userJid, messagesCount: 5)
        
        let reportMessageJson = reportMessage?.toJson()
        print("reportUserOrMessages==**==\(String(describing: reportMessageJson))")
        if(reportMessageJson != nil){
            result(true)
        }else{
            result(false)
        }
        
    }
    func blockUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["userJID"] as? String ?? ""
        
        do{
            
            try ContactManager.shared.blockUser(for: userJid){ isSuccess, flyError, flyData in
                
                if isSuccess {
                    let blockUserResponseJson = flyData.dictToJson()
                    print("ContactManager.shared.blockUser==**==\(String(describing: blockUserResponseJson))")
                    result(true)
                } else{
                    
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            }
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_CREDENTAILS, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    func unblockUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["userJID"] as? String ?? ""
        
        do{
            
            try ContactManager.shared.unblockUser(for: userJid){ isSuccess, flyError, flyData in
                
                if isSuccess {
                    result(true)
                } else{
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            }
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    func createGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupName = args["group_name"] as? String ?? ""
        let file = args["file"] as? String ?? ""
        let members = args["members"] as? [String] ?? []
        do{
            var localFileUrl = ""
            if (file != ""){
                let sourceURL = URL(fileURLWithPath: file)
                print("****sourceURL \(sourceURL)")
                let fileName = (file as NSString).lastPathComponent
                print("file name" + fileName)
                if let fileUrl = AppUtils.shared.saveFile(from: sourceURL, fileName: fileName) {
                    print("File saved at: \(fileUrl)")
                    localFileUrl = fileUrl
                    
                }
            }
            
            try GroupManager.shared.createGroup(groupName: groupName, participantJidList: members, groupImageFileUrl: localFileUrl, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess {
                    var data = flyData
                    print("create group\(flyData)")
                    
                    let groupProfileData = data.getData() as? ProfileDetails
                    
                    let groupProfileDataJson = groupProfileData?.toJson()
                    print("GroupManager.shared.createGroup==**==\(String(describing: groupProfileDataJson))")
                    let groupId = groupProfileData?.jid.components(separatedBy: "@")
                    let jsonDictionary: [String: Any] = [
                        "groupId": groupId?[0] ?? "",
                        "groupMembers": members,
                        "groupName": groupProfileData?.name ?? "",
                        "groupProfileImage": groupProfileData?.image ?? ""
                    ]
                    result(jsonDictionary.dictToJson())
//                    result(true)
                } else{
                    
                    if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_auth_token(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_CREDENTAILS, message: FLErrorMessage.AUTHTOKEN_EXPIRED, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            })
        }catch let error{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
        }
        
    }
    
    func clearChat(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        let userChatType = args["chat_type"] as? String ?? ""
        let clearExceptStarred = args["clear_except_starred"] as? Bool ?? false
        
        var chatType : ChatType?
        if(userChatType == "chat"){
            chatType = .singleChat
        }else{
            chatType = .groupChat
        }
        
        //        let lastMessageId = ChatManager.getLastMessageId(jid: userJid)
        
        ChatManager.clearChat(toJid: userJid, chatType: chatType!, clearChatExceptStarred: clearExceptStarred) { (isSuccess, flyError, resultDict) in
            
            if(isSuccess){
                self.lastMessageID = emptyString()
                self.setLastMessage()
                self.firstMessageID = emptyString()
                self.setFirstMessage()
                result(true)
            }else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
        
    }
    func getUsersIBlocked(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let fetchFromServer = args["serverCall"] as? Bool ?? false
        
        
        ContactManager.shared.getUsersIBlocked(fetchFromServer: fetchFromServer){ isSuccess, flyError, flyData in
            
            var data  = flyData
            
            if isSuccess {
                let blockedprofileDetailsArray = data.getData() as! [ProfileDetails]
                let blockedProfileJson = blockedprofileDetailsArray.toJson()
                print("ContactManager.shared.getUsersIBlocked==**==\(String(describing: blockedProfileJson))")
                result(blockedProfileJson)
            } else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
        
    }
    func getMediaMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        ChatManager.getVideoImageAudioMessageGroupByMonth(jid: userJid) { isSuccess,flyError,data  in
            
            if isSuccess {
                var mediaData = data
                let chatMessages = mediaData.getData() as? [[ChatMessage]]
                
                if(chatMessages!.isEmpty){
                    result("[]")
                }else{
                    var mediaMsgJson = chatMessages?.toJson()
                    mediaMsgJson = mediaMsgJson?.replacingOccurrences(of: "[[", with: "[")
                    mediaMsgJson = mediaMsgJson?.replacingOccurrences(of: "]]", with: "]")
                    print("ChatManager.getVedioImageAudioMessageGroupByMonth==**==\(String(describing: mediaMsgJson))")
                    result(mediaMsgJson)
                }
                
            }else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
        
    }
    func getDocsMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        
        
        ChatManager.getDocumentMessageGroupByMonth(jid: userJid) { isSuccess, flyError, data in
            if isSuccess{
                var flydata = data
                let mediaMessages : [[ChatMessage]] = flydata.getData() as? [[ChatMessage]] ?? []
                if (mediaMessages.isEmpty){
                    result("[]")
                }else{
                    var mediaMsgJson = mediaMessages.toJson()
                    mediaMsgJson = mediaMsgJson?.replacingOccurrences(of: "[[", with: "[")
                    mediaMsgJson = mediaMsgJson?.replacingOccurrences(of: "]]", with: "]")
                    print("ChatManager.getDocumentMessageGroupByMonth==**==\(String(describing: mediaMsgJson))")
                    result(mediaMsgJson)
                }
            }else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
        
    }
    
    func getLinkMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        
        ChatManager.getLinkMessageGroupByMonth(jid: userJid) { isSuccess, flyError, data  in
            if isSuccess{
                var flydata = data
                let mediaLinkMessages = flydata.getData() as? [[LinkMessage]] ?? []
                
                if (mediaLinkMessages.isEmpty){
                    result("[]")
                }else{
                    var viewAllMediaLinkMessages: String = "["
                    
                    mediaLinkMessages.forEach { mediaLinkMessage in
                        mediaLinkMessage.forEach{ linkChatMessage in
                            let mediaMsgJson = linkChatMessage.chatMessage.toJson()
                            
                            viewAllMediaLinkMessages = viewAllMediaLinkMessages + (mediaMsgJson ?? "") + ","
                            
                        }
                        
                    }
                    viewAllMediaLinkMessages = viewAllMediaLinkMessages.dropLast() + "]"
                    print("ChatManager.getLinkMessageGroupByMonth\(viewAllMediaLinkMessages)")
                    
                    result(viewAllMediaLinkMessages)
                }
            }else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .unexpected(message, code) = flyError {
                    if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func isAdmin(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJid = args["group_jid"] as? String ?? ""
        let userJid = args["jid"] as? String ?? ""
        
        result(GroupManager.shared.isAdmin(participantJid: userJid, groupJid: groupJid).isAdmin)
        
    }
    func leaveFromGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJid = args["groupJid"] as? String ?? ""
        let userJid = args["userJid"] as? String ?? ""
        
        try! GroupManager.shared.leaveFromGroup(groupJid: groupJid, userJid: userJid) { isSuccess,error,data in
            result(isSuccess)
        }
    }
    
    func getMediaAutoDownload(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(ChatManager.isAutoDownloadEnabled())
    }
    
    func setMediaAutoDownload(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let autoDownloadEnable = args["enable"] as? Bool ?? false
        //        FlyDefaults.autoDownloadEnable = autoDownloadEnable
        //        FlyDefaults.autoDownloadLastEnabledTime = autoDownloadEnable ? FlyUtils.getTimeInMillis() : 0
        ChatManager.shared.enableAutoDownload(isEnable: autoDownloadEnable)
        result(true)
    }
    
    func getMediaSetting(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let networkType = args["NetworkType"] as? Int ?? 0
        let type = args["type"] as? String ?? ""
        
        if (networkType == 0){
            let autoDownloadMobile = ChatManager.autoDownloadMobileConfig()
            switch (type) {
            case "Photos":
                result(autoDownloadMobile[AutoDownloadType.photo.rawValue] ?? false)
            case "Videos":
                result(autoDownloadMobile[AutoDownloadType.videos.rawValue] ?? false)
            case "Audio":
                result(autoDownloadMobile[AutoDownloadType.audio.rawValue] ?? false)
            case "Documents":
                result(autoDownloadMobile[AutoDownloadType.documents.rawValue] ?? false)
            default:
                result(false)
            }
            
        }else{
            let autoDownloadWiFi = ChatManager.autoDownloadWiFiConfig()
            switch (type) {
            case "Photos":
                result(autoDownloadWiFi[AutoDownloadType.photo.rawValue] ?? false)
            case "Videos":
                result(autoDownloadWiFi[AutoDownloadType.videos.rawValue] ?? false)
            case "Audio":
                result(autoDownloadWiFi[AutoDownloadType.audio.rawValue] ?? false)
            case "Documents":
                result(autoDownloadWiFi[AutoDownloadType.documents.rawValue] ?? false)
            default:
                result(false)
            }
        }
    }
    
    func saveMediaSettings(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let isPhotoEnabled = args["Photos"] as? Bool ?? false
        let isVideoEnabled = args["Videos"] as? Bool ?? false
        let isAudioEnabled = args["Audio"] as? Bool ?? false
        let isDocumentEnabled = args["Documents"] as? Bool ?? false
        let networkType = args["NetworkType"] as? Int ?? 0
        
        if (networkType == 0){//cellular
            
            ChatManager.updateAutoDownloadMobile(type: .photo, enable: isPhotoEnabled)
            ChatManager.updateAutoDownloadMobile(type: .videos, enable: isVideoEnabled)
            ChatManager.updateAutoDownloadMobile(type: .audio, enable: isAudioEnabled)
            ChatManager.updateAutoDownloadMobile(type: .documents, enable: isDocumentEnabled)
            
        }else{//WIFI
            ChatManager.updateAutoDownloadWiFi(type: .photo, enable: isPhotoEnabled)
            ChatManager.updateAutoDownloadWiFi(type: .videos, enable: isVideoEnabled)
            ChatManager.updateAutoDownloadWiFi(type: .audio, enable: isAudioEnabled)
            ChatManager.updateAutoDownloadWiFi(type: .documents, enable: isDocumentEnabled)
            
        }
    }
    
    func updateArchiveUnArchiveChat(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        let archive = args["isArchived"] as? Bool ?? false
        
        var userJidList = [] as [String]
        userJidList.append(userJid)
        
        /* //This method is used only to notify the local DB
         if(archive){
         print("Archiving chat")
         print("Archiving chat jid \(userJidList)")
         ChatManager.archiveChatConversation(jidsToArchive: userJidList)
         }else{
         print("UnArchiving chat")
         print("UnArchiving chat jid \(userJidList)")
         ChatManager.unarchiveChatConversation(jidsToUnarchive: userJidList)
         }*/
        
        ChatManager.updateArchiveUnArchiveChat(userJidList, archive) { (isSuccess, flyError, resultDict) in
            
            if isSuccess {
                var flydata = resultDict
                print(flydata.getData())
                
                result(isSuccess)
            }else{
                //archive/unarchive chat failed
                
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
            }
            
        }
        
        
        
    }
    func logoutOfChatSDK(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        NSLog("#VOIP ******* logging out")
        ChatManager.logoutApi { isSuccess, flyError, flyData in
            if isSuccess {
                //        ChatManager.enableContactSync(isEnable: ENABLE_CONTACT_SYNC)
                ChatManager.disconnect()
                if (CallManager.isCallConnected() || CallManager.isOngoingCall()){
                    CallManager.disconnectCall()
                    CallManager.disconnectCallServers()
                }
                ChatManager.shared.resetFlyDefaults()
                self.recentChatListBuilder = nil
//                self.recentChatListParams = nil
                self.messageListParams = FetchMessageListParams()
                self.messageListQuery = nil
                //Utility.clearUserDefaults()
                Utility.saveInPreference(key: Constants.isProfileSaved, value: false)
                Utility.saveInPreference(key: Constants.isLoggedIn, value: false)
                result(isSuccess)
            }else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func getMessageOfId(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let messageId = args["mid"] as? String ?? ""
        
        let message : ChatMessage? = FlyMessenger.getMessageOfId(messageId: messageId)
        
        let messageJson = message?.toJson()
        print("getMessageOfId==**==\(messageId) --> \(String(describing: messageJson))")
        result(messageJson)
        
    }
    func getArchivedChatList(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        ChatManager.getArchivedChatList { (isSuccess, flyError, resultDict) in
            if isSuccess {
                var flydata = resultDict
                print(flydata.getData())
                
                let archiveData = flydata.getData() as? [RecentChat] ?? []

                if(archiveData.isEmpty){
                    result("{\"data\": [] }")
                }else{
                    
                    let archiveChatJson = archiveData.toJson()
                    
                    let archiveChatListJson = "{\"data\":" + (archiveChatJson ?? "[]") + "}"
                    print("ChatManager.getArchivedChatList==**==\(String(describing: archiveChatJson))")
                    result(archiveChatListJson)
                }
                
            }else{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
            }
        }
    }
    
    func getGroupProfile(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["groupJid"] as? String ?? ""
        let fromServer = args["server"] as? Bool ?? false
        do {
            try GroupManager.shared.getGroupProfile(groupJid: groupJid, fetchFromServer: fromServer) { isSuccess, flyError, flyData in
                if isSuccess {
                    var resp = flyData
                    let profileData = resp.getData() as? ProfileDetails
                    print("ContactManager.shared.getGroupProfile==**==\(String(describing: profileData?.toJson()))")
                    result(profileData?.toJson())
                } else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }catch{
            print("Error while calling Group Profile Details")
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: nil))
        }
        
    }
    
    func getProfileDetails(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        print(userJid)
        
        if(userJid.isEmpty){
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: nil))
            return
        }
        
        let userProfile = ChatManager.profileDetaisFor(jid: userJid)
        print("userProfile*** \(String(describing: userProfile))")
        
        if(userProfile == nil){
            do {
                try ContactManager.shared.getUserProfile(for: userJid, fetchFromServer: true, saveAsFriend: true){ isSuccess, flyError, flyData in
                    var data  = flyData
                    let profileData = data.getData() as? ProfileDetails
                    print("***getUserProfile\(String(describing: profileData))")
                    
                    print("***getUserProfile dict\(String(describing: profileData.toJson()))")
                    if isSuccess {
                        //                                 let profileJSON = "{\"data\" : " + (profileData.toJson() ?? "[]") + ",\"status\": true}"
                        //                                print("ContactManager.shared.getUserProfile==**==\(profileData.toJson())")
                        result(profileData.toJson())
                    } else{
                        
                        if case let .invalid_data(message, _) = flyError {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }else if case let .invalid_jid(message, _) = flyError {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                        }else if case let .unexpected(message, _) = flyError {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }else if case let .xmpp_connection_not_available(message, code) = flyError {
                            if code == ErrorCode.NO_NETWORK{
                                result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                            }else{
                                result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                            }
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                        }
                    }
                }
            }catch{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: nil))
            }
            
        }else{
            let userProfileJson = userProfile.toJson()
            print("getProfileDetails==**==\(String(describing: userProfileJson))")
            result(userProfileJson)
        }
        
    }
    func deleteAccount(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let deleteReason = args["delete_reason"] as? String ?? ""
        let deleteFeedback = args["delete_feedback"] as? String ?? ""
        ContactManager.shared.deleteMyAccountRequest(reason: deleteReason, feedback: deleteFeedback) { isSuccess, flyError, flyData in
            var data  = flyData
            print(data.getMessage() as! String )
            if isSuccess {
                Utility.clearUserDefaults()
                let deleteResponseJson = data.dictToJson()
                print("ContactManager.shared.deleteMyAccountRequest==**==\(String(describing: deleteResponseJson))")
                result(true)
            } else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else if case let .fields_empty(message, _) = flyError{
                    result(FlutterError(code: FLErrorCode.ARGUMENTS_EMPTY_OR_NULL, message: FLErrorMessage.MISSING_ARGUMENTS, details: message))
                }
                else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
        
    }
    func getGroupMessageDeliveredToList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageId = args["messageId"] as? String ?? ""
        let jid = args["jid"] as? String ?? ""
        let groupMessageDeliveredList = GroupManager.shared.getMessageDeliveredListBy(messageId: messageId, groupId: jid)
        print("groupMessageDeliveredList=>\(groupMessageDeliveredList)")
        let deliveredCount = groupMessageDeliveredList.deliveredCount
        let totalParticipatCount = groupMessageDeliveredList.totalParticipatCount
        
        let groupMessageDeliveredListJson = groupMessageDeliveredList.deliveredParticipantList.toJson() ?? "[]"
        
        let deliveredListJson = "{\"count\": \"\(String(deliveredCount))\",\"totalParticipantCount\" : \(String(totalParticipatCount)),\"participantList\" : " + groupMessageDeliveredListJson + "}"
               

               print("getGroupMessageDeliveredToList==**==\(String(describing: deliveredListJson))")
               result(deliveredListJson)
    }
    
    func getGroupMessageReadByList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageId = args["messageId"] as? String ?? ""
        let jid = args["jid"] as? String ?? ""
        //need to check response.
        let groupMessageReadList = GroupManager.shared.getMessageSeenListBy(messageId: messageId, groupId: jid)
        print("groupMessageReadList=> \(groupMessageReadList)")
        
        let deliveredCount = groupMessageReadList.seenCount
        let totalParticipatCount = groupMessageReadList.totalParticipatCount
        let groupMessageReadListJson = groupMessageReadList.seenParticipantList.toJson() ?? "[]"
        
        let readListJson = "{\"count\": \"\(String(deliveredCount))\",\"totalParticipantCount\" : \(String(totalParticipatCount)),\"participantList\" : " + groupMessageReadListJson + "}"
                
                
                print("getGroupMessageReadByList==**==\(String(describing: readListJson))")
                result(readListJson)
        
    }
    func addContact(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let number = args["number"] as? String ?? ""
        let userName = args["name"] as? String ?? ""
        
        print("#Add Mobile Number \(number)")
        let contact = CNMutableContact()
        
        let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue : number ))
        
        contact.phoneNumbers = [homePhone]
        contact.givenName = userName
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        do{
            try CNContactStore().execute(saveRequest)
        }catch let error{
            print("#Plugin Error ---> Unable to Add Contact, \(error.localizedDescription)")
            result(false)
        }
        result(true)
    }
    func setDefaultNotificationSound(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        result("")
    }
    func deleteGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["jid"] as? String ?? ""
        
        do{
            try GroupManager.shared.deleteGroup(groupJid: groupJid, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess{
                    result(isSuccess)
                }else{
                    if case let .invalid_data(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                    }else if case let .unexpected(message, code) = flyError {
                        if code == ErrorCode.FORBIDDEN{
                            result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                        }
                    }else if case let .invalid_jid(message, _) = flyError {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                    }else if case let .xmpp_connection_not_available(message, code) = flyError {
                        if code == ErrorCode.NO_NETWORK{
                            result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                        }
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                    }
                }
            })
        }catch let error{
            //            result(false)
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: error.localizedDescription))
            
        }
        
        
    }
    
    func updateFcmToken(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let token = args["token"] as? String ?? ""
        
        if Utility.getBoolFromPreference(key: Constants.isLoggedIn) {
            VOIPManager.sharedInstance.savePushToken(token: token)
            Utility.saveInPreference(key: Constants.googleToken, value: token)
            VOIPManager.sharedInstance.updateDeviceToken()

            result(true)
        }else {
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.NOT_LOGGED_IN_MESSAGE, details: nil))
        }
    }
    
    func handleReceivedMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        NSLog("#Mirrorfly handleReceivedMessage")
        
    }
    func getUnreadMessageCountExceptMutedChat(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let (messageCount, chatCount) = ChatManager.getUnreadMessageAndChatCountForUnmutedUsers()
        
        print("chatCount \(chatCount)")
        
        result(messageCount)
        
    }
    
    func getUnreadMessagesCount(call: FlutterMethodCall, result: @escaping FlutterResult){
        let (messageCount, chatCount) = ChatManager.getUNreadMessageAndChatCount()
        result(messageCount)
    }
    
    func createTopic(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let topicName = args["topicName"] as? String ?? ""
        let metaData = args["metaData"] as? [[String: Any]] ?? []
        print("metaData \(String(describing: metaData))")
        var metaDataArray : [MetaData] = []
        for data in metaData {
            let obj = MetaData(key: data["key"] as? String ?? "", value: data["value"] as? String ?? "")
            metaDataArray.append(obj)
        }
        ChatManager.createTopic(topicName: topicName,metaData: metaDataArray) { isSuccess, flyError, data in
            print("createTopic ==**==\(data)")
            if isSuccess{
                var resp = data
                if let response = resp.getData() as? [String: Any] {
                    if let topicId = response["topicId"] as? String {
                        result(topicId)
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.CREATE_TOPIC_FAILED, details: nil))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.CREATE_TOPIC_FAILED, details: nil))
                }
            }else{
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func getAvailableFeatures(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let availableFeatures = ChatManager.getAvailableFeatures()
        print("Available Features \(availableFeatures)")
        //        print("Available Features \(availableFeatures.toJson())")
        //        availableFeatures.toJson()
        result(availableFeatures.toJson())
    }
    
    func getTopics(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let topicIds = args["topicIds"] as? [String] ?? []
        ChatManager.getTopics(topicIds: topicIds) { isSuccess, flyError, data in
            if isSuccess{
                var resp = data
                if let response = resp.getData() as? [String: Any] {
                    if let topics = response["topics"] as? [[String: Any]] {
                        print("getTopics ==**==\(topics.toJSONString())")
                        result(topics.toJSONString())
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.FETCH_TOPIC_FAILED, details: nil))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.FETCH_TOPIC_FAILED, details: nil))
                }
            }else{
                print("getTopics error \(String(describing: flyError?.localizedDescription))")
                //                result(FlutterError(code: "807",message: error?.localizedDescription,details: nil))
                if case let .invalid_data(message, _) = flyError {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: message))
                }else if case let .xmpp_connection_not_available(message, code) = flyError {
                    if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.NOT_CONNECTED_TO_XMPP, message: FLErrorMessage.NOT_CONNECTED_TO_XMPP_MESSAGE, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.METHOD_FETCH_FAILED, details: flyError?.localizedDescription))
                }
            }
        }
    }
    
    func setRegionCode(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let regionCode = args["regionCode"] as? String ?? "IN"
        do {
            try ChatManager.shared.setUserCountryISOCode(isoCode: regionCode)
        } catch (let error ){
            print("#FlyChat Exception : \(error.localizedDescription)")
        }
    }
    
    func hasPreviousMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        if messageListQuery != nil {
            result(messageListQuery?.hasPreviousMessages())
        }else{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_QUERY_EMPTY, details: nil))
        }
    }
    
    func hasNextMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        if messageListQuery != nil {
            result(messageListQuery?.hasNextMessages())
        }else{
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_QUERY_EMPTY, details: nil))
        }
    }
    func appLaunchedFromMissedCall(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(false)
    }
    
    func sendMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let receiverJID = args["toJid"] as? String
        
        if receiverJID == "" || receiverJID == nil{
            result(FlutterError(code: FLErrorCode.MISSING_PARAMS,message: FLErrorMessage.INVALID_JID,details: nil))
            return
        }
        
        /// When a user logs in and sends a message without loading Recent Chats or Groups,
        /// the message won't be sent if the profile details for the particular JID do not exist in the local database.
        /// To handle this, we first try to fetch the profile details locally.
        /// If the profile response is nil, we fetch the profile details from the server, which will store them in the database.
        /// Once the profile details are retrieved and stored, the message can be sent without any issue.

        let profileResponse = ContactManager.shared.getUserProfileDetails(for: receiverJID!)
        
        print("Send Message Profile Response \(String(describing: profileResponse))")
        
        if profileResponse == nil {
            print("Profile does not exist locally, so fetching it from server")
            if receiverJID!.contains("@mix") {
                do {
                    try GroupManager.shared.getGroupProfile(groupJid: receiverJID!, fetchFromServer: true) { isSuccess, flyError, flyData in
                        if isSuccess {
                            GroupManager.shared.getParticipants(groupJID: receiverJID!)
                            print("Group Profile Fetching Success from server")
                            self.processAndSendMessage(args: args, call: call, result: result)
                        } else{
                            print("Group Profile Fetching Error \(String(describing: flyError?.localizedDescription))")
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: flyError?.localizedDescription))
                        }
                    }
                }catch let error {
                    print("Group Profile Fetching Error \(error.localizedDescription)")
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error.localizedDescription))
                }
            } else {
                do {
                    try ContactManager.shared.getUserProfile(for: receiverJID!, fetchFromServer: true, saveAsFriend: true){ isSuccess, flyError, flyData in
                        
                        if isSuccess {
                            print("Profile Fetching Success from server")
                            self.processAndSendMessage(args: args, call: call, result: result)
                        } else{
                            print("Profile Fetching Error \(String(describing: flyError?.localizedDescription))")
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: flyError?.localizedDescription))
                        }
                    }
                }catch let error {
                    print("Group Profile Fetching Error \(error.localizedDescription)")
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error.localizedDescription))
                }
            }
        }else{
            processAndSendMessage(args: args, call: call, result: result)
        }
    }
    
    private func processAndSendMessage(args : Dictionary<String, Any>, call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let messageType = args["messageType"] as? String
        let receiverJID = args["toJid"] as? String
        let replyMessageID = args["replyMessageId"] as? String
        let topicId = args["topicId"] as? String
        let mentionedUsersIds = args["mentionedUsersIds"] as? [String] ?? []
        let metaData = args["metaData"] as? [[String: Any]] ?? []
        print("\(String(describing: messageType)) MetaData \(String(describing: metaData))")
        var metaDataArray : [MessageMetaData] = []
        for data in metaData {
            let obj = MessageMetaData(key: data["key"] as? String ?? "", value: data["value"] as? String ?? "")
            metaDataArray.append(obj)
        }

        if let sendingMessageType = FlyMessageType.fromString(messageType ?? "") {
            print("\(Constants.tag) sendMessage -> Messsage Type \(sendingMessageType)")
            switch sendingMessageType {
            case .TEXT:
                var messageParams = TextMessage()
                messageParams.toId = receiverJID
                messageParams.messageText =
                (AppUtils.shared.getValueForKey(dictionary: args["textMessage"] as? Dictionary<String, Any>, key: "messageText") as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                messageParams.replyMessageId = replyMessageID
                messageParams.mentionedUsersIds = mentionedUsersIds
                messageParams.metaData = metaDataArray
                messageParams.topicID = topicId
                
                self.sendText(textMessageParams: messageParams, call: call, result: result)
                
                break;
            case .IMAGE:
                
                let fileDictArg = args["fileMessage"] as? Dictionary<String, Any>
                let compressionType: Int? = args["mediaCompressionType"] as? Int
                let filePathArg = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "file") as? String ?? ""
                //                let fileDuration = AppUtils.shared.getValueForKey(dictionary: fileDict, key: "duration") as? Int ?? 0
                _ = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "fileSize") as? Int ?? 0
                let fileThumbImageArg = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "thumbImage") as? String ?? ""
                let fileNameArg = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "fileName") as? String ?? ""
                let fileCaptionArg = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "caption") as? String ?? ""

                let imagefileUrl = URL(fileURLWithPath: filePathArg)
                
                
                var selectedImage : UIImage?
                
                
                let selectedImageData = NSData(contentsOf: imagefileUrl)
                
                if(selectedImageData != nil){
                    selectedImage = UIImage(data: selectedImageData! as Data)
                }else{
                    print("Selected Image Data is null")
                }
                
                let mediaCompressionQuality: MediaQuality = AppUtils.shared.getMediaCompressionType(type: compressionType)
                MediaUtils.compressImageFile(imageData:  selectedImageData! as Data, mediaQuality: mediaCompressionQuality) { isSuccess, data,
                    fileName, localFilePath, fileKey, fileSize, errorMessage  in
                    if isSuccess{
                        
                        let mediaParams = FileMessageParams(fileUrl: localFilePath!, fileName: fileNameArg == "" ? fileName : fileNameArg,  caption : fileCaptionArg, fileSize: fileSize, duration: 0.0, thumbImage: fileThumbImageArg == "" ? MediaUtils.convertImageToBase64String(img: selectedImage!) : fileThumbImageArg, fileKey: fileKey)
                        
                        let imageFileMessage = FileMessage(toId: receiverJID!, messageType: .image, fileMessage : mediaParams, replyMessageId : replyMessageID, mentionedUsersIds: mentionedUsersIds, metaData: metaDataArray, topicID: topicId)
                        
                        self.sendImage(imageMessageParams: imageFileMessage, call: call, result: result)
                        
                        
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: errorMessage?.description))
                    }
                }
                break;
                
            case .VIDEO:
                let fileDictArg = args["fileMessage"] as? Dictionary<String, Any>
                let compressionType: Int? = args["mediaCompressionType"] as? Int
                let filePathArg = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "file") as? String ?? ""
                //                let fileDuration = AppUtils.shared.getValueForKey(dictionary: fileDict, key: "duration") as? Int ?? 0
                _ = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "fileSize") as? Int ?? 0
                _ = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "thumbImage") as? String ?? ""
                _ = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "fileName") as? String ?? ""
                let fileCaptionArg = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "caption") as? String ?? ""

                let videoFileUrl = URL(fileURLWithPath: filePathArg)
                
                var thumbnail : UIImage?
                do {
                    let asset = AVURLAsset(url: videoFileUrl, options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    thumbnail = UIImage(cgImage: cgImage)
                } catch let error {
                    print("*** Error generating thumbnail: \(error.localizedDescription)")
                }
                
                let base64Img = MediaUtils.convertImageToBase64(img: thumbnail!)
                
                let mediaCompressionQuality: MediaQuality = AppUtils.shared.getMediaCompressionType(type: compressionType)
                MediaUtils.compressVideoFile(videoURL: videoFileUrl, mediaQuality: mediaCompressionQuality) { isSuccess, url, fileName, fileKey, fileSize , duration, errorMessage  in
                    if let compressedURL = url,  isSuccess{
                        
                        let mediaParams = FileMessageParams(fileUrl: compressedURL, fileName: fileName, caption: fileCaptionArg, fileSize: fileSize, duration: duration, thumbImage: base64Img, fileKey: fileKey)
                        let videoFileMessage = FileMessage(toId: receiverJID!, messageType: .video, fileMessage : mediaParams, replyMessageId: replyMessageID, mentionedUsersIds: mentionedUsersIds, metaData: metaDataArray, topicID: topicId)
                        
                        self.sendVideo(videoMessageParams: videoFileMessage, call: call, result: result)
                        
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: errorMessage?.description))
                    }
                }
                
                break;
                
            case .AUDIO, .AUDIO_RECORDED:
                
                let fileDictArg = args["fileMessage"] as? Dictionary<String, Any>
                let filePathArg = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "file") as? String ?? ""
                //                let fileDuration = AppUtils.shared.getValueForKey(dictionary: fileDict, key: "duration") as? Int ?? 0
                _ = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "fileSize") as? Int ?? 0
                _ = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "thumbImage") as? String ?? ""
                _ = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "fileName") as? String ?? ""
                _ = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "caption") as? String ?? ""


                let audiofileUrl = URL(fileURLWithPath: filePathArg)
                
                MediaUtils.processAudioFile(url: audiofileUrl) { isSuccess, fileName ,localPath, fileSize, duration, fileKey, errorMessage  in
                    if let localPathURL = localPath, isSuccess{
                        let audioParams = FileMessageParams (fileUrl: localPathURL, fileName: fileName,fileSize: fileSize, duration: duration, fileKey: fileKey)
                        let audioFileMessage = FileMessage(toId: receiverJID ?? emptyString(), messageType: sendingMessageType == .AUDIO_RECORDED ? .audioRecorded : .audio, fileMessage : audioParams, replyMessageId: replyMessageID ?? emptyString(), metaData: metaDataArray, topicID: topicId)
                        self.sendAudio(audioMessageParams: audioFileMessage, call: call, result: result)
                        
                    } else {
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: errorMessage.description))
                    }
                }
                
                break;
                
            case .CONTACT:
                let contactDict = args["contactMessage"] as? Dictionary<String, Any>
                
                let contactName = AppUtils.shared.getValueForKey(dictionary: contactDict, key: "name") as? String ?? ""
                let contactNumbers = AppUtils.shared.getValueForKey(dictionary: contactDict, key: "numbers") as? [String] ?? []
                
                let contactMessageParams = FileMessage(toId: receiverJID!, messageType: .contact, contactMessage: ContactMessageParams(name: contactName, numbers: contactNumbers), replyMessageId: replyMessageID ?? emptyString(), metaData: metaDataArray, topicID: topicId)
                
                sendContact(contactMessageParams: contactMessageParams, call: call, result: result)
                break;
                
            case .DOCUMENT:
                let fileDictArg = args["fileMessage"] as? Dictionary<String, Any>
                let filePathArg = AppUtils.shared.getValueForKey(dictionary: fileDictArg, key: "file") as? String ?? ""

                let documentFileUrl = URL(fileURLWithPath: filePathArg)
                
                /// As of now, SDK allows only upto 2GB
                MediaUtils.processDocumentFile(url: documentFileUrl, maxSizeInMB: 2048.0) { isSuccess,localPath,fileSize,fileName,errorMessage in
                    if let localPathURL = localPath, isSuccess {
                        
                        let documentParams = FileMessageParams(fileUrl: localPathURL, fileName: fileName)
                        let documentMsg = FileMessage(toId: receiverJID!, messageType: .document, fileMessage: documentParams, replyMessageId: replyMessageID ?? emptyString(), metaData: metaDataArray, topicID: topicId)
                        
                        self.sendDocument(documentMessageParams: documentMsg, call: call, result: result)
                        
                    } else {
                        
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: errorMessage.description))
                    }
                }
                
                break;
                
            case .LOCATION:
                
                
                let locationDict = args["locationMessage"] as? Dictionary<String, Any>
                let latitude = AppUtils.shared.getValueForKey(dictionary: locationDict, key: "latitude") as? Double ?? 0.0
                let longitude = AppUtils.shared.getValueForKey(dictionary: locationDict, key: "longitude") as? Double ?? 0.0

                let locationMessageParams = FileMessage(toId: receiverJID!, messageType: .location, locationMessage: LocationMessageParams(latitude: latitude, longitude: longitude), replyMessageId: replyMessageID ?? emptyString(), metaData: metaDataArray, topicID: topicId)
                
                sendLocation(locationMessageParams: locationMessageParams, call: call, result: result)
                
                break;
                
            case .MEET:
                let meetDict = args["meetMessage"] as? Dictionary<String, Any>
                let title = AppUtils.shared.getValueForKey(dictionary: meetDict, key: "title") as? String ?? ""
                let link = AppUtils.shared.getValueForKey(dictionary: meetDict, key: "link") as? String ?? ""
                let scheduledDateTime = AppUtils.shared.getValueForKey(dictionary: meetDict, key: "scheduledDateTime") as? Int ?? 0

                let meetMessageParams = MeetMessage(toId: receiverJID!, title: title, link: link, scheduledDateTime: scheduledDateTime,replyMessageId: replyMessageID ?? emptyString(),mentionedUsersIds: mentionedUsersIds,metaData: metaDataArray,topicID: topicId)

                sendMeetMessage(meetMessageParams: meetMessageParams, call: call, result: result)

                break;
            default:
                print("sendMessage -> Messsage Type goes to Default")
                break;
            }
        }else{
            result(FlutterError(code: FLErrorCode.MISSING_PARAMS,message: FLErrorMessage.INVALID_MESSAGE_TYPE,details: nil))
        }
    }
    
    private func sendText(textMessageParams: TextMessage, call: FlutterMethodCall, result: @escaping FlutterResult){
        
        FlyMessenger.sendTextMessage(messageParams: textMessageParams){ isSuccess, error, chatMessage in
            
            if isSuccess {
                let textMsgResponse = chatMessage.toJson()
                if(textMsgResponse != nil){
//                    self.setLastMessage(messageID: chatMessage?.messageId)
                    result(textMsgResponse)
                } else {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: nil))
                }
            }else{
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
                
            }
            
        }
    }
    private func sendImage(imageMessageParams: FileMessage, call: FlutterMethodCall, result: @escaping FlutterResult){
        FlyMessenger.sendMediaFileMessage(messageParams: imageMessageParams) { isSuccess, error, sendMessage in
            if isSuccess{
                let response = sendMessage?.toJson()
//                self.setLastMessage(messageID: sendMessage?.messageId)
                result(response)
            }else{
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                        result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
        }
    }
    
    private func sendVideo(videoMessageParams: FileMessage, call: FlutterMethodCall, result: @escaping FlutterResult){
        FlyMessenger.sendMediaFileMessage(messageParams: videoMessageParams){ isSuccess,error,message in
            if isSuccess{
                if let chatMessage = message {
                    let sendVideoResponse = chatMessage.toJson()
//                    self.setLastMessage(messageID: chatMessage.messageId)
                    print("FlyMessenger.sendVideoMessage==**==\(String(describing: sendVideoResponse))")
                    result(sendVideoResponse)
                    
                }
            }else{
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                        result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE, details: message))
                    }else if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
        }
    }
    private func sendContact(contactMessageParams: FileMessage, call: FlutterMethodCall, result: @escaping FlutterResult){
        FlyMessenger.sendMediaFileMessage(messageParams: contactMessageParams){ isSuccess,error,message in
            if (isSuccess) {
                let contactMessageResponse = message?.toJson()
                print("FlyMessenger.sendContactMessage==**==\(String(describing: contactMessageResponse))")
//                self.setLastMessage(messageID: message?.messageId)
                result(contactMessageResponse)
                return
            }else {
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                        result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
        }
    }
    
    private func sendAudio(audioMessageParams: FileMessage, call: FlutterMethodCall, result: @escaping FlutterResult){
        FlyMessenger.sendMediaFileMessage(messageParams: audioMessageParams) { isSuccess,error,message in
            if isSuccess{
                let audioResponse = message?.toJson()
//                self.setLastMessage(messageID: message?.messageId)
                result(audioResponse)
            }else{
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                        result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE, details: message))
                    }else if code == ErrorCode.NO_NETWORK{
                        result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
        }
    }
    
    private func sendDocument(documentMessageParams: FileMessage, call: FlutterMethodCall, result: @escaping FlutterResult){
        
                
                FlyMessenger.sendMediaFileMessage(messageParams: documentMessageParams, sendMessageListener: { isSuccess, error, message in
                    
                    if let chatMessage = message , isSuccess{
                        let documentMessageResponse = chatMessage.toJson()
//                        self.setLastMessage(messageID: chatMessage.messageId)
                        result(documentMessageResponse)
                    }else{
                        if case let .invalid_data(message, _) = error {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                        }else if case let .unexpected(message, code) = error {
                            if code == ErrorCode.CANNOT_PROCESS{
                                result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                            }else if code == ErrorCode.ARGUMENTS_EMPTY_OR_NIL_OR_INVALID{
                                result(FlutterError(code: FLErrorCode.FILE_DATA_NOT_AVAILABLE, message: FLErrorMessage.FILE_DATA_NOT_AVAILABLE_MESSAGE, details: message))
                            }else if code == ErrorCode.NO_NETWORK{
                                result(FlutterError(code: FLErrorCode.INTERNET_UNAVAILABLE, message: FLErrorMessage.INTERNET_UNAVAILABLE, details: message))
                            }else if code == ErrorCode.FORBIDDEN{
                                result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                            }else{
                                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                            }
                        }else if case let .invalid_jid(message, _) = error {
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.INVALID_JID, details: message))
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                        }
                    }
                    
                })
                
    }
    
    private func sendLocation(locationMessageParams: FileMessage, call : FlutterMethodCall, result: @escaping FlutterResult){
        
        FlyMessenger.sendMediaFileMessage(messageParams: locationMessageParams){ isSuccess,error,chatMessage in
            if (isSuccess) {
                let locationResponse = chatMessage?.toJson()
//                self.setLastMessage(messageID: chatMessage?.messageId)
                print("FlyMessenger.sendLocationMessage==**==\(String(describing: locationResponse))")
                result(locationResponse)
            }else{
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
        }
    }

    private func sendMeetMessage(meetMessageParams: MeetMessage, call : FlutterMethodCall, result: @escaping FlutterResult){

        FlyMessenger.sendMeetMessage(messageParams: meetMessageParams){ isSuccess,error,chatMessage in
            if (isSuccess) {
                let meetResponse = chatMessage?.toJson()
//                self.setLastMessage(messageID: chatMessage?.messageId)
                print("FlyMessenger.sendMeetMessage==**==\(String(describing: meetResponse))")
                result(meetResponse)
            }else{
                //Error Code Checked with SDK
                if case let .invalid_data(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else if case let .unexpected(message, code) = error {
                    if code == ErrorCode.CANNOT_PROCESS{
                        result(FlutterError(code: FLErrorCode.CANNOT_PROCESS, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }else if code == ErrorCode.FORBIDDEN{
                        result(FlutterError(code: FLErrorCode.FORBIDDEN_ACTION, message: FLErrorMessage.FEATURE_NOT_AVAILABLE, details: message))
                    }else{
                        result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                    }
                }else if case let .invalid_jid(message, _) = error {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: message))
                }else{
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_SENDING_FAILED, details: error?.localizedDescription))
                }
            }
        }

    }

    func unFavouriteAllFavouriteMessages(call : FlutterMethodCall, result: @escaping FlutterResult){
        ChatManager.unFavouriteAllFavouriteMessages{(isSuccess, flyError, resultDict) in
            if isSuccess{
                result(isSuccess)
            }else{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.UNFAVOURITE_MESSAGE_FAILED, details: flyError?.localizedDescription))
            }
        }
    }
    
    func loginWebChatViaQRCode(call : FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let barcode = args["barcode"] as? String ?? ""
        
        /// Native side, they are checking for the socket id and then allowing the scanning. So for now we are testing without getting the SocketId
        WebLoginsManager.shared.getSocketId { isSuccess, message in
               
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    WebLoginsManager.shared.handleQrCodeData(qrCodeString: barcode) { isSuccess, message in
                        if isSuccess {
                            print("QRCodeScannerViewModel isSuccess")
                            self.saveWebLoginInfo(qrData: barcode)
                            result(isSuccess)
                        }else{
                            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.QR_LOGIN_FAILED, details: message))
                        }
                    }
                }
                
            }else{
                print("QRCodeScannerViewModel failed \(message)")
            }
        }
        
       
    }
    
    private func saveWebLoginInfo(qrData : String) {
        WebLoginsManager.shared.saveWebLogin(qrData: qrData)
    }
    
    func webLoginDetailsCleared(call : FlutterMethodCall, result: @escaping FlutterResult){
        WebLoginsManager.shared.reset()
    }
    
    func getWebLoginDetails(call : FlutterMethodCall, result: @escaping FlutterResult){
        let loginDetails : [WebLoginInfo?] = WebLoginsManager.shared.getWebLogins()
        print("getWebLoginDetails \(loginDetails)")
        
        var jsonArray: [[String: Any]] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy hh:mm:ss a" // Desired format
        dateFormatter.locale = Locale(identifier: "en_US") // Ensures proper day/month formatting

        for login in loginDetails.compactMap({ $0 }) {
            var jsonObject: [String: Any] = [:]
            
            jsonObject["id"] = Int.random(in: 0..<100)
            jsonObject["osName"] = login.platform ?? ""
            jsonObject["qrUniqeToken"] = login.token ?? ""
            jsonObject["webBrowserName"] = login.browser ?? ""
            
            if let loginTime = login.loginTime {
                    let timeInSeconds = loginTime / 1000
                    let date = Date(timeIntervalSince1970: timeInSeconds) // Create Date object
                    jsonObject["lastLoginTime"] = dateFormatter.string(from: date) // Format to required string
                } else {
                    jsonObject["lastLoginTime"] = ""
                }

            jsonArray.append(jsonObject)
        }

        let webLoginJsonArrray = jsonArray.toJSONString()
        
        print("login Details json \(webLoginJsonArrray)")
        
        result(webLoginJsonArrray)
        
    }
    
    func logoutWebUser(call : FlutterMethodCall, result: @escaping FlutterResult){
        WebLoginsManager.shared.logoutWebSessions(completionHandler: { isSuccess, error, data in
            if isSuccess {
                result(isSuccess)
            }else {
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: error?.localizedDescription, details: nil))
            }
        })
    }
    
    func sendContactUsInfo(call : FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let title = args["title"] as? String ?? ""
        let description = args["description"] as? String ?? ""
        
        ContactManager.shared.sendContactUsInfo(title: title, description: description) { isSuccess, error, data in
            if isSuccess{
                result(isSuccess)
            }else{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.CONTACT_US_FAILED_MESSAGE, details: nil))
            }
        }
    }
    
    func editTextMessage(call: FlutterMethodCall, result: @escaping FlutterResult){

        let args = call.arguments as! Dictionary<String, Any>

        let messageId = args["messageId"] as? String
        let editedTextContent = args["editedTextContent"] as? String
        let mentionedUsersIds = args["mentionedUsersIds"] as? [String] ?? []

        var editMessageParams = EditMessage()
        editMessageParams.messageId = messageId
        editMessageParams.editedTextContent = editedTextContent
        editMessageParams.mentionedUsersIds = mentionedUsersIds

        FlyMessenger.editTextMessage(editMessageParams: editMessageParams) { isSuccess, error, textMessage in
            if isSuccess {
                print("Edit Message Success \(String(describing: textMessage?.toJson()))")
                let editMsgResponse = textMessage.toJson()
                if(editMsgResponse != nil){
                    result(editMsgResponse)
                } else {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_EDITING_FAILED, details: nil))
                }
            }else{
                print("Edit Message Failed \(String(describing: error?.description))")
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.MESSAGE_EDITING_FAILED, details: error?.localizedDescription))
            }
         }
    }

    func editMediaCaption(call: FlutterMethodCall, result: @escaping FlutterResult){

        let args = call.arguments as! Dictionary<String, Any>

        let messageId = args["messageId"] as? String
        let editedTextContent = args["editedTextContent"] as? String
        let mentionedUsersIds = args["mentionedUsersIds"] as? [String] ?? []

        var editMessageParams = EditMessage()
        editMessageParams.messageId = messageId
        editMessageParams.editedTextContent = editedTextContent
        editMessageParams.mentionedUsersIds = mentionedUsersIds

        FlyMessenger.editMediaCaption(editMessageParams: editMessageParams) { isSuccess, error, textMessage in
            if isSuccess {
                print("Edit Message Success \(String(describing: textMessage?.toJson()))")
                let editMsgResponse = textMessage.toJson()
                if(editMsgResponse != nil){
                    result(editMsgResponse)
                } else {
                    result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.CAPTION_EDITING_FAILED, details: nil))
                }
            }else{
                print("Edit Message Failed \(String(describing: error?.description))")
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.CAPTION_EDITING_FAILED, details: error?.localizedDescription))
            }
         }
    }


    func appLaunchedDetails(call: FlutterMethodCall, result: @escaping FlutterResult){
//        let jsonObject: NSMutableDictionary = NSMutableDictionary()
//        jsonObject.setValue("", forKey: "type")
//        jsonObject.setValue("", forKey: "value")
//        let jsonString = pluginDictToJson(dictionary: jsonObject)

     result("{}")
    }

    func getMetaData(call: FlutterMethodCall, result: @escaping FlutterResult){
        ChatManager.getMetaData { (isSuccess, flyError, resultDict) in
            if isSuccess {
                var flydata = resultDict
                let metaDataResponse = flydata.getData() as? [MetaData]

                let jsonString = metaDataResponse?.toJson()

                result(jsonString)
            }else{
                result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.META_DATA_FAILED_MESSAGE, details: flyError?.localizedDescription))
            }
        }
    }

    func updateMetaData(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let metaData = args["metaData"] as? [[String: Any]] ?? []
        print("metaData \(String(describing: metaData))")
        var metaDataArray : [MetaData] = []
        for data in metaData {
            let obj = MetaData(key: data["key"] as? String ?? "", value: data["value"] as? String ?? "")
            metaDataArray.append(obj)
        }
        ChatManager.updateMetaData(metaData: metaDataArray) { (isSuccess, flyError, resultDict) in
          if isSuccess {
              var flydata = resultDict
              let metaDataResponse = flydata.getData() as? [MetaData]

              let jsonString = metaDataResponse?.toJson()

              result(jsonString)
          }else{
              result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.META_DATA_FAILED_MESSAGE, details: flyError?.localizedDescription))
          }
      }
    }
    
    func isPrivateStorageEnabled(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(ChatManager.isPrivateStorageEnabled())
    }

    func startBackup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let encryption = args["enableEncryption"] as? Bool ?? true
        BackupManager.shared.startBackup(enableEncryption: encryption)
        result(true)
    }

    func restoreBackup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let backupUrl = args["backupPath"] as? String ?? ""

        if backupUrl.isEmpty {
            result(FlutterError(code: FLErrorCode.INVALID_DATA, message: FLErrorMessage.BACKUP_URL_INVALID, details: nil))
        }else{
            let backupURL =  URL(fileURLWithPath: backupUrl)
            BackupManager.shared.restoreMessages(url: backupURL)
            result(true)
        }
    }
    
    
    func cancelBackup(call : FlutterMethodCall, result: @escaping FlutterResult) {
        BackupManager.shared.cancelBackup()
        result(true)
    }
    
    
    func cancelRestore(call : FlutterMethodCall, result: @escaping FlutterResult) {
        BackupManager.shared.cancelRestore()
        result(true)
    }
    
    func setTranslations(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! Dictionary<String, Any>
        let stringSet: Dictionary<String, String>? = args["stringSet"] as? Dictionary<String, String>
        if (stringSet != nil) {
            print("\(Constants.tag) setTranslations stringSet: \(stringSet!)")
        }
        result(true)
        // Needs to be implemented in future
    }
    
    func getAuthToken(call: FlutterMethodCall, result: @escaping FlutterResult) {
//        let token = UserDefaultsManager.shared.getAuthToken()
//        result(token) // sends token back to Flutter
    }
    
    func getCurrentUserJid(call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(AppUtils.shared.getMyJid())
    }
}
