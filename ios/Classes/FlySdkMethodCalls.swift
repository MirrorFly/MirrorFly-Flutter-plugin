//
//  FlySdkMethodCalls.swift
//  fly_chat
//
//  Created by user on 23/03/23.
//

import Foundation
//import FlyCore
//import FlyCommon
import Flutter
import Photos
//import FlyDatabase
import Contacts
import ContactsUI
import MirrorFlySDK
import UIKit

#if DEBUG
    let ISEXPORT = false
#else
    let ISEXPORT = true
#endif

@objc public class FlySdkMethodCalls : NSObject{
    
    static var isTrialLicenceKey : Bool = true;
    static var chatHistoryEnable : Bool = false;
    static var isContactSyncInProgress : Bool = false;
    
    static var userlist = [ProfileDetails]()
    
    static var recentChatListParams = RecentChatListParams(limit: 15)
    
    static var recentChatListBuilder: RecentChatListBuilder?
    

    static var bestAttemptContent: UNMutableNotificationContent?
    static var contentHandler: ((UNNotificationContent) -> Void)?

    static var messageListParams = FetchMessageListParams()
    static var messageListQuery : FetchMessageListQuery? = nil
    
    //Need to alter this below two lines based on RecentChat list
    static var topicChatListParams = TopicChatListParams(limit: 15)
    static var topicChatListBuilder : TopicChatListBuilder?
    //static let messageListParams = FetchMessageListParams()
//    static let topicMessageListQuery =  FetchMessageListQuery(fetchMessageListParams: messageListParams)

    static func buildChatSDK(call: FlutterMethodCall) {

        let args = call.arguments as! Dictionary<String, Any>
        
        let licenseKey = args["licenseKey"] as? String ?? ""
        _ = args["enableMobileNumberLogin"] as? Bool ?? true
        isTrialLicenceKey = args["isTrialLicenceKey"] as? Bool ?? true
        chatHistoryEnable = args["chatHistoryEnable"] as? Bool ?? true
        _ = args["enableSDKLog"] as? Bool ?? false
        _ = args["maximumRecentChatPin"] as? Int ?? 3
        
        

        _ = args["ivKey"] as? String ?? ""
        let containerID = args["iOSContainerID"] as? String ?? ""
        
        print("buildChatSDK \(containerID)")
        
        let groupConfig = args["groupConfig"] as? [String : Any]
        
        let groupCreationEnable = groupConfig?["enableGroup"] as? Bool ?? true
        let adminOnlyAddRemoveAccess = groupConfig?["adminOnlyAddRemoveAccess"] as? Bool ?? true
        let maxMembersCount = groupConfig?["maxMembersCount"] as? Int ?? 200
        
        print("groupCreationEnable \(groupCreationEnable)")
        let sdkGroupConfig = try? GroupConfig.Builder.enableGroupCreation(groupCreation: groupCreationEnable)
            .onlyAdminCanAddOrRemoveMembers(adminOnly: adminOnlyAddRemoveAccess)
            .setMaximumMembersInAGroup(membersCount: maxMembersCount)
            .build()
        assert(sdkGroupConfig != nil)

        Utility.saveInPreference(key: Constants.licenseKey, value: licenseKey)
        Utility.saveInPreference(key: Constants.containerID, value: containerID)
        
                ChatManager.setAppGroupContainerId(id: containerID)
                ChatManager.initializeSDK(licenseKey: licenseKey) { _, _, _ in }
        
        
        print("ChatManager.enableChatHistory \(chatHistoryEnable)")
        
        if Utility.getBoolFromPreference(key: Constants.isLoggedIn) {

            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                
                do {
                    try CallManager.initCallSDK()
                    //                    FlyDefaults.chatHistoryEnabled = true
                } catch (let error ){
                    print("#FlyCall Exception : \(error.localizedDescription)")
                }
            }
        }

        
        ChatManager.disableLocalNotification()
        
        ChatManager.enableContactSync(isEnable: !isTrialLicenceKey)
        
        Utility.saveInPreference(key: Constants.contactSyncEnable, value: !isTrialLicenceKey)
        
//        FlyDefaults.chatHistoryEnabled = true
//        FlyDefaults.isBusyStatusEnabled = true
        ChatManager.enableChatHistory(isEnable: chatHistoryEnable)
        
//        ChatManager.setRegisterDeviceType(deviceType: "android")

    }
    
    static func getPlistValue(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let key = args["key"] as? String ?? ""
        // Get the path to the Info.plist file
        guard let infoPlistPath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            result(FlutterError(code: "500",
                                message: "Info.plist file not found",
                                details: nil))
            return
        }

        // Load the contents of the Info.plist file
        guard let infoDict = NSDictionary(contentsOfFile: infoPlistPath) else {
            result(FlutterError(code: "500",
                                message: "Failed to load Info.plist",
                                details: nil))
            return
        }

        // Access the value using the appropriate key
        if let value = infoDict[key] as? String {
            result(value)
        } else {
            //            print("App version not found in Info.plist.")
            result(FlutterError(code: "500",
                                message: "\(key) key not found in Info plist",
                                details: nil))
        }

    }
    
    static func registerUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        var userIdentifier = args["userIdentifier"] as? String ?? ""
        let deviceToken = args["token"] as? String ?? ""
        
        userIdentifier = userIdentifier.replacingOccurrences(of: "+", with: "")
        
        if(userIdentifier.isEmpty){
            result(FlutterError(code: "500",
                                message: "User Name is Empty",
                                details: nil))
            return
        }
        let voipToken = Utility.getStringFromPreference(key: Constants.voipToken)
//        voipToken = voipToken.isEmpty ? deviceToken : voipToken

        NSLog("\(Constants.tag) voipToken \(voipToken)")
        NSLog("\(Constants.tag) voipToken.isEmpty \(voipToken.isEmpty)")
        
        NSLog("\(Constants.tag) Register Device Token \(deviceToken)")

        try! ChatManager.registerApiService(for: userIdentifier, deviceToken: deviceToken, voipDeviceToken: voipToken, isExport: ISEXPORT, pushServerType: .firebase) { isSuccess, flyError, flyData in
            var data = flyData
            if isSuccess {
                
                print("Register Response")
                
                let registerResponse = [
                    "data": data,
                    "is_new_user": data["newLogin"] as Any,
                    "message" : "Register Trial API Success"
                ] as [String : Any]
                
                ChatManager.updateAppLoggedIn(isLoggedin: true)
//                FlyDefaults.myXmppPassword = data["password"] as! String
//                FlyDefaults.myXmppUsername = data["username"] as! String
//                FlyDefaults.myMobileNumber = userIdentifier
//                FlyDefaults.isProfileUpdated = data["isProfileUpdated"] as! Int == 1
                
                Utility.saveInPreference(key: Constants.isLoggedIn, value: true)
                
                
                ChatManager.connect()
                

                do {
                    try CallManager.initCallSDK()
                }
                catch(let error ) {
                    print("#FlyCall Exception : \(error.localizedDescription)")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    
                    let resp = registerResponse.dictToJson()
                    if(resp != nil){
                        print("ChatManager.registerApiService==**==\(String(describing: resp))")
                        result(resp)
                    }else{
                        result(FlutterError(code: "500", message: "Failed to Register User", details: nil))
                    }

                }
            }else{
                let error = data.getMessage()
                result(FlutterError(code: "500",
                                    message: error as? String,
                                    details: nil))
                print("#chatSDK \(error)")
            }
        }
    }
    
    static func refreshAndGetAuthToken(call: FlutterMethodCall, result: @escaping FlutterResult){
        ChatManager.refreshToken { (isSuccess, flyError, resultDict) in
            if (isSuccess) {
                var resp = resultDict
                let tokendata = resp.getData()
                let refreshToken = tokendata as AnyObject

                let newToken = refreshToken["token"] as Any

                result(newToken)

            } else {
                result(FlutterError(code: "500", message: "Unable to refresh token", details: flyError?.description))

            }
        }
    }
    
    static func getJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userName = args["username"] as? String
        if(userName == nil){
            result(FlutterError(code: "500",
                                message: "User Name is Empty",
                                details: nil))
            return
        }
        do{
            try result(FlyUtils.getJid(from: userName!))
        }catch let jidError{
            result(FlutterError(code: "500", message: "Unable to get JID", details: jidError.localizedDescription))
        }
    }
    
    static func sendTextMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let txtMessage = args["message"] as? String ?? nil
        let receiverJID = args["JID"] as? String ?? nil
        let replyMessageID = args["replyMessageId"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        
        if(txtMessage == nil || receiverJID == nil){
            result(FlutterError(code: "500", message: "Parameters Missing", details: nil))
            return
        }
        
        FlyMessenger.sendTextMessage(toJid: receiverJID!, message: txtMessage!.trimmingCharacters(in: .whitespacesAndNewlines), replyMessageId: replyMessageID, mentionedUsersIds: [],topicID: topicId) { isSuccess,error,chatMessage in
            if isSuccess {
                print("sending text messages-->\(chatMessage?.messageTextContent ?? "Message is Empty")")
                let textMsgResponse = chatMessage.toJson()
                if(textMsgResponse != nil){
                    print("FlyMessenger.sendTextMessage==**==\(String(describing: textMsgResponse))")
                    result(textMsgResponse)
                } else {
                    result(FlutterError(code: "500", message: "Failed to Send Text Message", details: nil))
                }
                
                
            }else{
                result(FlutterError(code: "500", message: error?.description, details: nil))
            }
        }
        
    }
    
    static func sendLocationMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let latitude = args["latitude"] as? Double ?? 00.0
        let longitude = args["longitude"] as? Double ?? 00.0
        let userJid = args["jid"] as? String ?? nil
        let topicId = args["topicId"] as? String ?? ""
        let replyMessageID = args["replyMessageId"] as? String ?? ""
        
        if(latitude == 00.0 || longitude == 00.0){
            result(FlutterError(code: "500", message: "Location is Empty", details: nil))
            return
        }
        if(userJid == nil){
            result(FlutterError(code: "500", message: "Location is Empty", details: nil))
            return
        }
        
        FlyMessenger.sendLocationMessage(toJid: userJid!, latitude: latitude, longitude: longitude, replyMessageId: replyMessageID,topicID: topicId) { isSuccess,error,chatMessage in
            if isSuccess {
                let locationResponse = chatMessage?.toJson()
                print("FlyMessenger.sendLocationMessage==**==\(String(describing: locationResponse))")
                result(locationResponse)
            }else{
                result(FlutterError(code: "500", message: error?.localizedDescription, details: nil))
            }
        }
    }
    
    static func sendImageMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
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
            result(FlutterError(code: "500", message: "User jid is Empty", details: nil))
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
            let response = message?.toJson()
            result(response)
        }
    }
    
    static func sendAudioMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
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
                    if message != nil {
                        
                        let audioResponse = message?.toJson()
                        print("FlyMessenger.sendAudioMessage==**==\(String(describing: audioResponse))")
                        result(audioResponse)
                        
                    }else{
                        result(FlutterError(code: "500", message: error?.localizedDescription, details: nil))
                    }
                }
            }
        }
        
    }
    
    static func isArchivedSettingsEnabled(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(ChatManager.isArchivedSettingsEnabled())
    }
    
    static func cancelNotifications(call: FlutterMethodCall, result: @escaping FlutterResult){
        result("")
    }
    
    static func downloadMedia(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let mediaMessageId = args["mediaMessage_id"] as? String ?? ""
        
        
        FlyMessenger.downloadMedia(messageId: mediaMessageId){ isSuccess,error,message in
            
            result(isSuccess)
        }
    }
    
    static func iOSFileExist(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let filePath = args["file_path"] as? String ?? ""
        
        let fileManagerr = FileManager.default
        
        let existsOrNot = fileManagerr.fileExists(atPath: filePath)

        result(existsOrNot)
    }
    
    static func updateFavouriteStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
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
            
            result(isSuccess)
            
        }
    }
    
    static func getUserList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let pageNumber = args["page"] as? Int ?? 1
        let searchTerm = args["search"] as? String ?? ""
        
        ContactManager.shared.getUsersList(pageNo: pageNumber, pageSize: 20, search: searchTerm){ isSuccess,flyError,flyData in
            if isSuccess {
                var userList = flyData
                
                print("getUsersList\(userList)")
                if let userData = userList.getData() as? [ProfileDetails] {
                    userlist = userData
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
                result(FlutterError(code: "500", message: flyError?.description, details: nil))
            }
        }
        
    }
    
    static func getRegisteredUsers(call: FlutterMethodCall, result: @escaping FlutterResult){
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
                
                result(userData)
            } else{
                result(FlutterError(code: "500", message: flyError?.description, details: nil))
            }
        }
    }
    
    static func sendVideoMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        let caption = args["caption"] as? String ?? ""
        
        let filePath = args["filePath"] as? String ?? ""
        
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        
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
                    if let chatMessage = message {
                        let sendVideoResponse = chatMessage.toJson()
                        print("FlyMessenger.sendVideoMessage==**==\(String(describing: sendVideoResponse))")
                        result(sendVideoResponse)

                    }
                }
            }else{
                print("Video Compression Error")
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
    
    static func sendContactMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        let contactName = args["contact_name"] as? String ?? ""
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        let contactList = args["contact_list"] as? [String] ?? []
        
        FlyMessenger.sendContactMessage(toJid: userJid, contactName: contactName, contactNumbers: contactList, replyMessageId: replyMessageId,topicID: topicId){ isSuccess,error,message  in
            if message != nil {
                
                let contactMessageResponse = message?.toJson()
                print("FlyMessenger.sendContactMessage==**==\(String(describing: contactMessageResponse))")
                result(contactMessageResponse)
                
            }else{
                result(FlutterError(code: "500", message: error?.localizedDescription, details: nil))
            }
        }
    }
    
    
    static func sendDocumentMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        let topicId = args["topicId"] as? String ?? ""
        
        let documentFilePath = args["file"] as? String ?? ""
        let documentFileUrl = URL(fileURLWithPath: documentFilePath)
        
        
        MediaUtils.processDocument(url: documentFileUrl){ isSuccess,localPath,fileSize,fileName, errorMessage in
            if !isSuccess {
                if !errorMessage.isEmpty {
                    result(FlutterError(code: "500", message: errorMessage.description, details: nil))
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
                    if message != nil {
                        let documentMessageResponse = message?.toJson()
                        result(documentMessageResponse)
                        
                    }else{
                        result(FlutterError(code: "500", message: error?.localizedDescription, details: nil))
                    }
                    
                }
                
            } else {
                
            }
        }
    }

    static func getProfileStatusList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let profileStatus = ChatManager.getAllStatus()
        if(profileStatus.isEmpty){
            result(nil)
        }
        
        let profileStatusJson = profileStatus.toJson()
        print("getProfileStatusList==**==\(String(describing: profileStatusJson))")
        result(profileStatusJson)
        
    }
    static func insertDefaultStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let status = args["status"] as? String ?? ""
        
        let _: () = ChatManager.saveProfileStatus(statusText: status, currentStatus: false)

        result(true)

    }
    
    static func insertNewProfileStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let newStatus = args["status"] as? String ?? ""
        
        var isAlreadyExists = false
        
        var getAllStatus: [ProfileStatus] = []
        getAllStatus = ChatManager.getAllStatus()
        
        for status in getAllStatus {
            if(status.status == newStatus){
                isAlreadyExists = true
                _ = ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: true)
            }else{
                _ = ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: false)
            }
        }
        if(!isAlreadyExists){
            ChatManager.saveProfileStatus(statusText: newStatus, currentStatus: true)
        }
        result("{\"status\" : true }")
        
    }
    static func isTrailLicence(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(isTrialLicenceKey)
    }
    
    static func setMyProfileStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let statusText = args["status"] as? String ?? ""
        let statusId = args["statusId"] as? String ?? ""
        
        var getAllStatus: [ProfileStatus] = []
        getAllStatus = ChatManager.getAllStatus()
        for status in getAllStatus {
            if(status.id == statusId) {
                _ = ChatManager.updateStatus(statusId: statusId ,statusText: statusText,currentStatus: true)
            }
            else{
                _ = ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: false)
            }
        }
        
        let statusUpdateJSON = "{\"message\": \"Status Update Success\",\"status\": true}"
        
        result(statusUpdateJSON)

    }
    
    static func getStatus() -> [ProfileStatus] {
        let profileStatus = ChatManager.getAllStatus()
        return profileStatus
    }
    
    static func deleteProfileStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let statusId = args["id"] as? String ?? ""
        let deleteStatusResponse = ChatManager.deleteStatus(statusId: statusId)
        
        result(true)
        
    }
    
    static func isUserUnArchived(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        
        let isUserUnarchived : Bool = ChatManager.shared.isUserUnArchived(jid: userJid)
        result(isUserUnarchived)
        
    }
    static func forwardMessagesToMultipleUsers(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let messageIDList = args["message_ids"] as? [String] ?? []
        let userList = args["userList"] as? [String] ?? []
        
        FlyMessenger.composeForwardMessage(messageIds: messageIDList, toJidList: userList, completionHandler: { isSuccess, flyError, flyData in
            if isSuccess{
                result("Message Forward Success")
            }
        })
        
        
        
    }
    
    static func isMemberOfGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJid = args["jid"] as? String ?? ""
        let currentJid = AppUtils.getMyJid()
        let participantJid = args["userjid"] as? String ?? currentJid
        
        
        let isMember = GroupManager.shared.isParticiapntExistingIn(groupJid: groupJid,
                                                                   participantJid: participantJid)
        
        result(isMember.doesExist)
        
    }
    static func getGroupMembersList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["jid"] as? String ?? ""
        var groupMembers = [GroupParticipantDetail]()
        
        
        groupMembers = GroupManager.shared.getGroupMemebersFromLocal(groupJid: groupJid).participantDetailArray.filter({$0.memberJid != AppUtils.getMyJid()})
        let myJid = GroupManager.shared.getGroupMemebersFromLocal(groupJid: groupJid).participantDetailArray.filter({$0.memberJid == AppUtils.getMyJid()})
        if(myJid.count > 0){
            myJid[0].profileDetail?.nickName = "You"
            myJid[0].profileDetail?.name = "You"
        }
        groupMembers = groupMembers.sorted(by: { $0.profileDetail?.name.lowercased() ?? "" < $1.profileDetail?.name.lowercased() ?? "" })
        if(myJid.count > 0){
            groupMembers.append(contentsOf: myJid)
        }
        

        var groupMemberProfile: String = "["
        
        groupMembers.forEach{ groupMember in
            if(groupMember.profileDetail != nil){
                let profileDetailJson = groupMember.profileDetail?.toJson()
                print("---group members json--- \(String(describing: profileDetailJson))")
                
                groupMemberProfile = groupMemberProfile + (profileDetailJson ?? "") + ","
            }
            
        }
        groupMemberProfile = groupMemberProfile.dropLast() + "]"
        
        print("getGroupMembersList==**== \(String(describing: groupMemberProfile))")

        result(groupMemberProfile)
    }
    static func enableDisableArchivedSettings(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let enableArchive = args["enable"] as? Bool ?? false
        ChatManager.enableDisableArchivedSettings(enableArchive) { isSuccess, error, data in
            if isSuccess {
                result(isSuccess)
            }
        }
    }
    
    static func getFavouriteMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let starredMessages =  ChatManager.getFavouriteMessages()
        
        let starredMessagesJson = starredMessages.toJson()
        print("starredMessagesJson==**==\(String(describing: starredMessagesJson))")
        result(starredMessagesJson)
    }
    
    static func clearAllConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        ChatManager.shared.clearAllConversation{ isSuccess, error, data in
            result(isSuccess)
        }
    }
    
    static func getUnsentMessageOfAJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userjid = args["jid"] as? String ?? ""
        
        let savedMessage = FlyMessenger.getUnsentMessageOf(id: userjid)
        print("savedMessage\(savedMessage)")
        result(savedMessage.textContent)
        
    }
    
    static func saveUnsentMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userjid = args["jid"] as? String ?? ""
        let texMessage = args["texMessage"] as? String ?? ""
        FlyMessenger.saveUnsentMessage(id: userjid, message: texMessage)
    }
    
    static func getRingtoneName(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        result("[]")
        
    }
    static func getDefaultNotificationUri(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        result("[]")
        
    }
    
    static func verifyToken(call: FlutterMethodCall, result: @escaping FlutterResult){

        
        result("")
        
    }
    
    static func getUserProfile(call: FlutterMethodCall, result: @escaping FlutterResult){
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
                    result(FlutterError(code: "500", message: flyError!.localizedDescription, details: nil))
                }
            }
        }catch{
            print("Error while calling User Profile Details")
        }
        
    }
    
    static func updateMyProfile(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let email = args["email"] as? String ?? ""
        let mobile = args["mobile"] as? String ?? ""
        let nickName = args["name"] as? String ?? ""
        let status = args["status"] as? String ?? ""
        let image = args["image"] as? String ?? nil
        let userJid = AppUtils.getMyJid()
        
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
//            isImagePicked = false
        }else{
            print("Image is null else condition")
//            isImagePicked = false
        }
        
        ContactManager.shared.updateMyProfile(for: myProfile){ isSuccess, flyError, flyData in
            if isSuccess {
                var data = flyData
                
                let message = data.getMessage()
                print("***profile Data\(data.getData() as? FlyProfile)")
                let profileUpdateResponse = data.getData() as? FlyProfile
                let profileDataJson = profileUpdateResponse?.toJson()
                print("***profile Data json \(profileDataJson)")

                var profileResponseJson = "{\"status\": true ,\"message\" : \"\(message)\" ,\"data\": \(profileDataJson ?? "[]") }"

                saveMyProfileDataToUserDefaults(profile: myProfile)
                print("ContactManager.shared.updateMyProfile==**==\(profileResponseJson)")
                result(profileResponseJson)
            } else{
                result(FlutterError(code: "500", message: flyError!.localizedDescription, details: nil))
                
            }
        }
        
    }
    
    static func removeProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        ContactManager.shared.removeProfileImage(){ isSuccess, flyError, flyData in
            if isSuccess {
                result(isSuccess)
            } else{
                print(flyError!.localizedDescription)
            }
        }
    }
    
    static func saveMyProfileDataToUserDefaults(profile : FlyProfile){
        // Commented private flydefaults profile saved inside SDK
//        FlyDefaults.myName = profile.name
//        FlyDefaults.myImageUrl = profile.image
//        FlyDefaults.myMobileNumber = profile.mobileNumber
//        FlyDefaults.myStatus = profile.status
//        FlyDefaults.myEmail = profile.email
        
        self.saveMyJidAsContacts()
    }
    
    static func saveMyJidAsContacts() {
        
        let profileData = ProfileDetails(jid: AppUtils.getMyJid())
        profileData.name = ContactManager.getMyProfile().name
        profileData.nickName = ContactManager.getMyProfile().nickName
        profileData.mobileNumber  = ContactManager.getMyProfile().mobileNumber
        profileData.email = ContactManager.getMyProfile().email
        profileData.status = ContactManager.getMyProfile().status
        profileData.image = ContactManager.getMyProfile().image
        
//        ContactManager.shared.saveUser(profileDetails: profileData, saveAs: .live)
    }
    
    static func getMediaEndPoint(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let urlString = ChatManager.getAppConfigDetails().baseURL + "" + "media" + "/"
        result(urlString)
        
    }
    
    static func syncContacts(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
        
    }
    static func updateMyProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let profileImage = args["image"] as? String ?? ""
//        print("*****profileImage\(profileImage)")
//        var localFileUrl = ""
//        let sourceURL = URL(fileURLWithPath: profileImage)
//        print("****sourceURL \(sourceURL)")
//        let fileName = (profileImage as NSString).lastPathComponent
//        print("file name" + fileName)
        
        ContactManager.shared.updateMyProfileImage(image: profileImage){ isSuccess, flyError, flyData in
                if isSuccess {
                    // Profile Image updated successfully update the UI
                    print("updateMyProfileImage success response\(flyData)")
                } else{
                    print("updateMyProfileImage Error\(flyError!.localizedDescription)")
                }
        }
        
//        do {
//
//            if (profileImage != ""){
//                if let fileUrl = saveFile(from: sourceURL, fileName: fileName) {
//                    print("File saved at: \(fileUrl)")
//                    localFileUrl = fileUrl
//                    FlyDefaults.myImageToken = fileUrl
//
//                    let userJid = FlyDefaults.myXmppUsername + "@" + FlyDefaults.xmppDomain
//
//
//                    var myProfile = FlyProfile(jid: userJid)
//                    myProfile.image = localFileUrl
//
//                    ContactManager.shared.updateMyProfile(for: myProfile){ isSuccess, flyError, flyData in
//                        if isSuccess {
//                            var data = flyData
//
//                            let message = data.getMessage()
//                            print("***profile Data\(data.getData() as? FlyProfile)")
//                            var profileUpdateResponse = data.getData() as? FlyProfile
//                            let fileArray = profileUpdateResponse?.image.components(separatedBy: "/")
//
//                            if let fileName = fileArray?.last {
//                                profileUpdateResponse?.image = fileName
//                                    }
//
//                            let profileDataJson = profileUpdateResponse?.toJson()
//                            print("***profile Data json \(profileDataJson)")
//
//                            Utility.saveInPreference(key: Constants.isProfileSaved, value: true)
//
//
//                            var profileResponseJson = "{\"status\": true ,\"message\" : \"\(message)\" ,\"data\": \(profileDataJson ?? "[]") }"
//
//                            saveMyProfileDataToUserDefaults(profile: myProfile)
//                            print("ContactManager.shared.updateMyProfile==**==\(profileResponseJson)")
//                            result(profileResponseJson)
//                        } else{
//                            result(FlutterError(code: "500", message: flyError!.localizedDescription, details: nil))
//
//                        }
//                    }
//                } else {
//                    print("Failed to save the file.")
//
//                }
//            }else{
//                result(FlutterError(code: "400", message: "Image not available to update profile", details: nil))
//            }
//
//        } catch {
//            // Error handling
//            print("Error reading file: \(error.localizedDescription)")
//        }
        
    }
    
    static func contactSyncStateValue(call: FlutterMethodCall, result: @escaping FlutterResult){
     
        print("contactSyncStateValue\(isContactSyncInProgress)")
        result(isContactSyncInProgress)
    }
//
//    static func contactSyncState(call: FlutterMethodCall, result: @escaping FlutterResult){
//        //        NotificationCenter.default.addObserver(self, selector: #selector(self.contactSyncCompleted(notification:)), name: NSNotification.Name(FlyConstants.contactSyncState), object: nil)
//        //        @objc func contactSyncCompleted(notification: Notification){
//        //             if let contactSyncState = notification.userInfo?[FlyConstants.contactSyncState] as? String {
//        //                switch ContactSyncState(rawValue: contactSyncState) {
//        //                    case .inprogress:
//        //                        //Update the UI
//        //                    case .success:
//        //                        //Update the UI
//        //                    case .failed:
//        //                        //Update the UI
//        //                }
//        //            }
//        //        }
//
//    }
    
    
    static func revokeContactSync(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
    }
    static func getUsersWhoBlockedMe(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let isFetchFromServer = args["server"] as? Bool ?? false
        
        ContactManager.shared.getUsersWhoBlockedMe(fetchFromServer: isFetchFromServer){ isSuccess, flyError, flyData in
            
            var data  = flyData
            
            if isSuccess {
                let blockedprofileDetailsArray = data.getData() as! [ProfileDetails]
            } else{
                print(flyError!.localizedDescription)
            }
        }
    }
    static func getUnKnownUserProfiles(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
    }
    static func getMyProfileStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
    }
    
    static func getMyBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let busyStatus = ChatManager.shared.getMyBusyStatus()
        let busyStatusJson = busyStatus.toJson()
        result(busyStatusJson)
    }
    
    static func setMyBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userStatus = args["status"] as? String ?? ""
        
        ChatManager.shared.setMyBusyStatus(userStatus)
        result(true)
    }
    static func enableDisableBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let busyStatusVal = args["enable"] as? Bool ?? false
        
        ChatManager.shared.enableDisableBusyStatus(busyStatusVal)
        
        result(true)
        
    }
    
    static func insertBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let busyStatus = args["busy_status"] as? String ?? ""
        print("setting busy status\(busyStatus)")
        ChatManager.shared.setMyBusyStatus(busyStatus)
        result(true)
    }
    
    static func getBusyStatusList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let busyStatusList = ChatManager.shared.getBusyStatusList()
        print("Get Status Started profileList Count \(busyStatusList.count)")
        let busyStatusJsonList = busyStatusList.toJson()
        print("getBusyStatusList==**==\(String(describing: busyStatusJsonList))")
        result(busyStatusJsonList)
    }
    
    static func deleteBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let busyId = args["id"] as? String ?? ""
        let status = args["status"] as? String ?? ""
        let isCurrentStatus = args["isCurrentStatus"] as? Bool ?? false
                        
        let busyStatus = BusyStatus(statusText: status, isCurrentStatus: isCurrentStatus)
        
        print("deleteBusyStatus==**==\(busyStatus)")
        
        ChatManager.shared.deleteBusyStatus(statusId: busyId)
        
        result(true)
        
        
    }
    static func enableDisableHideLastSeen(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let enableLastSeen = args["enable"] as? Bool ?? false
        
        ChatManager.enableDisableHideLastSeen(EnableLastSeen: enableLastSeen) { isSuccess, flyError, flyData in
            
            result(isSuccess)
        }
    }
    static func isHideLastSeenEnabled(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        result(ChatManager.isLastSeenEnabled())
    }
    static func deleteMessagesForMe(call: FlutterMethodCall, result: @escaping FlutterResult){
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
            
            result(isSuccess)
        }
        
    }
    static func deleteMessagesForEveryone(call: FlutterMethodCall, result: @escaping FlutterResult){
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
            
            print("deleteMessagesForEveryone result\(isSuccess)")
            result(isSuccess)
            
        }
        
    }
    static func markAsRead(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        
        
        ChatManager.markConversationAsRead(for: [jid])
        result(true)
    }
    static func markConversationAsUnread(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jidList = args["jidlist"] as? [String] ?? []
        
        print("markConversationAsUnread jid list --> \(jidList)")
        
        ChatManager.markConversationAsUnread(for: jidList)
        result(true)
    }
    static func markConversationAsRead(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jidList = args["jidlist"] as? [String] ?? []
        
        print("markConversationAsRead jid list --> \(jidList)")
        
        ChatManager.markConversationAsRead(for: jidList)
        result(true)
    }
    static func getMessagesOfJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["JID"] as? String ?? ""
        print(userJid)
        let messages : [ChatMessage] = FlyMessenger.getMessagesOf(jid: userJid)
        
        if let chatJson = messages.toJson() {
            print("getMessagesOfJid==**==\(chatJson)")
            result(chatJson)
        } else {
            result(FlutterError(code: "500", message: "Failed to Encode Chat Messages", details: nil))
        }
        
    }
    
    static func markAsReadDeleteUnreadSeparator(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""

        ChatManager.markConversationAsRead(for: [jid])
        FlyMessenger.shared.deleteUnreadMessageSeparatorOfAConversation(jid: jid)
        
        result(true)
    }
    
    static func deleteUnreadMessageSeparatorOfAConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        FlyMessenger.shared.deleteUnreadMessageSeparatorOfAConversation(jid: jid)
        
        result(true)
        
    }
    static func getRecalledMessagesOfAConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
//        let args = call.arguments as! Dictionary<String, Any>
        
//        let jid = args["jid"] as? String ?? nil
        
        
    }
    static func uploadMedia(call: FlutterMethodCall, result: @escaping FlutterResult){
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
    static func getMessagesUsingIds(call: FlutterMethodCall, result: @escaping FlutterResult){
//        let args = call.arguments as! Dictionary<String, Any>
        
//        var messages : [ChatMessage] = FlyMessenger.getMessagesUsingIds(MESSAGE_MIDS)
        
        
    }
    static func updateMediaDownloadStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
    }
    static func updateMediaUploadStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
    }
    static func cancelMediaUploadOrDownload(call: FlutterMethodCall, result: @escaping FlutterResult){
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
    static func setMediaEncryption(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let isEncryptionEnable = args["encryption"] as? Bool ?? true
        
        ChatManager.setMediaEncryption(isEnable: isEncryptionEnable)
    }
    static func deleteAllMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        _ = call.arguments as! Dictionary<String, Any>
        
    }
    static func getGroupJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupId = args["groupId"] as? String ?? ""
    
        do
        {
            let groupIDResponse = try FlyUtils.getGroupJid(groupId: groupId)
            result(groupIDResponse)
            
        }catch let sdkError{
            result(FlutterError(code: "500", message: "Unable to get GroupJid", details: sdkError.localizedDescription))
        }
        
    }
    static func updateRecentChatPinStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJID = args["jid"] as? String ?? ""
        let pin_recent_chat = args["pin_recent_chat"] as? Bool ?? false
        
        ChatManager.updateRecentChatPinStatus(jid: userJID, pinRecentChat: pin_recent_chat)
    }
    
    static func updateChatMuteStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJID = args["jid"] as? String ?? ""
        let muteStatus = args["mute_status"] as? Bool ?? false
        ChatManager.updateChatMuteStatus(jid: userJID, muteStatus: muteStatus)
    }
    static func sendTypingStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
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
    
    static func sendTypingGoneStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        
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
    
    static func deleteRecentChat(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJID = args["jid"] as? String ?? ""
        
        var userJIDs: [String] = []
        userJIDs.append(userJID)
        
        ChatManager.deleteRecentChats(jids: userJIDs, completionHandler: { isSuccess, flyError, flyData in
            result(isSuccess)
        })
        
    }
    static func deleteRecentChats(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJIDList = args["jidlist"] as? [String] ?? []
        
        ChatManager.deleteRecentChats(jids: userJIDList, completionHandler: { isSuccess, FlyError, flyData in
            result(isSuccess)
        })
        
    }
    static func makeAdmin(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupJID = args["jid"] as? String ?? ""
        let userJID = args["userjid"] as? String ?? ""
        
        do{
            
            try GroupManager.shared.makeAdmin(groupJid: groupJID, userJid: userJID, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess {
                    result(isSuccess)
                } else{
                    result(FlutterError(code: "500", message: "Unable to Make User Admin", details: flyError))
                }
            })
        }catch let error{

            result(FlutterError(code: "500", message: "Unable to Make User Admin", details: error.localizedDescription))
        }
        
    }
    
    static func setNotificationSound(call: FlutterMethodCall, result: @escaping FlutterResult){

    }
    
    static func updateGroupName(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        let groupName = args["name"] as? String ?? ""
        
        do{
            try GroupManager.shared.updateGroupName(groupJid: groupJID, groupName: groupName, completionHandler: { isSuccess, flyError, flyData in
                result(isSuccess)
            })
        }catch let error{
            result(FlutterError(code: "500", message: "Unable to Update Group Name", details: error.localizedDescription))
        }
        
    }
    static func updateGroupProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        let groupImageFile = args["file"] as? String ?? ""
        
        do{
            try GroupManager.shared.updateGroupProfileImage(groupJid: groupJID, groupProfileImageUrl: groupImageFile, completionHandler: { isSuccess, flyError, flyData in

                result(isSuccess)
                
            })
        }catch let error{
            result(FlutterError(code: "500", message: "Unable to Update Group Image", details: error.localizedDescription))
        }
        
    }
    static func removeGroupProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        
        do{
            try GroupManager.shared.removeGroupProfileImage(groupJid: groupJID, completionHandler: { isSuccess, flyError, flyData in
                result(isSuccess)
            })
        }catch let error{
            result(FlutterError(code: "500", message: "Unable to Remove Group Image", details: error.localizedDescription))
        }
        
    }
    static func addUsersToGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        let members = args["members"] as? [String] ?? []
        
        do{
            try GroupManager.shared.addParticipantToGroup(groupId: groupJID, newUserJidList: members, completionHandler: { isSuccess, flyError, flyData in
                result(isSuccess)
            })
        }catch let error{
            result(FlutterError(code: "500", message: "Unable to Add Group Members", details: error.localizedDescription))
        }
        
    }
    static func removeMemberFromGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJID = args["jid"] as? String ?? ""
        let userJID = args["userjid"] as? String ?? ""
        
        do{
            try GroupManager.shared.removeParticipantFromGroup(groupId: groupJID, removeGroupMemberJid: userJID, completionHandler: { isSuccess, flyError, flyData in
                result(isSuccess)
            })
        }catch let error{
            result(FlutterError(code: "500", message: "Unable to remove member from group", details: error.localizedDescription))
        }
        
    }
    
    static func getMessageStatusOfASingleChatMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageID = args["messageID"] as? String ?? ""
        let seenReceipt = ChatManager.getSingleChatMessageSeenReceipt(messageId: messageID)
        print("getSingleChatMessageSeenReceipt\(String(describing: seenReceipt))")
        let deliverReceipt = ChatManager.getSingleChatMessageDeliveredReceipt(messageId: messageID)
        print("deliverReceipt\(String(describing: deliverReceipt))")
        let acknowledgeReceipt = ChatManager.getSingleChatMessageAcknowledgeReceipt(messageId: messageID)
        print("acknowledgeReceipt\(String(describing: acknowledgeReceipt))")
        
        var seenResponse = String(format: "%.0f",seenReceipt?.time ?? "")
        var deliveredResponse = String(format: "%.0f",deliverReceipt?.time ?? "")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(seenResponse == "0" ? "" : seenResponse, forKey: "seenTime")
        jsonObject.setValue(deliveredResponse == "0" ? "" : deliveredResponse, forKey: "deliveredTime")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        result(jsonString)
    }
    static func exportChatConversationToEmail(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJID = args["jid"] as? String ?? ""
        
        ChatManager.shared.exportChatConversationToEmail(jid: userJID) { chatDataModel in
            
            var dataToShare = [Any]()
            
            dataToShare.append(chatDataModel.subject)
            dataToShare.append(chatDataModel.messageContent)
            chatDataModel.mediaAttachmentsUrl.forEach { url in
                dataToShare.append(url)
            }
            
        }
        
    }
    
    static func getAllGroups(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let fetchFromServer = args["server"] as? Bool ?? false
        
        print("calling getAllGroups")
        GroupManager.shared.getGroups(fetchFromServer: fetchFromServer) { isSuccess, flyError, flyData in
            
        //need to check response
            if isSuccess {
                var data  = flyData
                
//                let getAllGroupJson = data.dictToJson()
                
                let groupData = data.getData() as? [ProfileDetails]
                
                let groupDataJson = groupData?.toJson()
                
              
//                if let groupJsonData = extractData(from: getAllGroupJson!) { //  getAllGroupJson?.extractJSONObject() {
//
//                    if let groupData = groupJsonData["data"] {
//                        print("GroupManager.shared.getGroups==**==\(groupData)")
//                        result(groupData)
//                    }
//
//                }
                result(groupDataJson)
                
            } else{
                result(FlutterError(code: "500", message: "Unable to Fetch Group List", details: flyError?.localizedDescription))
            }
        }
    }
    
    static func searchConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let searchKey = args["searchKey"] as? String ?? ""
        _ = args["jidForSearch"] as? String ?? ""
        let globalSearch = args["globalSearch"] as? Bool ?? true
        
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
    
    static func isMuted(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJID = args["jid"] as? String ?? ""
        //need to check the fn
//        result(FlyCoreController.shared.isContactMuted(jid: userJID))
        let isMuted = ContactManager.shared.getUserProfileDetails(for: userJID)?.isMuted ?? false
        result(isMuted)
    }
    
    static func isBusyStatusEnabled(call: FlutterMethodCall, result: @escaping FlutterResult){
       result(ChatManager.shared.isBusyStatusEnabled())
    }
    
    static func getUserLastSeenTime(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>

        let jid = args["jid"] as? String ?? ""

        ChatManager.getUserLastSeen( for: jid) { isSuccess, flyError, flyData in
            var data  = flyData
            if isSuccess {
                let lastseenSeconds = data.getData() as? String
                if let seconds = Int(lastseenSeconds ?? "0") {
                    let timestamp = subtractSecondsAndGetTimestamp(seconds: TimeInterval(seconds))

                    result(String(Int(timestamp)))
                }

            } else{

                result(FlutterError(code: "500", message: "Unable to Fetch User Last seen", details: data.getMessage()))
            }
        }
    }
    static func subtractSecondsAndGetTimestamp(seconds: TimeInterval) -> TimeInterval {
        let currentDate = Date()
        let earlierDate = currentDate.addingTimeInterval(-seconds)
        let timestamp = earlierDate.timeIntervalSince1970 * 1000
        return timestamp
    }
    static func getRecentChatList(call: FlutterMethodCall, result: @escaping FlutterResult){
        
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
                        result(FlutterError(code: "500", message: "Error Parsing the Recent Chat List", details: nil))
                    }

                }

            } else {

                result(FlutterError(code: "500", message: "Unable to Fetch Recent Chat List", details: flyError?.localizedDescription))

            }
        }
    }
    
    static func getRecentChatListHistory(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>

        let isFirstSet = args["firstSet"] as? Bool ?? true
        
        let limit = args["limit"] as? Int ?? 15
        
        recentChatListParams.limit = limit
        
        if(recentChatListBuilder == nil){
            print("recentChatListBuilder is nil")
            recentChatListBuilder =  RecentChatListBuilder(recentChatListParams: recentChatListParams)
        }else{
            print("recentChatListBuilder already set")
        }
        if(isFirstSet){
            
            print("loading first set")
            recentChatListBuilder!.loadRecentChatList { isSuccess, flyError, flyData in
                var data  = flyData
                if (isSuccess) {
                    let recentChatArray  = data.getData() as? [RecentChat] ?? []
                    if(recentChatArray.isEmpty){
                        result("{\"data\": [] }")
                    }else{
                        if let recentChatJson = recentChatArray.toJson() {
                            let recentChatListJson = "{\"data\":" + recentChatJson + "}"
                            print("ChatManager.getRecentChatList==**==\(recentChatListJson)")
                            result(recentChatListJson)
                        } else {
                            print("Failed to convert object to JSON")
                            result(FlutterError(code: "500", message: "Error Parsing the Recent Chat List", details: nil))
                        }
                        
                    }
                } else {
                    // Fetch recentchat failed print error to know more about the exception
                    result(FlutterError(code: "500", message: "Unabke to fetch the Recent Chat List", details: nil))
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
                                result(FlutterError(code: "500", message: "Error Parsing the Recent Chat List", details: nil))
                            }
                            
                        }
                    } else {
                        // Fetch recentchat failed print error to know more about the exception
                        result(FlutterError(code: "500", message: "Unabke to fetch the Recent Chat List", details: nil))
                    }
                }
            }else{
                print("Next set data is not available")
                result("{\"data\": [] }")
            }


        }
    }
    
    static func getRecentChatListHistoryByTopic(call: FlutterMethodCall, result: @escaping FlutterResult){
        
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
                            print("Failed to convert object to JSON")
                            result(FlutterError(code: "500", message: "Error Parsing the Topic based Recent Chat List", details: nil))
                        }
                        
                    }
                } else {
                    // Fetch recentchat failed print error to know more about the exception
                    result(FlutterError(code: "500", message: "Unable to fetch the Topic based Recent Chat List", details: nil))
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
                                print("Failed to convert object to JSON")
                                result(FlutterError(code: "500", message: "Error Parsing the Topic based Recent Chat List", details: nil))
                            }
                            
                        }
                    } else {
                        // Fetch recentchat failed print error to know more about the exception
                        result(FlutterError(code: "500", message: "Unabke to fetch the Topic based Recent Chat List", details: nil))
                    }
                }
//            }else{
//                print("Next set data is not available")
//                result("{\"data\": [] }")
//            }


        }
    }

    static func initializeMessageList(call: FlutterMethodCall, result: @escaping FlutterResult){

        let args = call.arguments as! Dictionary<String, Any>


        if let messageId = args["messageId"] as? String {
            messageListParams.messageId = messageId
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

        messageListQuery = FetchMessageListQuery(fetchMessageListParams: messageListParams)

        result(true)

    }

    static func loadMessages(call: FlutterMethodCall, result: @escaping FlutterResult){

        if(messageListQuery == nil){
            NSLog("\(Constants.tag) Message List Not Initialized")
            result(FlutterError(code: "500", message: "Message List Not Initialized", details: nil))
        }
        if(messageListQuery?.isFetchingInProgress() ?? false){
            result(FlutterError(code: "500", message: "Fetching Query is already in Progress", details: nil))
        }
        messageListQuery?.loadMessages { isSuccess, flyError, flyData in
           var data  = flyData
           if (isSuccess) {
                let messageList  = data.getData() as? [ChatMessage]

               if let chatJson = messageList.toJson() {
//                   NSLog("\(Constants.tag) Initial Message List \(chatJson)")
                   print("\(Constants.tag) Initial Message List ios \(chatJson)")
                   result(chatJson)
               } else {
                   NSLog("\(Constants.tag) Initial Message List Load Failed")
                   print("\(Constants.tag) Initial Message List Load Failed")

                   result(FlutterError(code: "500", message: "Failed to Encode Chat Messages", details: nil))
               }
           } else {
               NSLog("\(Constants.tag) Initial Message List Load Failed")
               result(FlutterError(code: "500", message: "Failed to Load Chat Messages", details: flyError?.localizedDescription))
           }
       }
    }

    static func loadPreviousMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        print("calling previous message")
        if(messageListQuery == nil){
            NSLog("\(Constants.tag) Message List Not Initialized")
            result(FlutterError(code: "500", message: "Message List Not Initialized", details: nil))
        }

        if(!(messageListQuery?.hasPreviousMessages() ?? false)){
            NSLog("\(Constants.tag) Reached Complete Previous Message List")
            result(nil)
        }
        if(messageListQuery?.isFetchingInProgress() ?? false){
            result(FlutterError(code: "500", message: "Fetching Query is already in Progress", details: nil))
        }
        messageListQuery?.loadPreviousMessages { isSuccess, flyError, flyData in
            var data  = flyData
            if (isSuccess) {
                let messageList  = data.getData() as? [ChatMessage]
                if let chatJson = messageList.toJson() {
                    print("\(Constants.tag) Previous Message List \(chatJson)")
                    if !(messageList?.isEmpty ?? true){
                        result(chatJson)
                    }

                } else {
                    NSLog("\(Constants.tag) Previous Message List Load Failed")
                    result(FlutterError(code: "500", message: "Failed to Encode Previous Chat Messages", details: nil))
                }
            } else {
                NSLog("\(Constants.tag) Initial Message List Load Failed")
                result(FlutterError(code: "500", message: "Failed to Load Previous Chat Messages", details: flyError?.localizedDescription))
            }
        }
    }

    static func loadNextMessages(call: FlutterMethodCall, result: @escaping FlutterResult){

        if(messageListQuery == nil){
            NSLog("\(Constants.tag) Message List Not Initialized")
            result(FlutterError(code: "500", message: "Message List Not Initialized", details: nil))
        }

        if(!(messageListQuery?.hasNextMessages() ?? false)){
            result(nil)
        }

        messageListQuery?.loadNextMessages { isSuccess, flyError, flyData in
          var data  = flyData
          if (isSuccess) {
                let messageList  = data.getData() as? [ChatMessage]
              if let chatJson = messageList.toJson() {
                  print("\(Constants.tag) Next Message List \(chatJson)")
//                  NSLog("\(Constants.tag) Next Message List \(chatJson)")

                  result(chatJson)
              } else {
                  NSLog("\(Constants.tag) Next Message List Load Failed")
                  result(FlutterError(code: "500", message: "Failed to Encode Next Chat Messages", details: nil))
              }
          } else {
              NSLog("\(Constants.tag) Initial Message List Load Failed")
              result(FlutterError(code: "500", message: "Failed to Load Next Chat Messages", details: flyError?.localizedDescription))
          }
        }
    }



    static func getRecentChatListIncludingArchived(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let recentChatList = ChatManager.getRecentChatListIncludingArchived()
        let recentChatListJson = recentChatList.toJson()
        print("getRecentChatListIncludingArchived==**==\(String(describing: recentChatListJson))")
        result(recentChatListJson)
    }
    
    static func getRecentChatOf(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        print("getRecentChatOf jid --> \(String(describing: jid))")
        let recentChat = ChatManager.getRecentChatOf(jid:jid)
        print("recentChat-->\(String(describing: recentChat))")
        if(recentChat == nil){
            result(nil)
        }
        
        let recentChatJson = recentChat?.toJson()
        print("getRecentChatOf==**==\(String(describing: recentChatJson))")
        result(recentChatJson)
    }
    static func recentChatPinnedCount(call: FlutterMethodCall, result: @escaping FlutterResult){
        let recentPinCount = ChatManager.recentChatPinnedCount()
        result(recentPinCount)
    }
    
    static func setOnGoingChatUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        ChatManager.setOnGoingChatUser(jid: userJid)
    }
    static func reportUserOrMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
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
    static func blockUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["userJID"] as? String ?? ""
        
        do{
            
            try ContactManager.shared.blockUser(for: userJid){ isSuccess, flyError, flyData in

                if isSuccess {
                    let blockUserResponseJson = flyData.dictToJson()
                    print("ContactManager.shared.blockUser==**==\(String(describing: blockUserResponseJson))")
                    result(blockUserResponseJson)
                } else{
                    result(FlutterError(code: "500", message: "Unable to Block User", details: flyError?.localizedDescription))
                }
            }
        }catch let error{
            
            result(FlutterError(code: "500", message: "Unable to Block User", details: error.localizedDescription))
        }
        
    }
    static func unblockUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["userJID"] as? String ?? ""
        
        do{
            
            try ContactManager.shared.unblockUser(for: userJid){ isSuccess, flyError, flyData in

                if isSuccess {
                    result(true)
                } else{
                    result(FlutterError(code: "500", message: "Unable to Un-Block User", details: flyError?.localizedDescription))
                }
            }
        }catch let error{
            result(FlutterError(code: "500", message: "Unable to Un-Block User", details: error.localizedDescription))
        }
        
    }
    static func createGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
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
                if let fileUrl = saveFile(from: sourceURL, fileName: fileName) {
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
                    result(groupProfileDataJson)
                } else{
                    result(FlutterError(code: "500", message: "Unable to Create Group", details: flyError?.localizedDescription))
                }
            })
            
            
        }catch let error{
            result(FlutterError(code: "500", message: "Unable to Create Group", details: error.localizedDescription))
        }
        
    }
    
    static func clearChat(call: FlutterMethodCall, result: @escaping FlutterResult){
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
        
        let lastMessageId = ChatManager.getLastMessageId(jid: userJid)
        
        ChatManager.clearChat(toJid: userJid, chatType: chatType!, clearChatExceptStarred: clearExceptStarred) { (isSuccess, flyerror, resultDict) in
            
            if(isSuccess){
                result(true)
            }else{
                result(false)
            }
        }

    }
    static func getUsersIBlocked(call: FlutterMethodCall, result: @escaping FlutterResult){
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
                result(FlutterError(code: "500", message: "Unable to Fetch Blocked List", details: flyError?.localizedDescription))
            }
        }

    }
    static func getMediaMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        ChatManager.getVideoImageAudioMessageGroupByMonth(jid: userJid) { isSuccess,error,data  in
            
            if isSuccess {
                var mediaData = data
                let chatMessages = mediaData.getData() as? [[ChatMessage]]
                
                if(chatMessages!.isEmpty){
                    result(nil)
                }else{
                    var mediaMsgJson = chatMessages?.toJson()
                    mediaMsgJson = mediaMsgJson?.replacingOccurrences(of: "[[", with: "[")
                    mediaMsgJson = mediaMsgJson?.replacingOccurrences(of: "]]", with: "]")
                    print("ChatManager.getVedioImageAudioMessageGroupByMonth==**==\(String(describing: mediaMsgJson))")
                    result(mediaMsgJson)
                }
                
            }else{
                result(FlutterError(code: "500", message: "Unable to Fetch Media Messages", details: error?.localizedDescription))
            }
        }

    }
    static func getDocsMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>

        let userJid = args["jid"] as? String ?? ""


        ChatManager.getDocumentMessageGroupByMonth(jid: userJid) { isSuccess, error, data in
            if isSuccess{
                var flydata = data
                let mediaMessages : [[ChatMessage]] = flydata.getData() as? [[ChatMessage]] ?? []
                if (mediaMessages.isEmpty){
                    result(nil)
                }else{
                    var mediaMsgJson = mediaMessages.toJson()
                    mediaMsgJson = mediaMsgJson?.replacingOccurrences(of: "[[", with: "[")
                    mediaMsgJson = mediaMsgJson?.replacingOccurrences(of: "]]", with: "]")
                    print("ChatManager.getDocumentMessageGroupByMonth==**==\(String(describing: mediaMsgJson))")
                    result(mediaMsgJson)
                }
            }else{
                result(FlutterError(code: "500", message: "Unable to Fetch Document Messages", details: error?.localizedDescription))
            }
        }

    }
    
    static func getLinkMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        
        ChatManager.getLinkMessageGroupByMonth(jid: userJid) { isSuccess, error, data  in
            if isSuccess{
                var flydata = data
                let mediaLinkMessages = flydata.getData() as? [[LinkMessage]] ?? []
                
                if (mediaLinkMessages.isEmpty){
                    result(nil)
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
                result(FlutterError(code: "500", message: "Unable to Fetch Link Messages", details: error?.localizedDescription))
            }
        }
    }
    
    static func isAdmin(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJid = args["group_jid"] as? String ?? ""
        let userJid = args["jid"] as? String ?? ""
        
        result(GroupManager.shared.isAdmin(participantJid: userJid, groupJid: groupJid).isAdmin)
        
    }
    static func leaveFromGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJid = args["groupJid"] as? String ?? ""
        let userJid = args["userJid"] as? String ?? ""
        
        try! GroupManager.shared.leaveFromGroup(groupJid: groupJid, userJid: userJid) { isSuccess,error,data in
            result(isSuccess)
        }
    }
    
    static func getMediaAutoDownload(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(ChatManager.isAutoDownloadEnabled())
    }
    
    static func setMediaAutoDownload(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let autoDownloadEnable = args["enable"] as? Bool ?? false
//        FlyDefaults.autoDownloadEnable = autoDownloadEnable
//        FlyDefaults.autoDownloadLastEnabledTime = autoDownloadEnable ? FlyUtils.getTimeInMillis() : 0
        ChatManager.shared.enableAutoDownload(isEnable: autoDownloadEnable)
        result(true)
    }
    
    static func getMediaSetting(call: FlutterMethodCall, result: @escaping FlutterResult){
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
    
    static func saveMediaSettings(call: FlutterMethodCall, result: @escaping FlutterResult){
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
    
    static func updateArchiveUnArchiveChat(call: FlutterMethodCall, result: @escaping FlutterResult){
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

            }else{
                //archive/unarchive chat failed
            }
            
            result(isSuccess)
        }



    }
    static func logoutOfChatSDK(call: FlutterMethodCall, result: @escaping FlutterResult){

        NSLog("#VOIP ******* logging out")
        ChatManager.logoutApi { isSuccess, flyError, flyData in
            if isSuccess {
                //        ChatManager.enableContactSync(isEnable: ENABLE_CONTACT_SYNC)
                ChatManager.disconnect()
                ChatManager.shared.resetFlyDefaults()
                Utility.clearUserDefaults()
                Utility.saveInPreference(key: Constants.isProfileSaved, value: false)
                Utility.saveInPreference(key: Constants.isLoggedIn, value: false)
                result(isSuccess)
            }else{
                result(FlutterError(code: "500", message: "Unable to Logout", details: flyError?.localizedDescription))
            }
        }
    }
    
    static func getMessageOfId(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let messageId = args["mid"] as? String ?? ""
        
        let message : ChatMessage? = FlyMessenger.getMessageOfId(messageId: messageId)
        
        let messageJson = message?.toJson()
        print("getMessageOfId==**==\(String(describing: messageJson))")
        result(messageJson)

    }
    static func getArchivedChatList(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        /*  Note that when chat history is disabled, need to call ChatManager.getArchivedChatsFromServer to fetch the archive chat list from server to local DB */
        
        ChatManager.getArchivedChatList { (isSuccess, flyError, resultDict) in
            if isSuccess {
                var flydata = resultDict
                print(flydata.getData())

                let archiveData = flydata.getData() as? [RecentChat] ?? []
                print("Archive chat list get")
                if(archiveData.isEmpty){
                    result("{\"data\": [] }")
                }else{

                    let archiveChatJson = archiveData.toJson()

                    let archiveChatListJson = "{\"data\":" + (archiveChatJson ?? "[]") + "}"
                    print("ChatManager.getArchivedChatList==**==\(archiveChatJson)")
                    result(archiveChatListJson)
                }

            }else{
                result(FlutterError(code: "500", message: "Unable to Fetch Archived List", details: flyError?.localizedDescription))
            }
        }
        result(true)
    }
    
    static func getProfileDetails(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        print(userJid)
        
        if let userProfile = userlist.filter({$0.jid == userJid}).first {
            
            ContactManager.shared.saveUser(profileDetails: userProfile)
            let userProfileJson = userProfile.toJson()
            result(userProfileJson)
        }else{
            let userProfile = ChatManager.profileDetaisFor(jid: userJid)
            let userProfileJson = userProfile.toJson()
            print("getProfileDetails==**==\(String(describing: userProfileJson))")
            result(userProfileJson)
        }

    }
    static func deleteAccount(call: FlutterMethodCall, result: @escaping FlutterResult){
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
                result(deleteResponseJson)
            } else{
                result(FlutterError(code: "500", message: "Unable to Delete Account", details: flyError?.localizedDescription))
            }
        }

    }
    static func getGroupMessageDeliveredToList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageId = args["messageId"] as? String ?? ""
        let jid = args["jid"] as? String ?? ""
        let groupMessageDeliveredList = GroupManager.shared.getMessageDeliveredListBy(messageId: messageId, groupId: jid)
        print("groupMessageDeliveredList=>\(groupMessageDeliveredList)")
        let deliveredCount = groupMessageDeliveredList.deliveredCount
        let totalParticipatCount = groupMessageDeliveredList.totalParticipatCount
        
        let groupMessageDeliveredListJson = groupMessageDeliveredList.deliveredParticipantList.toJson() ?? "[]"
        
        let deliveredListJson = "{\"deliveredCount\": \"\(String(deliveredCount))\",\"totalParticipatCount\" : \(String(totalParticipatCount)),\"deliveredParticipantList\" : " + groupMessageDeliveredListJson + "}"
        

        print("getGroupMessageDeliveredToList==**==\(String(describing: deliveredListJson))")
        result(deliveredListJson)
    }
    
    static func getGroupMessageReadByList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageId = args["messageId"] as? String ?? ""
        let jid = args["jid"] as? String ?? ""
        //need to check response.
        let groupMessageReadList = GroupManager.shared.getMessageSeenListBy(messageId: messageId, groupId: jid)
        print("groupMessageReadList=> \(groupMessageReadList)")
        
        var deliveredCount = groupMessageReadList.seenCount
        var totalParticipatCount = groupMessageReadList.totalParticipatCount
        let groupMessageReadListJson = groupMessageReadList.seenParticipantList.toJson() ?? "[]"
        
        let readListJson = "{\"deliveredCount\": \"\(String(deliveredCount))\",\"totalParticipatCount\" : \(String(totalParticipatCount)),\"seenParticipantList\" : " + groupMessageReadListJson + "}"
        
        
        print("getGroupMessageReadByList==**==\(String(describing: readListJson))")
        result(readListJson)

    }
    static func addContact(call: FlutterMethodCall, result: @escaping FlutterResult){
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
    static func setDefaultNotificationSound(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        result("")
    }
    static func deleteGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["jid"] as? String ?? ""
        
        do{
            try GroupManager.shared.deleteGroup(groupJid: groupJid, completionHandler: { isSuccess, flyError, flyData in
                result(isSuccess)
            })
        }catch let error{
            print("#Plugin Error ---> ChatManger Set Iv key Failed, \(error.localizedDescription)")
            result(false)
        }
        
        
    }
    
    static func updateFcmToken(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let token = args["token"] as? String ?? ""
        
        VOIPManager.sharedInstance.savePushToken(token: token)
        Utility.saveInPreference(key: Constants.googleToken, value: token)
        VOIPManager.sharedInstance.updateDeviceToken()
        
        result(true)
    }

    static func handleReceivedMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        NSLog("#Mirrorfly handleReceivedMessage")
        
    }
    static func getUnreadMessageCountExceptMutedChat(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let (messageCount, chatCount) = ChatManager.getUnreadMessageAndChatCountForUnmutedUsers()
        
        print("chatCount \(chatCount)")
        
        result(messageCount)
        
    }
    
    static func createTopic(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let topicName = args["topicName"] as? String ?? ""
        let metaData = args["metaData"] as? [[String: Any]] ?? []
        print("metaData \(String(describing: metaData))")
        var metaDataArray : [MetaData] = []
        for data in metaData {
            var obj = MetaData(key: data["key"] as? String ?? "", value: data["value"] as? String ?? "")
            metaDataArray.append(obj)
        }
//        ["message": Topic created successfully, "data": {
//            topicId = "0b290e7f-b05c-4859-a72d-100c48f73c8d";
//        }, "status": 200]
        ChatManager.createTopic(topicName: topicName,metaData: metaDataArray) { isSuccess, error, data in
            print("createTopic ==**==\(data)")
            if isSuccess{
                var resp = data
                if let response = resp.getData() as? [String: Any] {
                    if let topicId = response["topicId"] as? String {
                        result(topicId)
                    }else{
                        result(FlutterError(code: "500",message: "data not found",details: nil))
                    }
                }else{
                    result(FlutterError(code: "500",message: "data not found",details: nil))
                }
            }else{
                result(FlutterError(code: "500",message: error?.localizedDescription,details: nil))
            }
        }
    }
    
    static func getTopics(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let topicIds = args["topicIds"] as? [String] ?? []
        ChatManager.getTopics(topicIds: topicIds) { isSuccess, error, data in
            if isSuccess{
                var resp = data
                if let response = resp.getData() as? [String: Any] {
                    if let topics = response["topics"] as? [[String: Any]] {
                        print("getTopics ==**==\(topics.toJSONString())")
                        result(topics.toJSONString())
                    }else{
                        result(FlutterError(code: "500",message: "data not found",details: nil))
                    }
                }else{
                    result(FlutterError(code: "500",message: "data not found",details: nil))
                }
            }else{
                print("getTopics error \(error?.localizedDescription)")
                result(FlutterError(code: "500",message: error?.localizedDescription,details: nil))
            }
        }
    }
}



