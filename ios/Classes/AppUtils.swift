//
//  AppUtils.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 21/08/23.
//

import Foundation
import MirrorFlySDK

class AppUtils: NSObject {
    
    //Singleton class
    static let shared = AppUtils()
    
    class func getMyJid() -> String {
        guard let myJid = try? FlyUtils.getMyJid() else {
            AppUtils.shared.forceLogout()
            return emptyString()
        }
        return myJid
    }
    
    func forceLogout() {
        ChatManager.logoutApi() {isSuccess,error,data in
            ChatManager.disconnect()
            ChatManager.shared.resetFlyDefaults()
        }
        let flyChatPlugin = FlyChatPlugin()

        flyChatPlugin.invalidJidLogout()
        
    }
    
}
