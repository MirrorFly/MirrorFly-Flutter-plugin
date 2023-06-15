//
//  UserDefaults.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation

class Utility: NSObject{
    
    class func saveInPreference (key : String , value : Any) {
        var stringaValue = ""
        if let boolString = value as? Bool{
            stringaValue = boolString ? "true" : "false"
        }else if let value = value as? String{
            stringaValue  = value
        }
        if let encryptedData = encryptDecryptFlyDefaults(key: key, data:  Data(stringaValue.utf8), encrypt: true){
            UserDefaults.standard.setValue(encryptedData, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getStringFromPreference(key : String) -> String {
        if let value =  UserDefaults.standard.object(forKey: key) {
            if let encryptedData = value as? Data{
                if let decryptedData = encryptDecryptFlyDefaults(key: key, data:  encryptedData, encrypt: false){
                    return String(data: decryptedData, encoding: .utf8)!
                }
            }else if let oldValue = value as? String {
                saveInPreference(key: key, value: oldValue)
                return oldValue
            }
        }
        return ""
    }
}
