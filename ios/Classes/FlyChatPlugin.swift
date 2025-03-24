import Flutter
import ContactsUI
import Contacts
import UIKit
import MirrorFlySDK


let APP_NAME = "MirrorFly Flutter"
let isHideNotificationContent = false

public class FlyChatPlugin: NSObject, FlutterPlugin, CNContactViewControllerDelegate {
    
    
    private var chatEventInitializer: FlyChatEventChannelInitializer = FlyChatEventChannelInitializer.shared
    
    var flyChatUserDelegate : FlyChatUserDelegate? = nil
    
    var isContactSyncInProgress : Bool = false;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: Constants.mirrorflyMethodChannel, binaryMessenger: registrar.messenger())
        
        let instance = FlyChatPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.setupEventChannel(registrar: registrar)
        
        FlyCall.register(with: registrar)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if ChatManager.isChatServerConnected() {
            prepareMethodHandler(methodCall: call, result: result)
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                print("Chat Server not connected, so delaying the method call")
                self.prepareMethodHandler(methodCall: call, result: result)
            }
        }
    }
    
    
    private func setupEventChannel(registrar: FlutterPluginRegistrar){
        
        chatEventInitializer.initializeChatEventChannels(registrar: registrar)
        
    }
    func contactSyncStateValue(call: FlutterMethodCall, result: @escaping FlutterResult){
     
        print("contactSyncStateValue\(isContactSyncInProgress)")
        result(isContactSyncInProgress)
    }
    
    func initializeEventListeners(){
        ChatManager.shared.logoutDelegate = self
        FlyMessenger.shared.messageEventsDelegate = self
        ChatManager.shared.messageEventsDelegate = self
        GroupManager.shared.groupDelegate = self
        ChatManager.shared.connectionDelegate = self
        ChatManager.shared.adminBlockCurrentUserDelegate = self
        ChatManager.shared.typingStatusDelegate = self
        
        ContactManager.shared.profileDelegate = self
        ChatManager.shared.adminBlockDelegate = self
        ChatManager.shared.availableFeaturesDelegate = self
        BackupManager.shared.backupDelegate = self
        BackupManager.shared.restoreDelegate = self
        ChatManager.shared.localNotificationDelegate = self

        ChatManager.shared.muteEventDelegate = self
        WebLoginsManager.shared.webLogoutDelegate = self
        ChatManager.shared.archiveEventsDelegate = self
    }
    
    func prepareMethodHandler(methodCall: FlutterMethodCall, result: @escaping FlutterResult){
        
        if methodCall.method == "syncContacts"{
            let args = methodCall.arguments as! Dictionary<String, Any>
            
            _ = args["is_first_time"] as? Bool ?? false
            
            ChatManager.enableContactSync(isEnable: true)
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(FlyConstants.contactSyncState), object: nil, queue: nil) { notification in
                if let contactSyncState = notification.userInfo?[FlyConstants.contactSyncState] as? String {
                    switch ContactSyncState(rawValue: contactSyncState) {
                    case .inprogress:
                        print("==>contact sync inprogress")
                        self.isContactSyncInProgress = true
                        break
                    case .success:
                        print("==>contact sync Success")
                        self.isContactSyncInProgress = false
                    case .failed:
                        self.isContactSyncInProgress = false
                        print("==>contact sync failed")
                    case .none:
                        self.isContactSyncInProgress = false
                        print("==>contact sync failed")
                    case .some(_):
                        break
                    }
                }
                
            }
            //addObserver(self, selector: #selector(contactSyncCompleted), name: NSNotification.Name(FlyConstants.contactSyncState), object: nil)
            
            ContactSyncManager.shared.syncContacts(){ isSuccess, flyError, flyData in
                var data  = flyData
                print("contact sync\(data)")
                print("contact sync isSuccess\(isSuccess)")
                if isSuccess {
                    ContactManager.shared.getRegisteredUsers(fromServer: true) {  isSuccess, flyError, flyData in
                        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onContactSyncComplete_channel, value: true)
                    }
                    result(true)
                } else{
                    print(data.getMessage() as! String)
                    result(false)
                }
            }
        }else if methodCall.method == "contactSyncStateValue"{
            contactSyncStateValue(call: methodCall, result: result)
        }else if methodCall.method == "isLockScreen"{
            return result(UIScreen.main.brightness == 0.0)
        } else{
            
            if methodCall.method == "init" || methodCall.method == "initializeSDK"{
                           NSLog("\(Constants.tag) Method call initializeEventListeners")
                           print("Method call initializeEventListeners")
                           let args = methodCall.arguments as! Dictionary<String, Any>
                           let containerID = args["iOSContainerID"] as? String ?? ""
                           ChatManager.setAppGroupContainerId(id: containerID)

                           self.initializeEventListeners()

                       }

            if let methodHandler = FlyMethodConstants.chatMethodHandlers[methodCall.method] {
                NSLog("\(Constants.tag) Method call \(methodCall.method)")
                methodHandler(methodCall, result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

extension FlyChatPlugin : AvailableFeaturesDelegate {

    public func didUpdateAvailableFeatures(features: MirrorFlySDK.AvailableFeaturesModel) {

        print("didUpdateAvailableFeatures event \(features)")
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.getAvailableFeatures_channel, value: features.toJson())
  
    }

}

extension FlyChatPlugin : LocalNotificationDelegate {
    
    public func showOrUpdateOrCancelNotification(jid: String, chatMessage: MirrorFlySDK.ChatMessage, groupId: String) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        jsonObject.setValue(chatMessage.toJson(), forKey: "chatMessage")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.showUpdateCancelNotificationChannel, value: jsonString)
        
    }
    
}

extension FlyChatPlugin : BackupEventDelegate, RestoreEventDelegate {

    public func backupProgressDidReceive(completedCount: String, completedSize: String) {

        print("backupProgressDidReceive completedCount : \(completedCount) === completedSize: \(completedSize)")
//        let jsonObject: NSMutableDictionary = NSMutableDictionary()
//        jsonObject.setValue(completedCount, forKey: "completedCount")
//        jsonObject.setValue(completedSize, forKey: "completedSize")
//
//        let jsonString = pluginDictToJson(dictionary: jsonObject)

        if let doubleValue = Double(completedCount) {
            // Convert the Double to an Int (truncates the decimal part)
            let intValue = Int(doubleValue)
            print(intValue)
            self.chatEventInitializer.updateSinkValue(forChannel: Constants.onBackupProgressChangedChannel, value: intValue)
        } else {
            print("Invalid number")
        }

    }

    public func backupDidFinish(fileUrl: String) {

        print("backupDidFinish FileUrl: \(fileUrl)")

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onBackupSuccessChannel, value: fileUrl)
    }

    public func backupDidFailed(errorMessage: String) {

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onBackupFailureChannel, value: errorMessage)
    }

    public func restoreProgressDidReceive(completedCount: Double, completedPercentage: String, completedSize: String) {
        print("restoreProgressDidReceive completedCount : \(completedCount) === completedPercentage: \(completedPercentage) === completedSize: \(completedSize)")
        if let restoreValueIndouble = Double(completedPercentage) {
            // Convert the Double to an Int (truncates the decimal part)
            let restoreValueInInt = Int(restoreValueIndouble)
            self.chatEventInitializer.updateSinkValue(forChannel: Constants.onRestoreProgressChangedChannel, value: restoreValueInInt)
        }else {
            print("Invalid number")
        }


    }

    public func restoreDidFinish() {
        print("restoreDidFinish")
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onRestoreSuccessChannel, value: true)
    }

    public func restoreDidFailed(errorMessage: String) {

        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(errorMessage, forKey: "errorMessage")
        let jsonString = pluginDictToJson(dictionary: jsonObject)

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onRestoreFailureChannel, value: jsonString)
    }

}

extension FlyChatPlugin : MessageEventsDelegate, ConnectionEventDelegate, LogoutDelegate, GroupEventsDelegate,AdminBlockCurrentUserDelegate, TypingStatusDelegate, ProfileEventsDelegate,AdminBlockDelegate{
    public func onMessageEdited(message: MirrorFlySDK.ChatMessage) {
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMessageEdited_channel, value: message.toJson())
    }

    public func didRevokedAdminAccess(groupJid: String, revokedAdminMemberJid: String, revokedByMemberJid: String) {
        NSLog("GroupEventsDelegate didRevokedAdminAccess Delegate Triggered")
    }
    
    public func onMediaStatusFailed(error: String, messageId: String, errorCode: Int) {
        let chatMessage = ChatManager.getMessageOfId(messageId: messageId)
        
        let chatMediaJson = chatMessage?.toJson()
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMediaStatusUpdatedChannel, value: chatMediaJson)
        
    }
    
    public func onConnectionFailed(error: MirrorFlySDK.FlyError) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userJid, forKey: "jid")
        jsonObject.setValue("chat", forKey: "type")
        jsonObject.setValue(isBlocked, forKey: "status")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onAdminBlockedOtherUser_channel, value: jsonString)
        
    }
    
    public func didBlockOrUnblockSelf(userJid: String, isBlocked: Bool) {
        
    }
    
    public func didBlockOrUnblockGroup(groupJid: String, isBlocked: Bool) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "jid")
        jsonObject.setValue("groupchat", forKey: "type")
        jsonObject.setValue(isBlocked, forKey: "status")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onAdminBlockedOtherUser_channel, value: jsonString)
    }
    
}

extension FlyChatPlugin : ProfileEventsDelegate {
    public func userCameOnline(for jid: String) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.userCameOnline_channel, value: jsonString)
        
    }
    
    public func userWentOffline(for jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.userWentOffline_channel, value: jsonString)

    }
    
    public func userProfileFetched(for jid: String, profileDetails: MirrorFlySDK.ProfileDetails?) {
        print("userProfileFetched for jid")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        jsonObject.setValue(profileDetails?.toJson(), forKey: "profileDetails")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.userProfileFetched_channel, value: jsonString)

    }
    
    public func myProfileUpdated() {
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.myProfileUpdated_channel, value: true)

    }
    
    public func usersProfilesFetched() {
        print("userProfileFetched")
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.usersProfilesFetched_channel, value: true)

    }
    
    public func blockedThisUser(jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.blockedThisUser_channel, value: jsonString)

    }
    
    public func unblockedThisUser(jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.unblockedThisUser_channel, value: jsonString)

    }
    
    public  func usersIBlockedListFetched(jidList: [String]) {
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.usersIBlockedListFetched_channel, value: jidList.toJson())
        
    }
    
    public func usersBlockedMeListFetched(jidList: [String]) {
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.usersWhoBlockedMeListFetched_channel, value: jidList.toJson())

    }
    
    public func userUpdatedTheirProfile(for jid: String, profileDetails: MirrorFlySDK.ProfileDetails) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.userUpdatedHisProfile_channel, value: jsonString)
        
        flyChatUserDelegate?.userProfileDidChange(for: jid, profileDetails: profileDetails)
        
    }
    
    public func userBlockedMe(jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.userBlockedMe_channel, value: jsonString)

    }
    
    public func userUnBlockedMe(jid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.userUnBlockedMe_channel, value: jsonString)
        
    }
    
    public func hideUserLastSeen() {
        
    }
    
    public func getUserLastSeen() {
        
    }
    
    public func userDeletedTheirProfile(for jid: String, profileDetails: MirrorFlySDK.ProfileDetails) {
        print("userDeletedTheirProfile called jid --> \(jid)")
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(jid, forKey: "jid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.userDeletedHisProfile_channel, value: jsonString)
        
    }
}

extension FlyChatPlugin : TypingStatusDelegate {
    public func onChatTypingStatus(userJid: String, status: MirrorFlySDK.TypingStatus) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        
        
        jsonObject.setValue(userJid, forKey: "singleOrgroupJid")
        jsonObject.setValue(userJid, forKey: "userJid")
        jsonObject.setValue(status == TypingStatus.composing ? "composing" : "Gone", forKey: "status")
        
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.setTypingStatus_channel, value: jsonString)
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onChatTypingStatus_channel, value: jsonString)
        
    }
    
    public func onGroupTypingStatus(groupJid: String, groupUserJid: String, status: MirrorFlySDK.TypingStatus) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "singleOrgroupJid")
        jsonObject.setValue(groupUserJid, forKey: "userJid")
        jsonObject.setValue(status == TypingStatus.composing ? "composing" : "Gone", forKey: "status")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.setTypingStatus_channel, value: jsonString)
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onGroupTypingStatus_channel, value: jsonString)
        
    }
    

}

extension FlyChatPlugin : AdminBlockCurrentUserDelegate {
    public func didBlockOrUnblockCurrentUser(userJid: String, isBlocked: Bool) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(userJid, forKey: "jid")
        jsonObject.setValue(isBlocked, forKey: "status")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onAdminBlockedUser_channel, value: jsonString)
        
    }
}

extension FlyChatPlugin : GroupEventsDelegate {
    public func didAddNewMemeberToGroup(groupJid: String, newMemberJid: String, addedByMemberJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(newMemberJid, forKey: "newMemberJid")
        jsonObject.setValue(addedByMemberJid, forKey: "addedByMemberJid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onNewMemberAddedToGroup_channel, value: jsonString)
    }
    
    public func didRemoveMemberFromGroup(groupJid: String, removedMemberJid: String, removedByMemberJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(removedMemberJid, forKey: "removedMemberJid")
        jsonObject.setValue(removedByMemberJid, forKey: "removedByMemberJid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMemberRemovedFromGroup_channel, value: jsonString)
        
    }
    
    public func didFetchGroupProfile(groupJid: String) {
        print("didFetchGroupProfile")
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onGroupProfileFetched_channel, value: groupJid)
        
    }
    
    public func didUpdateGroupProfile(groupJid: String) {
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onGroupProfileUpdated_channel, value: groupJid)
        
    }
    
    public func didMakeMemberAsAdmin(groupJid: String, newAdminMemberJid: String, madeByMemberJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(newAdminMemberJid, forKey: "newAdminMemberJid")
        jsonObject.setValue(madeByMemberJid, forKey: "madeByMemberJid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMemberMadeAsAdmin_channel, value: jsonString)
        
    }
    
    public func didRevokedAdminAccess(groupJid: String, revokedAdminMemberJid: String, revokedByMemberJid: String) {
        NSLog("GroupEventsDelegate didRevokedAdminAccess Delegate Triggered")
    }
    
    public func didDeleteGroupLocally(groupJid: String) {
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onGroupDeletedLocally_channel, value: groupJid)
    }
    
    public func didLeftFromGroup(groupJid: String, leftUserJid: String) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(groupJid, forKey: "groupJid")
        jsonObject.setValue(leftUserJid, forKey: "leftUserJid")
        let jsonString = pluginDictToJson(dictionary: jsonObject)
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onLeftFromGroup_channel, value: jsonString)
    }
    
    public func didCreateGroup(groupJid: String) {
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onNewGroupCreated_channel, value: groupJid)
    }
    
    public func didFetchGroups(groups: [MirrorFlySDK.ProfileDetails]) {
        print("didFetchGroups")
    }
    
    public func didFetchGroupMembers(groupJid: String) {
        print("didFetchGroupMembers")
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onFetchingGroupMembersCompleted_channel, value: groupJid)
        NotificationCenter.default.post(name: .fetchGroupMembersCompleted, object: nil, userInfo: ["groupJid": groupJid])
    }
    
    public func didReceiveGroupNotificationMessage(message: MirrorFlySDK.ChatMessage) {
        
        let groupNotificationJson = message.toJson()
        
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onGroupNotificationMessage_channel, value: groupNotificationJson)
    }
    

}

extension FlyChatPlugin : LogoutDelegate {
    public func didReceiveLogout() {
        print("Logout Received from Mirrorfly SDK")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.chatEventInitializer.updateSinkValue(forChannel: Constants.onLoggedOut_channel, value: true)
        }
    }
}

extension FlyChatPlugin : ConnectionEventDelegate {
    public func onConnected() {
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onConnected_channel, value: true)
        flyChatUserDelegate?.chatManagerStatus(status: ConnectionStatus.connected)
        NotificationCenter.default.post(name: .connectionStatusChanged, object: nil, userInfo: ["status": "connected"])
    }
    
    public func onDisconnected() {
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onDisconnected_channel, value: true)
        flyChatUserDelegate?.chatManagerStatus(status: ConnectionStatus.disconnected)
    }
    
    public func onConnectionFailed(error: MirrorFlySDK.FlyError) {

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onConnectionFailed_channel, value: error.localizedDescription)
        flyChatUserDelegate?.chatManagerStatus(status: ConnectionStatus.connectionfailed(error: error.localizedDescription))

        NotificationCenter.default.post(name: .connectionStatusChanged, object: nil, userInfo: ["status": "failed", "error": error.localizedDescription])

    }

    public func onReconnecting() {
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onConnectionReconnecting_channel, value: true)
        flyChatUserDelegate?.chatManagerStatus(status: ConnectionStatus.reconnecting)
    }

}




extension FlyChatPlugin : MessageEventsDelegate   {

    public func onMessageReceived(message: MirrorFlySDK.ChatMessage, chatJid: String) {

        let messageReceivedJson = message.toJson()

//        FlySdkMethodCalls.shared.setLastMessage(messageID: message.messageId)

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMessageReceivedChannel, value: messageReceivedJson)

    }

    public func onMessageStatusUpdated(messageId: String, chatJid: String, status: MirrorFlySDK.MessageStatus) {

        let chatMessage = ChatManager.getMessageOfId(messageId: messageId)

        if(chatMessage == nil){
            return
        }

        let chatMessageJson = chatMessage?.toJson()

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMessageStatusUpdatedChannel, value: chatMessageJson)

    }

    public func onMessageEdited(message: MirrorFlySDK.ChatMessage) {

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMessageEdited_channel, value: message.toJson())
    }

    public func onMediaStatusUpdated(message : MirrorFlySDK.ChatMessage) {
        let chatMediaJson = message.toJson()

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMediaStatusUpdatedChannel, value: chatMediaJson)

    }

    public func onMediaStatusFailed(error: String, messageId: String, errorCode: Int) {
        let chatMessage = ChatManager.getMessageOfId(messageId: messageId)

        let chatMediaJson = chatMessage?.toJson()

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMediaStatusUpdatedChannel, value: chatMediaJson)

    }

    public func onMediaProgressChanged(message: MirrorFlySDK.ChatMessage, progressPercentage: Float) {

        let progressPercentageString = String(format:"%.0f", progressPercentage)

        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue(message.messageId, forKey: "message_id")
        jsonObject.setValue(Int(progressPercentageString), forKey: "progress_percentage")
        let jsonString = pluginDictToJson(dictionary: jsonObject)

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onUploadDownloadProgressChangedChannel, value: jsonString)


    }

    public func showOrUpdateOrCancelNotification() {

    }

    ///
    /// Old Delegate method for clear, delete chats
    ///

    /// message deleted
    public func onMessagesClearedOrDeleted(messageIds: Array<String>) {
        print("Delegate : onMessagesClearedOrDeleted => messageIds: \(messageIds)")
//        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMessagesClearedOrDeletedChannel, value: messageIds.toJson())
    }

    /// Recall
    public func onMessagesDeletedforEveryone(messageIds: Array<String>) {

        messageIds.forEach { messageId in
            let chatMessage = ChatManager.getMessageOfId(messageId: messageId)

            if(chatMessage == nil){
                return
            }
            let chatMessageJson = chatMessage?.toJson()

//            self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMessageStatusUpdatedChannel, value: chatMessageJson)

        }

    }

    /// message clear
    public func onMessagesCleared(toJid: String, deleteType: String?) {
        print("Delegate : onMessagesCleared => toJid: \(toJid) deleteType: \(String(describing: deleteType))")
        let messageClearedJson: NSMutableDictionary = NSMutableDictionary()
        messageClearedJson.setValue(toJid, forKey: "toJid")
        messageClearedJson.setValue(deleteType, forKey: "deleteType")
        let messageClearedJsonStr = pluginDictToJson(dictionary: messageClearedJson)
        print("Delegate : onMessagesClearedjson => \(String(describing: messageClearedJsonStr))")
//        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMessagesClearedChannel, value: messageClearedJsonStr)
    }

    public func clearAllConversationForSyncedDevice() {
        print("Delegate : clearAllConversationForSyncedDevice")
//        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onClearAllConversationChannel, value: true)
    }

    ///
    /// End of Old Delegate Method for clear, delete chats
    ///


    ///
    /// New Delegate method for clear, delete chats
    ///

    public func onChatCleared(toJid: String, chatClearType: MirrorFlySDK.ChatClearType) {

        print("Delegate : onChatCleared => toJid: \(toJid) chatClearType: \(String(describing: chatClearType))")
        let chatClearedJson: NSMutableDictionary = NSMutableDictionary()
        chatClearedJson.setValue(toJid, forKey: "toJid")
        if (chatClearType == .deleteChat) {
            chatClearedJson.setValue("delete", forKey: "chatClearType")
        }else if (chatClearType == .clearChat){
            chatClearedJson.setValue("clear", forKey: "chatClearType")
        }else{
            print("onChatCleared Delegate received unhandled value")
        }
        let chatClearedJsonStr = pluginDictToJson(dictionary: chatClearedJson)

        print("Delegate : onChatCleared => \(String(describing: chatClearedJsonStr))")

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onChatClearedChannel, value: chatClearedJsonStr)

    }

    public func onMessageDeleted(toJid: String, messageIds: [String], messageDeleteType: MirrorFlySDK.MessageDeleteType) {

        print("Delegate : onMessageDeleted => toJid: \(toJid), messageIds: \(messageIds), messageDeleteType: \(String(describing: messageDeleteType))")

        let messageDeletedJson: NSMutableDictionary = NSMutableDictionary()
        messageDeletedJson.setValue(toJid, forKey: "toJid")
        messageDeletedJson.setValue(messageIds, forKey: "messageIds")

        if (messageDeleteType == .deleteForEveryone) {
            messageDeletedJson.setValue("deleteForEveryone", forKey: "messageDeleteType")
        } else if (messageDeleteType == .deleteForMe) {
            messageDeletedJson.setValue("deleteForMe", forKey: "messageDeleteType")
        } else {
            print("onMessageDeleted Delegate received unhandled value")
        }

        let messageDeletedJsonStr = pluginDictToJson(dictionary: messageDeletedJson)

        print("Delegate : onMessageDeleted => \(String(describing: messageDeletedJsonStr))")

        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMessageDeletedChannel, value: messageDeletedJsonStr)

    }

    public func onAllChatsCleared() {
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onAllChatsClearedChannel, value: true)
    }



    public func setOrUpdateFavourite(messageId: String, favourite: Bool, removeAllFavourite: Bool) {
        print("Delegate : setOrUpdateFavourite => messageId: \(messageId) favourite: \(favourite) removeAllFavourite: \(removeAllFavourite)")
        let updateFavJson: NSMutableDictionary = NSMutableDictionary()
        updateFavJson.setValue(messageId, forKey: "messageId")
        updateFavJson.setValue(favourite, forKey: "favourite")
        updateFavJson.setValue(removeAllFavourite, forKey: "removeAllFavourite")
        let updateFavJsonStr = pluginDictToJson(dictionary: updateFavJson)
        print("Delegate : setOrUpdateFavouriteJson =>\(String(describing: updateFavJsonStr))")
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onUpdateFavouriteChannel, value: updateFavJsonStr)
    }

    public func onMessageTranslated(message: MirrorFlySDK.ChatMessage, jid: String) {

    }




//
//    public func didRemoveMemberFromAdmin(groupJid: String, removedAdminMemberJid: String, removedByMemberJid: String) {
//        let jsonObject: NSMutableDictionary = NSMutableDictionary()
//        jsonObject.setValue(groupJid, forKey: "groupJid")
//        jsonObject.setValue(removedAdminMemberJid, forKey: "removedAdminMemberJid")
//        jsonObject.setValue(removedByMemberJid, forKey: "removedByMemberJid")
//        let jsonString = pluginDictToJson(dictionary: jsonObject)
//        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onMemberRemovedAsAdmin_channel, value: jsonString)
//    }


//    public func onConnectionNotAuthorized() {
//        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onConnectionNotAuthorized_channel, value: true)
//        flyChatUserDelegate?.chatManagerStatus(status: ConnectionStatus.notAuthorized)
//    }
}

extension FlyChatPlugin {

    public func invalidJidLogout(){
       print("\(Constants.tag) Invalid JID Logout")
       self.chatEventInitializer.updateSinkValue(forChannel: Constants.onLoggedOut_channel, value: true)
   }
}


extension FlyChatPlugin : WebLogoutDelegate {
    public func didLogoutWeb(socketId: String) {
        print("Delegate : didLogoutWeb received -> \(socketId)")
//        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onWebLogoutChannel, value: socketId)
    }
}

extension FlyChatPlugin : MuteEventDelegate {

    public func onMuteStatusUpdated(isSuccess: Bool, message: String, jidList: [String], muteStatus: Bool) {
        print("Delegate : onMuteStatusUpdated => isSuccess: \(isSuccess) message: \(message) jidList: \(jidList)")
        let chatMuteJson: NSMutableDictionary = NSMutableDictionary()
        chatMuteJson.setValue(isSuccess, forKey: "isSuccess")
        chatMuteJson.setValue(message, forKey: "message")
        chatMuteJson.setValue(jidList.toJson(), forKey: "jidList")
        chatMuteJson.setValue(muteStatus, forKey: "muteStatus")
        let chatMuteJsonStr = pluginDictToJson(dictionary: chatMuteJson)
        print("Delegate : onMuteStatusUpdated => json \(String(describing: chatMuteJsonStr))")
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.onChatMuteStatusUpdatedChannel, value: chatMuteJsonStr)
    }

    public func didUpdateMuteSettings(isSuccess: Bool, message: String, isMuteStatus: Bool) {
        print("Delegate : didUpdateMuteSettings => isSuccess: \(isSuccess) message: \(message) isMuteStatus: \(isMuteStatus)")
        let updateMuteSettings: NSMutableDictionary = NSMutableDictionary()
        updateMuteSettings.setValue(isSuccess, forKey: "isSuccess")
        updateMuteSettings.setValue(message, forKey: "message")
        updateMuteSettings.setValue(isMuteStatus, forKey: "isMuteStatus")
        let updateMuteSettingsJson = pluginDictToJson(dictionary: updateMuteSettings)
        print("Delegate : didUpdateMuteSettings => json \(String(describing: updateMuteSettingsJson))")
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.didUpdateMuteSettingsChannel, value: updateMuteSettingsJson)
    }

}

extension FlyChatPlugin : ArchiveEventsDelegate {

    // Recent Chat Archive/UnArchive by user
    public func updateArchiveUnArchiveChats(toUser: String, archiveStatus: Bool) {
        print("Delegate : updateArchiveUnArchiveChats => toUser: \(toUser) archiveStatus: \(archiveStatus)")
        let updateArchiveUnArchiveChats: NSMutableDictionary = NSMutableDictionary()
        updateArchiveUnArchiveChats.setValue(toUser, forKey: "toUser")
        updateArchiveUnArchiveChats.setValue(archiveStatus, forKey: "archiveStatus")
        let updateArchiveUnArchiveChatsJson = pluginDictToJson(dictionary: updateArchiveUnArchiveChats)
        print("Delegate : updateArchiveUnArchiveChats => json \(String(describing: updateArchiveUnArchiveChatsJson))")
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.updateArchiveUnArchiveChatsChannel, value: updateArchiveUnArchiveChatsJson)
    }

    public func updateArchivedSettings(archivedSettingsStatus: Bool) {
        print("Delegate : updateArchivedSettings => archivedSettingsStatus: \(archivedSettingsStatus)")
        self.chatEventInitializer.updateSinkValue(forChannel: Constants.updateArchivedSettingsChannel, value: archivedSettingsStatus)
    }


}
