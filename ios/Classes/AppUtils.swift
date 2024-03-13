//
//  AppUtils.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 21/08/23.
//

import Foundation
import MirrorFlySDK
import Photos

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
}
