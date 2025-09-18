//
//  UserDefaults.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 15/06/23.
//

import Foundation
import CommonCrypto
import MirrorFlySDK

public class Utility: NSObject{
    
    /// To save the temp profile IV
    public class func saveStaticString(key : String , value : String) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    /// To get the temp profile IV
    public class func getStaticString(key : String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    public class func saveInPreference (key : String , value : Any) {
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
    
    public class func getStringFromPreference(key : String) -> String {
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
    
    public class func getBoolFromPreference(key : String) -> Bool {
        if let value = UserDefaults.standard.object(forKey: key) {
            if let encryptedData =  value as? Data{
                if let decryptedData = encryptDecryptFlyDefaults(key: key, data:  encryptedData, encrypt: false){
                    return (String(data: decryptedData, encoding: .utf8)! == "true" )
                }
            } else if let oldValue = value as? Bool {
                saveInPreference(key: key, value: oldValue)
                return oldValue
            }
        }
        return false
    }
    
    
    class func clearUserDefaults(){
        let defaults = UserDefaults.standard
        let dictionary =  defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    class func encryptDecryptFlyDefaults(key:String, data : Data, encrypt : Bool, iv : String = "ddc0f15cc2c90fca") -> Data?{
        guard let key = FlyEncryption.sha256(key, length: 32) else {
            return data
        }
        guard let flyEncryption = FlyEncryption(encryptionKey: key, initializationVector: iv ) else {
            return data
        }
        
        if encrypt {
            guard let encryptedData  = flyEncryption.crypt(data: data, option: CCOperation(kCCEncrypt)) else {
                return data
            }
            print("#ud encrypt \(key)  \(encryptedData)")
            return encryptedData
        } else {
            guard let decryptedData  = flyEncryption.crypt(data: data, option:  CCOperation(kCCDecrypt)) else {
                return nil
            }
            print("#ud decrypt \(key)  \(decryptedData)")
            return decryptedData
        }
    }
}
