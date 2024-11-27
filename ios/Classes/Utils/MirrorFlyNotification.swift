//
//  MirrorFlyNotification.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 02/08/23.
//

import Foundation
import MirrorFlySDK
//import UserNotifications


@objc public class MirrorFlyNotification : NSObject {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    @objc public func handleNotification(notificationRequest : UNNotificationRequest, contentHandler : @escaping (UNNotificationContent) -> Void, containerID: String, licenseKey: String) {
        self.contentHandler = contentHandler
        bestAttemptContent = (notificationRequest.content.mutableCopy() as? UNMutableNotificationContent)
        NSLog("#Mirrorfly Notification Received")
        NSLog("#Mirrorfly Received data3 \(String(describing: bestAttemptContent?.userInfo))")
        let payloadType = bestAttemptContent?.userInfo["type"] as? String


        NSLog("#Mirrorfly licenseKey1 \(licenseKey)")
        NSLog("#Mirrorfly containerID1 \(containerID)")
        
        ChatManager.setAppGroupContainerId(id: containerID)
//        ChatManager.initializeSDK(licenseKey: licenseKey) { _, _, _ in }
        ChatManager.initializeSDK(licenseKey: licenseKey) { isSuccess, flyError, flyData in
            if isSuccess {
                NSLog("#Mirrorfly Notification : initializeSDK Success")
            }else{
                NSLog("#Mirrorfly Notification : initializeSDK Failed -> \(flyError?.localizedDescription)")
            }
        }
        

        print("#push-api withContentHandler received")
        
        
//        NSLog("#Mirrorfly flydefaluts containerID \(FlyDefaults.appGroupContainerID)")
        
        if payloadType == "adminblock" {
            NSLog("#Mirrorfly Admin Block")
            ChatSDK.Builder.initializeDelegate()
            NotificationMessageSupport.shared.handleAdminBlockNotification(notificationRequest.content.mutableCopy() as? UNMutableNotificationContent) {  bestAttemptContent, chatMessage  in
                contentHandler(bestAttemptContent!)
//                return bestAttemptContent
//                self.bestAttemptContent = bestAttemptContent
            }
//            return self.bestAttemptContent
        } else {
            NSLog("#Mirrorfly Handle Push")

            /// Handle Push messages
            ChatSDK.Builder.initializeDelegate()
            NotificationMessageSupport.shared.didReceiveNotificationRequest(notificationRequest.content.mutableCopy() as? UNMutableNotificationContent, appName: APP_NAME, onCompletion: { [self] bestAttemptContents, chatMessage in
//                FlyLog.DLog(param1: "#notification request ID", param2: "\(request.identifier)")
                _ = UNUserNotificationCenter.current()
                let (messageCount, chatCount) = ChatManager.getUnreadMessageAndChatCountForUnmutedUsers()
                if isHideNotificationContent{
                    var titleContent = emptyString()
                    if chatCount == 1{
                        titleContent = "\(messageCount) \(messageCount == 1 ? "message" : "messages")"
                    } else {
                        titleContent = "\(messageCount) messages from \(chatCount) chats"
                    }
                    bestAttemptContents?.title = APP_NAME + " (\(titleContent))"
                    bestAttemptContents?.body = "New Message"
                } else {
                    if let userInfo = bestAttemptContents?.userInfo["message_id"] {
                        print("Push Show title: \(bestAttemptContents?.title ?? "") body: \(bestAttemptContents?.body ?? ""), ID - \(userInfo)")
                        FlyLog.DLog(param1: "NotificationMessageSupport id ", param2: "\(bestAttemptContents?.title ?? "") body: \(bestAttemptContents?.body ?? "")")
                    }
                }
                var canVibrate = true
                let isMuted = ContactManager.shared.getUserProfileDetails(for: bestAttemptContents?.userInfo["from_user"] as? String ?? "")?.isMuted ?? false
                if !isMuted || !(ChatManager.isArchivedSettingsEnabled() && ChatManager.getRechtChat(jid: bestAttemptContents?.userInfo["from_user"] as? String ?? "")?.isChatArchived ?? false){
                    bestAttemptContents?.badge = messageCount as? NSNumber
                }

                let chatType = (bestAttemptContents?.userInfo["chat_type"] as? String ?? "")
                let messageId = (self.bestAttemptContent?.userInfo["message_id"] as? String ?? "").components(separatedBy: ",").last ?? ""

                self.bestAttemptContent = bestAttemptContents

                guard let myJid = try? FlyUtils.getMyJid() else {
                    return
                }

                if ChatManager.getMessageOfId(messageId: messageId)?.senderUserJid == myJid && (chatType == "chat" || chatType == "normal") {
                    if !FlyUtils.isValidGroupJid(groupJid: ChatManager.getMessageOfId(messageId: messageId)?.chatUserJid) {
                        self.bestAttemptContent?.title = "You"
                    }
                    canVibrate = false
                    self.bestAttemptContent?.sound = .none
                } else if ChatManager.getMessageOfId(messageId: messageId)?.senderUserJid != myJid {
                    if isMuted || (ChatManager.isArchivedSettingsEnabled() && ChatManager.getRechtChat(jid: bestAttemptContents?.userInfo["from_user"] as? String ?? "")?.isChatArchived ?? false) {
                        self.bestAttemptContent?.sound = .none
                        canVibrate = false
                    } else if !(CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("Default") ?? false) && !(CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false) && CommonDefaults.notificationSoundEnable  {
                        self.bestAttemptContent?.sound = UNNotificationSound(named: UNNotificationSoundName((CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.file.rawValue] ?? "") + "." + (CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.extensions.rawValue] ?? "")))
                    } else if CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("Default") ?? false && CommonDefaults.notificationSoundEnable {
                        self.bestAttemptContent?.sound = .default
                    } else if CommonDefaults.notificationSoundEnable == false || CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false {
                        self.bestAttemptContent?.sound = CommonDefaults.vibrationEnable ? UNNotificationSound(named: UNNotificationSoundName(rawValue: "1-second-of-silence.mp3"))  : nil
                    }
                } else if self.bestAttemptContent?.userInfo["sent_from"] as? String ?? "" == myJid && self.bestAttemptContent?.userInfo["group_id"] != nil {
                    self.bestAttemptContent?.sound = nil
                    canVibrate = false
                } else if self.bestAttemptContent?.userInfo["sent_from"] as? String ?? "" != myJid && self.bestAttemptContent?.userInfo["group_id"] != nil {
                    if !(CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("Default") ?? false) && !(CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false) && CommonDefaults.notificationSoundEnable  {
                        self.bestAttemptContent?.sound = UNNotificationSound(named: UNNotificationSoundName((CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.file.rawValue] ?? "") + "." + (CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.extensions.rawValue] ?? "")))
                    } else if CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("Default") ?? false && CommonDefaults.notificationSoundEnable {
                        self.bestAttemptContent?.sound = .default
                    } else if CommonDefaults.notificationSoundEnable == false || CommonDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false {
                        self.bestAttemptContent?.sound = CommonDefaults.vibrationEnable ? UNNotificationSound(named: UNNotificationSoundName(rawValue: "1-second-of-silence.mp3"))  : nil
                    }
                }
                if let message = ChatManager.getMessageOfId(messageId: messageId), !message.mentionedUsersIds.isEmpty {
                    self.bestAttemptContent?.body = NotificationUtils.convertMentionUser(message: message.messageTextContent, mentionedUsersIds: message.mentionedUsersIds)
                }
                contentHandler(self.bestAttemptContent!)
//                FlyDefaults.lastNotificationId = request.identifier
            })
//            return self.bestAttemptContent
        }
    }
    
   
    
    @objc public func handleReceivedMessage(notificationRequest : UNNotificationRequest, containerID: String, licenseKey: String,completion : @escaping (UNMutableNotificationContent?, MirrorFlySDK.ChatMessage?) -> Void) {
        let bestAttemptContent = (notificationRequest.content.mutableCopy() as? UNMutableNotificationContent)
        NSLog("#Mirrorfly Notification Received")
        NSLog("#Mirrorfly Received data3 \(String(describing: bestAttemptContent?.userInfo))")
        let payloadType = bestAttemptContent?.userInfo["type"] as? String


        NSLog("#Mirrorfly licenseKey1 \(licenseKey)")
        NSLog("#Mirrorfly containerID1 \(containerID)")
        
        ChatManager.setAppGroupContainerId(id: containerID)
        ChatManager.initializeSDK(licenseKey: licenseKey) { isSuccess, flyError, flyData in
            if isSuccess {
                NSLog("#Mirrorfly Notification : initializeSDK Success")
            }else{
                NSLog("#Mirrorfly Notification : initializeSDK Failed -> \(flyError?.localizedDescription)")
            }
        }
        

        print("#push-api withContentHandler received")
        if payloadType == "adminblock" {
            NSLog("#Mirrorfly Admin Block")
            ChatSDK.Builder.initializeDelegate()
            NotificationMessageSupport.shared.handleAdminBlockNotification(notificationRequest.content.mutableCopy() as? UNMutableNotificationContent) {  bestAttemptContent, chatMessage  in
                completion(bestAttemptContent,chatMessage)
            }
        } else {
            NSLog("#Mirrorfly Handle Push")
            ChatSDK.Builder.initializeDelegate()
            NotificationMessageSupport.shared.didReceiveNotificationRequest(notificationRequest.content.mutableCopy() as? UNMutableNotificationContent, appName: APP_NAME, onCompletion: { bestAttemptContents, chatMessage in
                completion(bestAttemptContents,chatMessage)
            })
        }
    }
    
}

extension String {
    func replacing(_ withString: String, range: NSRange) -> String {
        if let textRange = self.rangeFromNSRange(range) {
            return self.replacingCharacters(in: textRange, with: withString)
        }
        
        return self
    }
    func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    func substringFromNSRange(_ nsRange : NSRange) -> String {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return self }
        return String(self[from..<to])
    }
}

public class NotificationUtils {
    public static func getUnreadMessageAndChatCountForUnmutedUsers() -> (Int, Int){
        return ChatManager.getUnreadMessageAndChatCountForUnmutedUsers()
    }
    
    public static func isUserMuted( jid: String)->Bool{
        let isMuted = ContactManager.shared.getUserProfileDetails(for:jid)?.isMuted ?? false
        return isMuted
    }
    
    public static func isArchivedSettingsEnabled()-> Bool{
        return ChatManager.isArchivedSettingsEnabled()
    }
    
    public static func isChatArchived(jid:String)-> Bool{
        return ChatManager.getRechtChat(jid: jid)?.isChatArchived ?? false
    }
    
    public static func isValidGroupJid(groupJid:String)-> Bool{
        return FlyUtils.isValidGroupJid(groupJid: groupJid)
    }
    
    public static func getMessageofId(messageId: String ) -> MirrorFlySDK.ChatMessage? {
        let message = ChatManager.getMessageOfId(messageId: messageId)
        return message
    }
    
    public static func getMyJid() throws -> String{
        return try FlyUtils.getMyJid()
    }
    
    public static func getUserProfileDetails(jid:String)-> MirrorFlySDK.ProfileDetails?{
        let profileDetail = ContactManager.shared.getUserProfileDetails(for: jid)
        return profileDetail
    }
    
    public static func convertMentionUser(message: String, mentionedUsersIds: [String]) -> String {
        var replyMessage = message

        for user in mentionedUsersIds {
            guard let JID = try? FlyUtils.getJid(from: user) else { return message }
//            let myJID = try? FlyUtils.getMyJid()
            if let profileDetail = ContactManager.shared.getUserProfileDetails(for: JID) {
                let userName = "@\(FlyUtils.getGroupUserName(profile: profileDetail))"
                let mentionRange = (replyMessage as NSString).range(of: "@[?]")
                replyMessage = replyMessage.replacing(userName, range: mentionRange)
            }
        }
        return replyMessage
    }
}
