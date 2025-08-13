//
//  AppUtils.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 21/08/23.
//

import Foundation
import MirrorFlySDK
import Photos
import Flutter

class AppUtils {
    
    //Singleton class
    static let shared: AppUtils = AppUtils()
    
    var voipTokenObserver: NSObjectProtocol?
    
    private init() {}
        
    func getMyJid() -> String {
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
    
    
    func getPHAsset(from imageUrl: String) -> PHAsset? {
        let assetURL = URL(fileURLWithPath: imageUrl)

        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)

        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)

        for index in 0..<fetchResult.count {
            let phAsset = fetchResult[index]

            if let phAssetURL = phAsset.value(forKey: "filename") as? String,
                URL(fileURLWithPath: phAssetURL) == assetURL {
                return phAsset
            }
        }

        return nil
    }
    
    func getValueForKey<T, U>(dictionary: [T: U]?, key: T) -> U? {
        guard let dict = dictionary, let value = dict[key] else {
                return nil
        }
        return value
    }
    
    func fileExists(atPath filePath: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: filePath)
    }
    
    func saveFile(from sourceURL: URL, fileName: String?) -> String? {
        let destinationURL = FlyUtils.getGroupContainerIDPath()?.appendingPathComponent(fileName!)
        
        do {
            let fileManager = FileManager.default
            try fileManager.copyItem(at: sourceURL, to: destinationURL!)
            return destinationURL?.absoluteString
        } catch {
            // Error handling
            print("Error copying file: \(error.localizedDescription)")
            return nil
        }
    }
    
    func debugLog(tag: String, log: String){
        NSLog("\(tag): %@", log)
    }
    
    func getMediaCompressionType(type: Int?) -> MirrorFlySDK.MediaQuality {
        if type != nil {
            if type == 0 {
                return MediaQuality.uncompressed
            } else if type == 1 {
                return MediaQuality.low
            } else if type == 2 {
                return MediaQuality.medium
            } else if type == 3 {
                return MediaQuality.high
            } else {
                return MediaQuality.uncompressed
            }
        }  else {
            return MediaQuality.uncompressed
        }
    }

    
    func checkAndUpdateVOIPToken(isForceUpdate: Bool = false ,result: FlutterResult? = nil) {
            
            let voipToken = Utility.getStringFromPreference(key: Constants.voipToken)
            
            if voipToken.isEmpty {
                
                voipTokenObserver = NotificationCenter.default.addObserver(forName: .updateVoipToken, object: nil, queue: nil) { notification in
                    if notification.userInfo?["voip"] is String {
                        self.removeObserver()
                        self.performDeviceTokenUpdate(isForceUpdate: isForceUpdate, result: result)
                }
                }
                // No token → Register for VOIP notifications
                FlyCall.shared?.registerVoipFirstTime = false
                FlyCall.shared?.registerForVOIPNotifications()
                
            } else {
                // Update device token
                performDeviceTokenUpdate(isForceUpdate: isForceUpdate, result: result)
            }
        }
    
    private func performDeviceTokenUpdate(isForceUpdate: Bool = false, result: FlutterResult?) {
        VOIPManager.sharedInstance.updateDeviceToken(isForceUpdate: isForceUpdate) { isSuccess, updatedVOIPToken, updatedDeviceToken, tokenError in
            
            if isSuccess {
                
                let response: [String: String] = [
                    "updatedVOIPToken": updatedVOIPToken,
                    "updatedDeviceToken": updatedDeviceToken
                ]
                
                result?("\(response)")
            } else {                
                let response: [String: String] = [
                    "error" : "Error updating tokens"
                ]
                result?("\(response)")
            }
        }
    }
    
    private func removeObserver() {
        if let observerToken = voipTokenObserver {
            NotificationCenter.default.removeObserver(observerToken)
            self.voipTokenObserver = nil
        }
    }
    
}
