//
//  FlySdkMethodCalls.swift
//  fly_chat
//
//  Created by user on 23/03/23.
//

import Foundation
import FlyCore
import FlyCommon
import Flutter
import Photos
import FlyDatabase
import Contacts
import ContactsUI


@objc class FlySdkMethodCalls : NSObject{
    
    static var isTrialLicenceKey : Bool = true;
    static var isContactSyncInProgress : Bool = false;
    
    static func buildChatSDK(call: FlutterMethodCall) {
        let args = call.arguments as! Dictionary<String, Any>
        
        var domainBaseUrl = args["domainBaseUrl"] as? String ?? ""
        var licenseKey = args["licenseKey"] as? String ?? ""
        let enableMobileNumberLogin = args["enableMobileNumberLogin"] as? Bool ?? true
        isTrialLicenceKey = args["isTrialLicenceKey"] as? Bool ?? true
        let enableSDKLog = args["enableSDKLog"] as? Bool ?? false
        let maximumRecentChatPin = args["maximumRecentChatPin"] as? Int ?? 3
        
    
        var ivKey = args["ivKey"] as? String ?? ""
        var containerID = args["iOSContainerID"] as? String ?? ""
        
        var groupConfig = args["groupConfig"] as? [String : Any]
        
        var groupCreationEnable = groupConfig?["enableGroup"] as? Bool ?? true
        var adminOnlyAddRemoveAccess = groupConfig?["adminOnlyAddRemoveAccess"] as? Bool ?? true
        var maxMembersCount = groupConfig?["maxMembersCount"] as? Int ?? 200
        
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

        do{
            try ChatManager.shared.setIV(iv: ivKey)
        }catch let error{
            print("#Plugin Error ---> ChatManger Set Iv key Failed, \(error.localizedDescription)")
        }
        
        ChatManager.disableLocalNotification()
        
        ChatManager.enableContactSync(isEnable: !isTrialLicenceKey)
        
        
//        FlyChatPlugin.initializeEventListeners()
      }
    
    static func registerUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        var userIdentifier = args["userIdentifier"] as? String ?? ""
        var deviceToken = args["token"] as? String ?? ""
        
        userIdentifier = userIdentifier.replacingOccurrences(of: "+", with: "")
        
        if(userIdentifier.isEmpty){
            result(FlutterError(code: "500",
                                message: "User Name is Empty",
                                details: nil))
            return
        }
        
        try! ChatManager.registerApiService(for: userIdentifier, deviceToken: deviceToken, isExport: false) { isSuccess, flyError, flyData in
            var data = flyData
            if isSuccess {
                
                print("Register Response")
                
                let registerResponse = [
                    "data": data,
                    "is_new_user": data["newLogin"] as Any,
                    "message" : "Register Trial API Success"
                ] as [String : Any]
                
                FlyDefaults.isLoggedIn = true
                FlyDefaults.myXmppPassword = data["password"] as! String
                FlyDefaults.myXmppUsername = data["username"] as! String
                FlyDefaults.myMobileNumber = userIdentifier
                FlyDefaults.isProfileUpdated = data["isProfileUpdated"] as! Int == 1
                
                ChatManager.connect()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    result(JSONSerializer.toSimpleJson(from: registerResponse))
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
        
        if(txtMessage == nil || receiverJID == nil){
            result(FlutterError(code: "500", message: "Parameters Missing", details: nil))
            return
        }
        
        FlyMessenger.sendTextMessage(toJid: receiverJID!, message: txtMessage!.trimmingCharacters(in: .whitespacesAndNewlines), replyMessageId: replyMessageID) { isSuccess,error,chatMessage in
            if isSuccess {
                print("sending text messages-->\(chatMessage?.messageTextContent ?? "Message is Empty")")
                var chatMsg = JSONSerializer.toJson(chatMessage as Any)
                chatMsg = chatMsg.replacingOccurrences(of: "{\"some\":", with: "")
                chatMsg = chatMsg.replacingOccurrences(of: "}}", with: "}")
                print(chatMsg)
                result(chatMsg)
            }else{
                result(FlutterError(code: "500", message: JSONSerializer.toSimpleJson(from: error as Any), details: nil))
            }
        }
        
    }
    
    static func sendLocationMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let latitude = args["latitude"] as? Double ?? 00.0
        let longitude = args["longitude"] as? Double ?? 00.0
        let userJid = args["jid"] as? String ?? nil
        let replyMessageID = args["replyMessageId"] as? String ?? ""
        
        if(latitude == 00.0 || longitude == 00.0){
            result(FlutterError(code: "500", message: "Location is Empty", details: nil))
            return
        }
        if(userJid == nil){
            result(FlutterError(code: "500", message: "Location is Empty", details: nil))
            return
        }
        
        FlyMessenger.sendLocationMessage(toJid: userJid!, latitude: latitude, longitude: longitude, replyMessageId: replyMessageID) { isSuccess,error,chatMessage in
            if isSuccess {
                var locationResponse = JSONSerializer.toJson(chatMessage as Any)
                
                locationResponse = locationResponse.replacingOccurrences(of: "{\"some\":", with: "")
                locationResponse = locationResponse.replacingOccurrences(of: "}}", with: "}")
                print(locationResponse)
                
                result(locationResponse)
            }else{
                result(FlutterError(code: "500", message: JSONSerializer.toSimpleJson(from: error as Any), details: nil))
            }
        }
    }
    
    static func sendImageMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? nil
        let filePath = args["filePath"] as? String ?? ""
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        
        let caption = args["caption"] as? String ?? ""
        
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
        
        FlyMessenger.sendImageMessage(toJid: userJid!, mediaData: media, replyMessageId: replyMessageId){isSuccess,error,message in
//            if isSuccess {
                
                var response = JSONSerializer.toJson(message as Any)
                response = response.replacingOccurrences(of: "{\"some\":", with: "")
                response = response.replacingOccurrences(of: "}}", with: "}")
                result(response)
//            }else{
//                result(FlutterError(code: "500", message: JSONSerializer.toSimpleJson(from: error as Any), details: nil))
//            }
        }
    }
    
    static func sendAudioMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        let isRecorded = args["isRecorded"] as? Bool ?? false
        let audiofilePath = args["filePath"] as? String ?? ""
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
                
                FlyMessenger.sendAudioMessage(toJid:  userJid, mediaData: mediaData, replyMessageId :  replyMessageId, isRecorded : isRecorded) { isSuccess,error,message in
                    if message != nil {
                        
                        var audioResponse = JSONSerializer.toJson(message as Any)
                        
                        audioResponse = audioResponse.replacingOccurrences(of: "{\"some\":", with: "")
                        audioResponse = audioResponse.replacingOccurrences(of: "}}", with: "}")
                        print(audioResponse)
                        
                        result(audioResponse)
                        
                    }else{
                        result(FlutterError(code: "500", message: JSONSerializer.toSimpleJson(from: error as Any), details: nil))
                    }
                }
            }
        }
        
    }
    
    static func isArchivedSettingsEnabled(call: FlutterMethodCall, result: @escaping FlutterResult){
        result(FlyDefaults.isArchivedChatEnabled)
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
                var userlist = flyData
                
                let userData = JSONSerializer.toJson(userlist.getData())
                
                let totalPages = userlist["totalPages"] as! Int
                let message = userlist["message"] as! String
                var userlistJson = ""
                if(userData.isEmpty){
                    userlistJson = "{\"total_pages\": " + String(totalPages) + ",\"message\" : \"" + message + "\",\"status\" : true,\"data\":[]}"
                }else{
                    userlistJson = "{\"total_pages\": " + String(totalPages) + ",\"message\" : \"" + message + "\",\"status\" : true,\"data\":" + userData + "}"
                }
                 
                userlistJson = userlistJson.replacingOccurrences(of: "{\"some\": {}}", with: "\"\"")
                userlistJson = userlistJson.replacingOccurrences(of: "\"nickName\": {}", with: "\"nickName\": \"\"")
                
                result(userlistJson)
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
                    userData = JSONSerializer.toJson(list as Any)
                    userData = userData.replacingOccurrences(of: "\"some\":", with: "")
//                    userData = userData.replacingOccurrences(of: "]", with: "")
                }else{
                    userData = JSONSerializer.toJson(data.getData())
                }
                print("-------->>>> \(userData)")
                let message = data["message"] as! String
                var userlistJson = "{\"message\" : \"" + message + "\",\"status\" : true,\"data\":" + userData + "}"
                
                userlistJson = userlistJson.replacingOccurrences(of: "{\"some\": {}}", with: "\"\"")
                userlistJson = userlistJson.replacingOccurrences(of: "\"nickName\": {}", with: "\"nickName\": \"\"")
                
                print("userListJson \(userlistJson)")
                
                result(userlistJson)
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
                
                FlyMessenger.sendVideoMessage(toJid: userJid, mediaData: media, replyMessageId: replyMessageId){ isSuccess,error,message in
//                    if isSuccess{
                        if let chatMessage = message {
                            
                            var sendVideoResposne = JSONSerializer.toJson(chatMessage)
                            
                            sendVideoResposne = sendVideoResposne.replacingOccurrences(of: "{\"some\":", with: "")
                            sendVideoResposne = sendVideoResposne.replacingOccurrences(of: "}}", with: "}")
                            print(sendVideoResposne)
                            result(sendVideoResposne)
                            
                        }
//                    }else{
//                        result(FlutterError(code: "500", message: JSONSerializer.toSimpleJson(from: error as Any), details: nil))
//                    }
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
        let contactList = args["contact_list"] as? [String] ?? []
        
        FlyMessenger.sendContactMessage(toJid: userJid, contactName: contactName, contactNumbers: contactList, replyMessageId: replyMessageId){ isSuccess,error,message  in
            if message != nil {
                
                var contactMessageResponse = JSONSerializer.toJson(message as Any)
                
                contactMessageResponse = contactMessageResponse.replacingOccurrences(of: "{\"some\":", with: "")
                contactMessageResponse = contactMessageResponse.replacingOccurrences(of: "}}", with: "}")
                
                result(contactMessageResponse)
                
            }else{
                result(FlutterError(code: "500", message: JSONSerializer.toSimpleJson(from: error as Any), details: nil))
            }
        }
    }
    
    
    static func sendDocumentMessage(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["jid"] as? String ?? ""
        
        let replyMessageId = args["replyMessageId"] as? String ?? ""
        
        let documentFilePath = args["file"] as? String ?? ""
        let documentFileUrl = URL(fileURLWithPath: documentFilePath)
        
        
        MediaUtils.processDocument(url: documentFileUrl){ isSuccess,localPath,fileSize,fileName, errorMessage in
            if !isSuccess {
                if !errorMessage.isEmpty {
                    result(FlutterError(code: "500", message: JSONSerializer.toSimpleJson(from: errorMessage as Any), details: nil))
                }
                return
            }
            if let localPathURL = localPath, isSuccess {
                var mediaData = MediaData()
                mediaData.fileName = fileName
                mediaData.fileURL = localPathURL
                mediaData.fileSize = fileSize
                mediaData.mediaType = .document
                
                FlyMessenger.sendDocumentMessage(toJid: userJid,mediaData: mediaData,replyMessageId: replyMessageId) { isSuccess, error, message in
                    if message != nil {
                        print("sendDocumentMessage")
                        var documentMessageResponse = JSONSerializer.toJson(message as Any)
                        
                        documentMessageResponse = documentMessageResponse.replacingOccurrences(of: "{\"some\":", with: "")
                        documentMessageResponse = documentMessageResponse.replacingOccurrences(of: "}}", with: "}")
                        
                        result(documentMessageResponse)
                        
                    }else{
                        result(FlutterError(code: "500", message: JSONSerializer.toSimpleJson(from: error as Any), details: nil))
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
        let profileStatusJson = JSONSerializer.toJson(profileStatus)
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
                let statusResponse = ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: true)
            }else{
                let statusResponse = ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: false)
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
                let statusUpdateResponse = ChatManager.updateStatus(statusId: statusId ,statusText: statusText,currentStatus: true)
            }
            else{
                let statusUpdateResponse = ChatManager.updateStatus(statusId: status.id, statusText: status.status, currentStatus: false)
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
        
        FlyMessenger.composeForwardMessage(messageIds: messageIDList, toJidList: userList)
        
        result("Message Forward Success")
        
    }
    
    static func isMemberOfGroup(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let groupJid = args["jid"] as? String ?? ""
        let currentJid = FlyDefaults.myXmppUsername + "@" + FlyDefaults.xmppDomain
        let participantJid = args["userjid"] as? String ?? currentJid
        
        
        let isMember = GroupManager.shared.isParticiapntExistingIn(groupJid: groupJid,
                                                                   participantJid: participantJid)
        
        result(isMember.doesExist)
        
    }
    static func getGroupMembersList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let groupJid = args["jid"] as? String ?? ""
        var groupMembers = [GroupParticipantDetail]()
        
        groupMembers = GroupManager.shared.getGroupMemebersFromLocal(groupJid: groupJid).participantDetailArray.filter({$0.memberJid != FlyDefaults.myJid})
        let myJid = GroupManager.shared.getGroupMemebersFromLocal(groupJid: groupJid).participantDetailArray.filter({$0.memberJid == FlyDefaults.myJid})
        myJid[0].profileDetail?.nickName = "You"
        myJid[0].profileDetail?.name = "You"
        groupMembers = groupMembers.sorted(by: { $0.profileDetail?.name.lowercased() ?? "" < $1.profileDetail?.name.lowercased() ?? "" })
//        groupMembers.insert(contentsOf: myJid)
        groupMembers.append(contentsOf: myJid)
        
        var groupMemberProfile: String = "["
        
        groupMembers.forEach{ groupMember in
            var profileDetailJson = JSONSerializer.toJson(groupMember.profileDetail as Any)
            profileDetailJson = profileDetailJson.replacingOccurrences(of: "{\"some\":", with: "")
            profileDetailJson = profileDetailJson.replacingOccurrences(of: "}}", with: "}")
            profileDetailJson = profileDetailJson.replacingOccurrences(of: "{}", with: "\"\"")
             
            groupMemberProfile = groupMemberProfile + profileDetailJson + ","
            
        }
        groupMemberProfile = groupMemberProfile.dropLast() + "]"
    
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
        
        var starredMessages =  ChatManager.getFavouriteMessages()
        
        var starredMessagesJson = JSONSerializer.toJson(starredMessages)
        
        starredMessagesJson = starredMessagesJson.replacingOccurrences(of: "{\"some\":", with: "")
        starredMessagesJson = starredMessagesJson.replacingOccurrences(of: "}}", with: "}")
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
        result(savedMessage)
        
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
                if isSuccess {
                    
                    let profileJSON = "{\"data\" : " + JSONSerializer.toJson(data.getData() as Any) + ",\"status\": true}"
                    print("profileJSON-->\(profileJSON)")
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
        
        //        let jid = args["jid"] as? String ?? ""
        let email = args["email"] as? String ?? ""
        let mobile = args["mobile"] as? String ?? ""
        let nickName = args["name"] as? String ?? ""
        let status = args["status"] as? String ?? ""
        let image = args["image"] as? String ?? nil
        let userJid = FlyDefaults.myXmppUsername + "@" + FlyDefaults.xmppDomain
        
        
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
                
                let profileData = data.getData()
                let message = data.getMessage()

                let profileDataJson = JSONSerializer.toJson(profileData)

                var profileResponseJson = "{\"status\": true ,\"message\" : \"\(message)\" ,\"data\": \(profileDataJson) }"

                saveMyProfileDataToUserDefaults(profile: myProfile)
                
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
        FlyDefaults.myName = profile.name
        FlyDefaults.myImageUrl = profile.image
        FlyDefaults.myMobileNumber = profile.mobileNumber
        FlyDefaults.myStatus = profile.status
        FlyDefaults.myEmail = profile.email
        
        self.saveMyJidAsContacts()
    }
    
    static func saveMyJidAsContacts() {
        let profileData = ProfileDetails(jid: FlyDefaults.myJid)
        profileData.name = FlyDefaults.myName
        profileData.nickName = FlyDefaults.myNickName
        profileData.mobileNumber  = FlyDefaults.myMobileNumber
        profileData.email = FlyDefaults.myEmail
        profileData.status = FlyDefaults.myStatus
        profileData.image = FlyDefaults.myImageUrl
        
        FlyDatabaseController.shared.rosterManager.saveContact(profileDetailsArray: [profileData], chatType: .singleChat, contactType: .live, saveAsTemp: false, calledBy: "")
    }
    
    static func getMediaEndPoint(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let urlString = FlyDefaults.baseURL + "" + "media" + "/"
        result(urlString)
        
    }
    
    static func syncContacts(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        
        
    }
    static func updateMyProfileImage(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let profileImage = args["image"] as? String ?? ""
       
        ContactManager.shared.updateMyProfileImage(image: profileImage){ isSuccess, flyError, flyData in
                if isSuccess {
                    
                    var data = flyData
                    
                    let profileData = data.getData()
                    let message = data.getMessage()
                    print("profile Image update response-->\(profileData)")

                    let profileDataJson = JSONSerializer.toJson(profileData)


                    var profileResponseJson = "{\"status\": true ,\"message\" : \"\(message)\" ,\"data\": \(profileDataJson) }"

                    result(profileResponseJson)
                    
                } else{
                    result(FlutterError(code: "500", message: flyError!.localizedDescription, details: nil))
                }
        }
        
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
        let profileStatus = ChatManager.shared.getMyBusyStatus()
        result(JSONSerializer.toJson(profileStatus))
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
        

        result(FlyDatabaseController.shared.userBusyStatusManager.saveStatus(busyStatus: BusyStatus(statusText: busyStatus)))
    }
    
    static func getBusyStatusList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let busyStatusList = ChatManager.shared.getBusyStatusList()
        print("Get Status Started profileList Count \(busyStatusList.count)")
        var busyStatusJsonList = JSONSerializer.toJson(busyStatusList)
        result(busyStatusJsonList)
    }
    
    static func deleteBusyStatus(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let busyId = args["id"] as? String ?? ""
        let status = args["status"] as? String ?? ""
        let isCurrentStatus = args["isCurrentStatus"] as? Bool ?? false
                        
        let busyStatus = BusyStatus(statusText: status, isCurrentStatus: isCurrentStatus)
        
        print(busyStatus)
        
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
        
        ChatManager.deleteMessagesForEveryone(toJid: jid, messageIdList: messageIDList, deleteChatType: deleteChatType,isRevokeMediaAccess: isMediaDelete) { (isSuccess, error, data) in
            
            result(isSuccess)
            
        }
        
    }
    static func markAsRead(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? ""
        ChatManager.markConversationAsRead(for: [jid])
        result(true)
    }
    static func getMessagesOfJid(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["JID"] as? String ?? ""
        print(userJid)
        let messages : [ChatMessage] = FlyMessenger.getMessagesOf(jid: userJid)
              
        var userChatHistory = JSONSerializer.toJson(messages)
        
        userChatHistory = userChatHistory.replacingOccurrences(of: "{\"some\":", with: "")
        userChatHistory = userChatHistory.replacingOccurrences(of: "}}", with: "}")
        
        result(userChatHistory)
        
        
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
        
        var userJID = args["jid"] as? String ?? ""
        
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
        var groupJID = args["jid"] as? String ?? ""
        var userJID = args["userjid"] as? String ?? ""
        
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
    
    
    static func exportChatConversationToEmail(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJID = args["jid"] as? String ?? ""
//        let mailRecipients = args["mailRecipients"] as? [String] ?? []
        
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
            var data  = flyData
            
            if isSuccess {
                result(JSONSerializer.toJson(data.getData()))
            } else{
                result(FlutterError(code: "500", message: "Unable to Fetch Group List", details: flyError?.localizedDescription))
            }
        }
    }
    
    static func searchConversation(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let searchKey = args["searchKey"] as? String ?? ""
        let jidForSearch = args["jidForSearch"] as? String ?? ""
        let globalSearch = args["globalSearch"] as? Bool ?? true
        
        let searchedMessages : [SearchMessage] = ChatManager.shared.searchMessage(text: searchKey)
        
        var searchConversationResp = "["
        var index = 0;
        for message in searchedMessages{
            if(index != 0){
                searchConversationResp = searchConversationResp + ","
            }
            index = index + 1;
            var message : ChatMessage? = FlyMessenger.getMessageOfId(messageId: message.messageId)
            var messageJson = JSONSerializer.toJson(message as Any)
            messageJson = messageJson.replacingOccurrences(of: "{\"some\":", with: "")
            messageJson = messageJson.replacingOccurrences(of: "}}", with: "}")
            searchConversationResp = searchConversationResp + messageJson
        }
        
        searchConversationResp = searchConversationResp + "]"
       
        result(searchConversationResp)
    }
    
    static func isMuted(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJID = args["jid"] as? String ?? ""
        result(FlyCoreController.shared.isContactMuted(jid: userJID))
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
                  let sec = lastseenSeconds?.replacingOccurrences(of: "-", with: "")
                  result(sec)
              } else{
                  
                  result(FlutterError(code: "500", message: "Unable to Fetch User Last seen", details: data.getMessage()))
              }
          }
    }
    static func getRecentChatList(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        ChatManager.getRecentChatList { (isSuccess, flyError, resultDict) in
                  if (isSuccess) {
                      var recentlist = resultDict
                      let recentChatList = recentlist.getData() as? [RecentChat] ?? []
                    
                      if(recentChatList.isEmpty){
                          result("{\"data\": [] }")
                      }else{
                          let recentChatJson = JSONSerializer.toJson(recentChatList)
                          
                          print(recentChatJson)
                          
                          let recentChatListJson = "{\"data\":" + recentChatJson + "}"
                          
                          print(recentChatListJson)
                          result(recentChatListJson)
                      }
                   
                  } else {
                      
                      result(FlutterError(code: "500", message: "Unable to Fetch Recent Chat List", details: flyError?.localizedDescription))

                  }
            }
    }
   
    static func getRecentChatListIncludingArchived(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let recentChatList = ChatManager.getRecentChatListIncludingArchived()
        result(JSONSerializer.toJson(recentChatList))
    }
    static func getRecentChatOf(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let jid = args["jid"] as? String ?? nil
        print("getRecentChatOf jid --> \(jid)")
        let recentChat = ChatManager.getRecentChatOf(jid:jid!)
        print("recentChat-->\(recentChat)")
        if(recentChat == nil){
            result(nil)
        }
        
        var recentChatJson = JSONSerializer.toJson(recentChat as Any)
        recentChatJson = recentChatJson.replacingOccurrences(of: "{\"some\":", with: "")
        recentChatJson = recentChatJson.replacingOccurrences(of: "}}", with: "}")
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
        
        var reportMessageJson = JSONSerializer.toJson(reportMessage as Any)
        reportMessageJson = reportMessageJson.replacingOccurrences(of: "{\"some\":", with: "")
        reportMessageJson = reportMessageJson.replacingOccurrences(of: "}}", with: "}")
        
        result(reportMessageJson)
        
    }
    static func blockUser(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let userJid = args["userJID"] as? String ?? ""
        
        do{
            
            try ContactManager.shared.blockUser(for: userJid){ isSuccess, flyError, flyData in

                    if isSuccess {
                        var blockUserResponseJson = JSONSerializer.toJson(flyData as Any)
                        
                        blockUserResponseJson = blockUserResponseJson.replacingOccurrences(of: "{\"some\":", with: "")
                        blockUserResponseJson = blockUserResponseJson.replacingOccurrences(of: "}}", with: "}")
                        
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
            
            try GroupManager.shared.createGroup(groupName: groupName, participantJidList: members, groupImageFileUrl: file, completionHandler: { isSuccess, flyError, flyData in
                if isSuccess {
                    var createGroupResponseJson = JSONSerializer.toJson(flyData as Any)
                    
                    createGroupResponseJson = createGroupResponseJson.replacingOccurrences(of: "{\"some\":", with: "")
                    createGroupResponseJson = createGroupResponseJson.replacingOccurrences(of: "}}", with: "}")
                    
                    result(createGroupResponseJson)
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
                    let blockedProfileJson = JSONSerializer.toJson(blockedprofileDetailsArray as Any)
                    result(blockedProfileJson)
                } else{
                    result(FlutterError(code: "500", message: "Unable to Fetch Blocked List", details: flyError?.localizedDescription))
                }
        }
               
    }
    static func getMediaMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        
        ChatManager.getVedioImageAudioMessageGroupByMonth(jid: userJid) { isSuccess,error,data  in
            
            if isSuccess {
                var mediaData = data
                let chatMessages = mediaData.getData() as? [[ChatMessage]]
                
                if(chatMessages!.isEmpty){
                    result(nil)
                }else{
                    var mediaMsgJson = JSONSerializer.toJson(chatMessages as Any)
                    mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "{\"some\":", with: "")
                    mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "}}", with: "}")
                    mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "\"some\": [[", with: "[")
                    mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "]]", with: "]")
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
                    var mediaMsgJson = JSONSerializer.toJson(mediaMessages)
                    mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "{\"some\":", with: "")
                    mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "}}", with: "}")
                    mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "[[", with: "[")
                    mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "]]", with: "]")
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
                            var mediaMsgJson = JSONSerializer.toJson(linkChatMessage.chatMessage)
                            
                            mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "{\"some\":", with: "")
                            mediaMsgJson = mediaMsgJson.replacingOccurrences(of: "}}", with: "}")
                            
                            viewAllMediaLinkMessages = viewAllMediaLinkMessages + mediaMsgJson + ","
                            
                        }
                        
                    }
                    viewAllMediaLinkMessages = viewAllMediaLinkMessages.dropLast() + "]"
                    
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
        result(FlyDefaults.autoDownloadEnable)
    }
    
    static func setMediaAutoDownload(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let autoDownloadEnable = args["enable"] as? Bool ?? false
        FlyDefaults.autoDownloadEnable = autoDownloadEnable
        FlyDefaults.autoDownloadLastEnabledTime = autoDownloadEnable ? FlyUtils.getTimeInMillis() : 0
        result(true)
    }
    
    static func getMediaSetting(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let networkType = args["NetworkType"] as? Int ?? 0
        let type = args["type"] as? String ?? ""
        
        if (networkType == 0){
            switch (type) {
                case "Photos":
                    result(FlyDefaults.autoDownloadMobile["photo"] ?? false)
                case "Videos":
                    result(FlyDefaults.autoDownloadMobile["videos"] ?? false)
                case "Audio":
                    result(FlyDefaults.autoDownloadMobile["audio"] ?? false)
                case "Documents":
                    result(FlyDefaults.autoDownloadMobile["documents"] ?? false)
                default:
                    result(false)
                }
            
        }else{
            switch (type) {
                case "Photos":
                    result(FlyDefaults.autoDownloadWifi["photo"] ?? false)
                case "Videos":
                    result(FlyDefaults.autoDownloadWifi["videos"] ?? false)
                case "Audio":
                    result(FlyDefaults.autoDownloadWifi["audio"] ?? false)
                case "Documents":
                    result(FlyDefaults.autoDownloadWifi["documents"] ?? false)
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
        let isDocumentEnalbed = args["Documents"] as? Bool ?? false
        let networkType = args["NetworkType"] as? Int ?? 0
        
        var mobiledata = [String : Bool]()
        var wifi = [String : Bool]()
        
        if (networkType == 0){//cellular
            mobiledata["photo"] = isPhotoEnabled
            FlyDefaults.autoDownloadTimeMobileDataImage = isPhotoEnabled ? FlyUtils.getTimeInMillis() : 0

            mobiledata["videos"]  = isVideoEnabled
            FlyDefaults.autoDownloadTimeMobileDataVideo = isVideoEnabled ? FlyUtils.getTimeInMillis() : 0

            mobiledata["audio"] = isAudioEnabled
            FlyDefaults.autoDownloadTimeMobileDataAudio = isAudioEnabled ? FlyUtils.getTimeInMillis() : 0

            mobiledata["documents"] = isDocumentEnalbed
            FlyDefaults.autoDownloadTimeMobileDataDocument = isDocumentEnalbed ? FlyUtils.getTimeInMillis() : 0

            FlyDefaults.autoDownloadMobile = mobiledata
            
        }else{//WIFI
            wifi["photo"] = isPhotoEnabled
            FlyDefaults.autoDownloadTimeWifiImage = isPhotoEnabled ? FlyUtils.getTimeInMillis() : 0

            wifi["videos"] = isVideoEnabled
            FlyDefaults.autoDownloadTimeWifiVideo = isVideoEnabled ? FlyUtils.getTimeInMillis() : 0

            wifi["audio"] = isAudioEnabled
            FlyDefaults.autoDownloadTimeWifiAudio = isAudioEnabled ? FlyUtils.getTimeInMillis() : 0

            wifi["documents"] = isDocumentEnalbed
            FlyDefaults.autoDownloadTimeWifiDocument = isDocumentEnalbed ? FlyUtils.getTimeInMillis() : 0

            FlyDefaults.autoDownloadWifi = wifi
            
        }
    }
    
    static func updateArchiveUnArchiveChat(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        
        let userJid = args["jid"] as? String ?? ""
        let archive = args["isArchived"] as? Bool ?? false
        
        var userJidList = [] as [String]
        userJidList.append(userJid)
    
        if(archive){
            ChatManager.archiveChatConversation(jidsToArchive: userJidList)
        }else{
            ChatManager.unarchiveChatConversation(jidsToUnarchive: userJidList)
        }
    
       result(true)
               
    }
    static func logoutOfChatSDK(call: FlutterMethodCall, result: @escaping FlutterResult){

        ChatManager.logoutApi { isSuccess, flyError, flyData in
           if isSuccess {
               //        ChatManager.enableContactSync(isEnable: ENABLE_CONTACT_SYNC)
                       ChatManager.disconnect()
                       ChatManager.shared.resetFlyDefaults()
               result(isSuccess)
           }else{
               result(FlutterError(code: "500", message: "Unable to Logout", details: flyError?.localizedDescription))
           }
       }
    }
    
    static func getMessageOfId(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let messageId = args["mid"] as? String ?? ""
        
        var message : ChatMessage? = FlyMessenger.getMessageOfId(messageId: messageId)
        
        var messageJson = JSONSerializer.toJson(message as Any)
        messageJson = messageJson.replacingOccurrences(of: "{\"some\":", with: "")
        messageJson = messageJson.replacingOccurrences(of: "}}", with: "}")
        
        result(messageJson)
               
    }
    static func getArchivedChatList(call: FlutterMethodCall, result: @escaping FlutterResult){
        
        ChatManager.getArchivedChatList { (isSuccess, flyError, resultDict) in
           if isSuccess {
               var flydata = resultDict
               print(flydata.getData())
               
               let archiveData = flydata.getData() as? [RecentChat] ?? []
               print("Archive chat list get")
               if(archiveData.isEmpty){
                   result("{\"data\": [] }")
               }else{
                   
                   let archiveChatJson = JSONSerializer.toJson(flydata.getData())
                   
                   let archiveChatListJson = "{\"data\":" + archiveChatJson + "}"
                   
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
        let userProfile = ChatManager.profileDetaisFor(jid: userJid)
        print("getProfileDetails --> \(userProfile)")
        var userProfileJson = JSONSerializer.toJson(userProfile as Any)
        userProfileJson = userProfileJson.replacingOccurrences(of: "{\"some\":", with: "")
        userProfileJson = userProfileJson.replacingOccurrences(of: "}}", with: "}")
        result(userProfileJson)

    }
    static func deleteAccount(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let deleteReason = args["delete_reason"] as? String ?? ""
        let deleteFeedback = args["delete_feedback"] as? String ?? ""
        ContactManager.shared.deleteMyAccountRequest(reason: deleteReason, feedback: deleteFeedback) { isSuccess, flyError, flyData in
           var data  = flyData
           print(data.getMessage() as! String )
           if isSuccess {
               var deleteResponseJson = JSONSerializer.toJson(data)
                deleteResponseJson = deleteResponseJson.replacingOccurrences(of: "{\"some\":", with: "")
                deleteResponseJson = deleteResponseJson.replacingOccurrences(of: "}}", with: "}")
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
        var groupMessageDeliveredList = GroupManager.shared.getMessageDeliveredListBy(messageId: messageId, groupId: jid)
        print("groupMessageDeliveredList=>\(groupMessageDeliveredList)")
        var groupMessageDeliveredListJson = JSONSerializer.toJson(groupMessageDeliveredList)
        print("groupMessageDeliveredListJson=>\(groupMessageDeliveredListJson)")
        groupMessageDeliveredListJson = groupMessageDeliveredListJson.replacingOccurrences(of: "{\"some\":", with: "")
        groupMessageDeliveredListJson = groupMessageDeliveredListJson.replacingOccurrences(of: "}}", with: "}")
        groupMessageDeliveredListJson = groupMessageDeliveredListJson.replacingOccurrences(of: "{}", with: "")
        print("groupMessageDeliveredList\(groupMessageDeliveredListJson)")
        result(groupMessageDeliveredListJson)
    }
    
    static func getGroupMessageReadByList(call: FlutterMethodCall, result: @escaping FlutterResult){
        let args = call.arguments as! Dictionary<String, Any>
        let messageId = args["messageId"] as? String ?? ""
        let jid = args["jid"] as? String ?? ""
        
        var groupMessageReadList = GroupManager.shared.getMessageSeenListBy(messageId: messageId, groupId: jid)
        print("groupMessageReadList=> \(groupMessageReadList)")
        var groupMessageReadListJson = JSONSerializer.toJson(groupMessageReadList)
        print("groupMessageReadListJson=>\(groupMessageReadListJson)")
        groupMessageReadListJson = groupMessageReadListJson.replacingOccurrences(of: "{\"some\":", with: "")
        groupMessageReadListJson = groupMessageReadListJson.replacingOccurrences(of: "}}", with: "}")
        groupMessageReadListJson = groupMessageReadListJson.replacingOccurrences(of: "{}", with: "")
        print("groupMessageReadList\(groupMessageReadListJson)")
        result(groupMessageReadListJson)

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
}

