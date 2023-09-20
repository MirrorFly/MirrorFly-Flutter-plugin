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
        print("\(Constants.callTag) MirrorflyViewFactory init")
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        
        let argument = args as? [String: Any]
        print("\(Constants.callTag) MirrorflyViewFactory argument--> \(String(describing: argument))")
        print("\(Constants.callTag) MirrorflyViewFactory mirrorflyViews length--> \(mirrorflyViews.count)")
        
        let userJid : String? = argument?["userJid"] as? String
        
        var viewUniqueID : Int64?
        
        var mirrorflyView : MirrorflyView?
        
        if let jidForUniqID = userJid {
//            uniqueID = generateUniqueID(from: userJid!)
            generateUniqueID(from: jidForUniqID) { uniqueID in
                print("\(Constants.callTag) MirrorflyViewFactory Unique ID generated \(String(describing: uniqueID))")
                if let generatedUniqueID = uniqueID {
                    viewUniqueID = generatedUniqueID
                    mirrorflyView = MirrorflyView(
                        frame: frame,
                        viewIdentifier: generatedUniqueID,
                        arguments: args,
                        binaryMessenger: self.messenger)
                }else{
                    print("\(Constants.callTag) MirrorflyViewFactory Failed to generate uniqueID.")
                }
            }
           
        }else{
            print("\(Constants.callTag) MirrorflyViewFactory userJID is nil")
        }
        
        if let jid = userJid, let mirrorflyViewID = viewUniqueID, let view = mirrorflyView {
            mirrorflyViews[mirrorflyViewID] = (jid, view)
        }else{
            print("\(Constants.callTag) MirrorflyViewFactory Error while inserting the mirrorflyViews array.")
        }
        print("MirrorflyViewFactory returning view")
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
    
    public func clearMirrorflyView() -> Void{
        
        if(mirrorflyViews.count > 0){
            print("\(Constants.callTag) clearing Mirrorfly Views view Factory")
            for (uniqueID, _) in mirrorflyViews {
                if let (_, mirrorflyView) = mirrorflyViews[uniqueID] {
                    print("\(Constants.callTag) View disposing \(uniqueID)")
                    mirrorflyView.dispose()
                    print("\(Constants.callTag) View disposed \(uniqueID)")
                } else {
                    // Handle case when view is not found
                    print("\(Constants.callTag) View Cannot be disposed")
                }
                mirrorflyViews.removeValue(forKey: uniqueID)
                
            }
//            mirrorflyViews.removeAll()
            
        }
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

