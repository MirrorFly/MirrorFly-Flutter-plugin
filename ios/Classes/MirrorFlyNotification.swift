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
    
    @objc public func handleNotification(notificationRequest : UNNotificationRequest, contentHandler : @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (notificationRequest.content.mutableCopy() as? UNMutableNotificationContent)
        NSLog("#Mirrorfly Notification Received")
        NSLog("#Mirrorfly Received data3 \(String(describing: bestAttemptContent?.userInfo))")
        let payloadType = bestAttemptContent?.userInfo["type"] as? String

        
        let licenseKey = Utility.getStringFromPreference(key: Constants.licenseKey)
        let containerID = Utility.getStringFromPreference(key: Constants.containerID)

        NSLog("#Mirrorfly licenseKey1 \(licenseKey)")
        NSLog("#Mirrorfly containerID1 \(containerID)")
        

//        try? ChatSDK.Builder.setAppGroupContainerID(containerID: "group.com.mirrorfly.qa")
//            .isTrialLicense(isTrial: true)
//            .setLicenseKey(key: "ckIjaccWBoMNvxdbql8LJ2dmKqT5bp")
//            .setDomainBaseUrl(baseUrl: "https://api-uikit-qa.contus.us/api/v1/")
//            .buildAndInitialize()
        
        ChatManager.setAppGroupContainerId(id: "group.com.mirrorfly.qa")
        ChatManager.initializeSDK(licenseKey: "ckIjaccWBoMNvxdbql8LJ2dmKqT5bp") { _, _, _ in }
        
        print("#push-api withContentHandler received")
        
        
        NSLog("#Mirrorfly flydefaluts containerID \(FlyDefaults.appGroupContainerID)")
        
        if payloadType == "adminblock" {
            NSLog("#Mirrorfly Admin Block")
            ChatSDK.Builder.initializeDelegate()
            NotificationMessageSupport.shared.handleAdminBlockNotification(notificationRequest.content.mutableCopy() as? UNMutableNotificationContent) {  bestAttemptContent in
                contentHandler(bestAttemptContent!)
//                return bestAttemptContent
//                self.bestAttemptContent = bestAttemptContent
            }
//            return self.bestAttemptContent
        } else {
            NSLog("#Mirrorfly Handle Push")

            /// Handle Push messages
            ChatSDK.Builder.initializeDelegate()
            NotificationMessageSupport.shared.didReceiveNotificationRequest(notificationRequest.content.mutableCopy() as? UNMutableNotificationContent, onCompletion: { [self] bestAttemptContents in
//                FlyLog.DLog(param1: "#notification request ID", param2: "\(request.identifier)")
                let center = UNUserNotificationCenter.current()
                let (messageCount, chatCount) = ChatManager.getUnreadMessageAndChatCountForUnmutedUsers()
                if FlyDefaults.hideNotificationContent{
                    var titleContent = emptyString()
                    if chatCount == 1{
                        titleContent = "\(messageCount) \(messageCount == 1 ? "message" : "messages")"
                    } else {
                        titleContent = "\(messageCount) messages from \(chatCount) chats"
                    }
                    bestAttemptContents?.title = FlyDefaults.appName + " (\(titleContent))"
                    bestAttemptContents?.body = "New Message"
                } else {
                    if let userInfo = bestAttemptContents?.userInfo["message_id"] {
                        print("Push Show title: \(bestAttemptContents?.title ?? "") body: \(bestAttemptContents?.body ?? ""), ID - \(userInfo)")
                        FlyLog.DLog(param1: "NotificationMessageSupport id ", param2: "\(bestAttemptContents?.title ?? "") body: \(bestAttemptContents?.body ?? "")")
                    }
                }
                var canVibrate = true
                let isMuted = ContactManager.shared.getUserProfileDetails(for: bestAttemptContents?.userInfo["from_user"] as? String ?? "")?.isMuted ?? false
                if !isMuted || !(FlyDefaults.isArchivedChatEnabled && ChatManager.getRechtChat(jid: bestAttemptContents?.userInfo["from_user"] as? String ?? "")?.isChatArchived ?? false){
                    bestAttemptContents?.badge = messageCount as? NSNumber
                }

                let chatType = (bestAttemptContents?.userInfo["chat_type"] as? String ?? "")
                let messageId = (self.bestAttemptContent?.userInfo["message_id"] as? String ?? "").components(separatedBy: ",").last ?? ""

                self.bestAttemptContent = bestAttemptContents

                if ChatManager.getMessageOfId(messageId: messageId)?.senderUserJid == FlyDefaults.myJid && (chatType == "chat" || chatType == "normal") {
                    if !FlyUtils.isValidGroupJid(groupJid: ChatManager.getMessageOfId(messageId: messageId)?.chatUserJid) {
                        self.bestAttemptContent?.title = "You"
                    }
                    canVibrate = false
                    self.bestAttemptContent?.sound = .none
                } else if ChatManager.getMessageOfId(messageId: messageId)?.senderUserJid != FlyDefaults.myJid {
                    if isMuted || (FlyDefaults.isArchivedChatEnabled && ChatManager.getRechtChat(jid: bestAttemptContents?.userInfo["from_user"] as? String ?? "")?.isChatArchived ?? false) {
                        self.bestAttemptContent?.sound = .none
                        canVibrate = false
                    } else if !(FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("Default") ?? false) && !(FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false) && FlyDefaults.notificationSoundEnable  {
                        self.bestAttemptContent?.sound = UNNotificationSound(named: UNNotificationSoundName((FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.file.rawValue] ?? "") + "." + (FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.extensions.rawValue] ?? "")))
                    } else if FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("Default") ?? false && FlyDefaults.notificationSoundEnable {
                        self.bestAttemptContent?.sound = .default
                    } else if FlyDefaults.notificationSoundEnable == false || FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false {
                        self.bestAttemptContent?.sound = FlyDefaults.vibrationEnable ? UNNotificationSound(named: UNNotificationSoundName(rawValue: "1-second-of-silence.mp3"))  : nil
                    }
                } else if self.bestAttemptContent?.userInfo["sent_from"] as? String ?? "" == FlyDefaults.myJid && self.bestAttemptContent?.userInfo["group_id"] != nil {
                    self.bestAttemptContent?.sound = nil
                    canVibrate = false
                } else if self.bestAttemptContent?.userInfo["sent_from"] as? String ?? "" != FlyDefaults.myJid && self.bestAttemptContent?.userInfo["group_id"] != nil {
                    if !(FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("Default") ?? false) && !(FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false) && FlyDefaults.notificationSoundEnable  {
                        self.bestAttemptContent?.sound = UNNotificationSound(named: UNNotificationSoundName((FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.file.rawValue] ?? "") + "." + (FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.extensions.rawValue] ?? "")))
                    } else if FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("Default") ?? false && FlyDefaults.notificationSoundEnable {
                        self.bestAttemptContent?.sound = .default
                    } else if FlyDefaults.notificationSoundEnable == false || FlyDefaults.selectedNotificationSoundName[NotificationSoundKeys.name.rawValue]?.contains("None") ?? false {
                        self.bestAttemptContent?.sound = FlyDefaults.vibrationEnable ? UNNotificationSound(named: UNNotificationSoundName(rawValue: "1-second-of-silence.mp3"))  : nil
                    }
                }
                if let message = ChatManager.getMessageOfId(messageId: messageId), !message.mentionedUsersIds.isEmpty {
                    self.bestAttemptContent?.body = convertMentionUser(message: message.messageTextContent, mentionedUsersIds: message.mentionedUsersIds)
                }
                contentHandler(self.bestAttemptContent!)
//                FlyDefaults.lastNotificationId = request.identifier
            })
//            return self.bestAttemptContent
        }
    }
    
    func convertMentionUser(message: String, mentionedUsersIds: [String]) -> String {
        var replyMessage = message

        for user in mentionedUsersIds {
            let JID = user + "@" + FlyDefaults.xmppDomain
            let myJID = try? FlyUtils.getMyJid()
            if let profileDetail = ContactManager.shared.getUserProfileDetails(for: JID) {
                let userName = "@\(FlyUtils.getGroupUserName(profile: profileDetail))"
                let mentionRange = (replyMessage as NSString).range(of: "@[?]")
                replyMessage = replyMessage.replacing(userName, range: mentionRange)
            }
        }
        return replyMessage
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

