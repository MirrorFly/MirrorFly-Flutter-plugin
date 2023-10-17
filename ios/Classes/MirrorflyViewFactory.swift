//
//  MirrorflyViewFactory.swift
//  mirrorfly_chat
//
//  Created by Mani Vendhan on 13/06/23.
//

import Foundation
import Flutter
import UIKit
import CommonCrypto

class MirrorflyViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    //    public var mirrorflyViews = [Int64: MirrorflyView]()
    public var mirrorflyViews = [Int64: (String, MirrorflyView)]()
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        NSLog("\(Constants.callTag) MirrorflyViewFactory init")
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        
        let argument = args as? [String: Any]
        NSLog("\(Constants.callTag) MirrorflyViewFactory argument--> \(String(describing: argument))")
        NSLog("\(Constants.callTag) MirrorflyViewFactory mirrorflyViews length--> \(mirrorflyViews.count)")
        
        let userJid : String? = argument?["userJid"] as? String
        
        var viewUniqueID : Int64?
        
        var mirrorflyView : MirrorflyView?
        
        if let jidForUniqID = userJid {
//            uniqueID = generateUniqueID(from: userJid!)
            generateUniqueID(from: jidForUniqID) { uniqueID in
                NSLog("\(Constants.callTag) MirrorflyViewFactory Unique ID generated \(String(describing: uniqueID))")
                if let generatedUniqueID = uniqueID {
                    viewUniqueID = generatedUniqueID
                    if (self.mirrorflyViews.keys.contains(generatedUniqueID)){
                        if let (_, mirrorflyView) = self.mirrorflyViews[generatedUniqueID] {
                            NSLog("\(Constants.callTag) MirrorflyViewFactory View Already Exists so disposing \(generatedUniqueID)")
                            mirrorflyView.dispose()
                            self.mirrorflyViews.removeValue(forKey: generatedUniqueID)
                            NSLog("\(Constants.callTag) MirrorflyViewFactory View disposed \(generatedUniqueID)")
                        } else {
                            // Handle case when view is not found
                            NSLog("\(Constants.callTag) MirrorflyViewFactory View Cannot be disposed \(generatedUniqueID)")
                        }
                    }
                    mirrorflyView = MirrorflyView(
                        frame: frame,
                        viewIdentifier: generatedUniqueID,
                        arguments: args,
                        binaryMessenger: self.messenger)
                }else{
                    NSLog("\(Constants.callTag) MirrorflyViewFactory Failed to generate uniqueID.")
                }
            }
           
        }else{
            NSLog("\(Constants.callTag) MirrorflyViewFactory userJID is nil")
        }
        
        if let jid = userJid, let mirrorflyViewID = viewUniqueID, let view = mirrorflyView {
            if (mirrorflyViews.keys.contains(mirrorflyViewID)){
                NSLog("\(Constants.callTag) MirrorflyViewFactory this view for jid - uniq ID: \(mirrorflyViewID) is already inserted in array list ")
            }else{
                mirrorflyViews[mirrorflyViewID] = (jid, view)
            }
            NSLog("\(Constants.callTag) MirrorflyViewFactory mirrorflyViews length after assigning--> \(mirrorflyViews.count)")
        }else{
            NSLog("\(Constants.callTag) MirrorflyViewFactory Error while inserting the mirrorflyViews array.")
        }
        NSLog("MirrorflyViewFactory returning view")
        return mirrorflyView!
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func generateUniqueID(from string: String, completion: @escaping (Int64?) -> Void) {
        guard let data = string.data(using: .utf8) else {
            fatalError("MirrorflyViewFactory generateUniqueID Failed to convert string to data")
        }
        
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
        }
        
        let truncatedHash = hash.prefix(MemoryLayout<UInt64>.size)
        let uniqueID = truncatedHash.withUnsafeBytes { $0.load(as: UInt64.self) }
        
        let signedUniqueID = Int64(bitPattern: uniqueID)
        
        let positiveUniqueID = abs(signedUniqueID)
        
        completion(positiveUniqueID)
    }
    
    public func clearMirrorflyView(userJID: String) -> Void{
        
        NSLog("\(Constants.callTag) clearMirrorflyView userJID \(userJID)")
        NSLog("\(Constants.callTag) Native List View", mirrorflyViews)
        
        if let mirrorFlyViewId = getUniqueID(forString: userJID) {
            if let (_, mirrorflyView) = mirrorflyViews[mirrorFlyViewId] {
                NSLog("\(Constants.callTag) MirrorflyViewFactory View disposing \(mirrorFlyViewId)")
                mirrorflyView.dispose()
                NSLog("\(Constants.callTag) MirrorflyViewFactory View disposed \(mirrorFlyViewId)")
            } else {
                // Handle case when view is not found
                NSLog("\(Constants.callTag) MirrorflyViewFactory View Cannot be disposed")
            }
            mirrorflyViews.removeValue(forKey: mirrorFlyViewId)
            NSLog("\(Constants.callTag) Native List View", mirrorflyViews)
            NSLog("\(Constants.tag) MirrorflyViewFactory after removal of view from Array list size --> \(mirrorflyViews.count)")
        } else {
            // Handle case when unique ID is not found
            NSLog("\(Constants.callTag) MirrorflyViewFactory View --> Unique ID is not Found")
        }
        
//        if(mirrorflyViews.count > 0){
//            NSLog("\(Constants.callTag) MirrorflyViewFactory clearing Mirrorfly Views")
//            for (uniqueID, _) in mirrorflyViews {
//                if let (_, mirrorflyView) = mirrorflyViews[uniqueID] {
//                    NSLog("\(Constants.callTag) MirrorflyViewFactory View disposing \(uniqueID)")
//                    mirrorflyView.dispose()
//                    NSLog("\(Constants.callTag) MirrorflyViewFactory View disposed \(uniqueID)")
//                } else {
//                    // Handle case when view is not found
//                    NSLog("\(Constants.callTag) MirrorflyViewFactory View Cannot be disposed")
//                }
//                mirrorflyViews.removeValue(forKey: uniqueID)
//                NSLog("\(Constants.tag) MirrorflyViewFactory after removal of view from Array list size --> \(mirrorflyViews.count)")
//
//            }
//
//        }
    }

    
//    func generateUniqueID(from string: String) -> Int64 {
//        guard let data = string.data(using: .utf8) else {
//            fatalError("Failed to convert string to data")
//        }
//
//        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//
//        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
//            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
//        }
//
//        let truncatedHash = hash.prefix(MemoryLayout<UInt64>.size)
//        let uniqueID = truncatedHash.withUnsafeBytes { $0.load(as: UInt64.self) }
//
//        let signedUniqueID = Int64(bitPattern: uniqueID)
//
//        return signedUniqueID
//    }
    
//    func getMirrorflyView(string: String) -> MirrorflyView? {
//        if let (uniqueID, view) = mirrorflyViews.first(where: { $0.value.0 == string }) {
//            return view
//        }
//        return nil
//    }
//    func getMirrorflyView(string: String) -> MirrorflyView? {
//        return mirrorflyViews[string]
//    }
    public func getUniqueID(forString string: String) -> Int64? {
        for (uniqueID, tuple) in mirrorflyViews {
            if tuple.0 == string {
                return uniqueID
            }
        }
        return nil
    }
    
}

