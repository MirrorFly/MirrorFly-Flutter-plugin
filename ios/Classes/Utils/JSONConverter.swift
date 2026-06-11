//
//  JSONConverter.swift
//  mirrorfly_plugin
//
//  Created by user on 17/05/23.
//

import Foundation
import MirrorFlySDK


extension Encodable {
    func toJson() -> String? {
        let jsonEncoder = JSONEncoder()
        /// Enable this below line to debug in console window json beautifier
//        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
   
}

extension Collection where Iterator.Element == [String: Any] {
  func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
    if let arr = self as? [[String: Any]],
       let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
       let str = String(data: dat, encoding: String.Encoding.utf8) {
      return str
    }
    return "[]"
  }
}

extension Dictionary where Key == String, Value == Any {
    func dictToJson() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error converting dictionary to JSON: \(error)")
            return nil
        }
    }
}

func convertArrayToJSONString(array: [[String: Any]]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: array, options: [])
        return String(data: jsonData, encoding: .utf8)
    } catch {
        print("Error converting array to JSON string: \(error)")
        return nil
    }
}

//// Helper function using reflection
//func metaDataToDictionary(_ metaData: MetaData) -> [String: Any] {
//    let mirror = Mirror(reflecting: metaData)
//    var dict = [String: Any]()
//
//    for child in mirror.children {
//        if let propertyName = child.label {
//            dict[propertyName] = child.value
//        }
//    }
//    return dict
//}
//
//// Extension to convert array of MetaData to JSON string
//extension Array where Element == MetaData {
//    func toJsonString() -> String {
//        let arrayDict = self.map(metaDataToDictionary)
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: arrayDict)
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                return jsonString
//            }
//        } catch {
//            print("Error converting to JSON: \(error)")
//        }
//        return "{}"
//    }
//}



//func extractData(from jsonString: String) -> [String: Any]? {
//    guard let jsonData = jsonString.data(using: .utf8) else {
//        return nil
//    }
//
//    do {
//        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
//
//        if let jsonDict = jsonObject as? [String: Any], let data = jsonDict["data"] as? [String: Any] {
//            return data
//        } else {
//            return nil
//        }
//    } catch {
//        print("Error extracting data JSON object: \(error)")
//        return nil
//    }
//}

func pluginDictToJson(dictionary: NSMutableDictionary) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    } catch {
        print("Error converting dictionary to JSON: \(error)")
        return nil
    }
}


func getCallLogs(callList: [Any], totalPages: Any?) -> [String: Any]{


//    let callListData: [[String: Any]] = callList.compactMap { callLogObject in
//        let callLog = callLogObject as? MirrorFlySDK.CallLog
//        let roomId = callLog?.callLogId ?? ""
//        let fromUser = callLog?.fromUserId ?? ""
//        let toUser = callLog?.toUserId ?? ""
//        let callType = callLog?.callType.rawValue ?? ""
//        let callTime = callLog?.callReceivedTime ?? 0.0
//        let endTime = callLog?.callEndedTime ?? 0.0
//        let callState = callLog?.callState.rawValue ?? ""
//        let callMode = callLog?.callMode.rawValue ?? ""
//        let userList = callLog?.userList ?? []
//        let groupId = callLog?.groupId ?? ""
//        let isSync = callLog?.isLogSynced ?? false
//        let startTime = callLog?.callAttendedTime ?? 0.0
//        let displayName = callLog?.displayName ?? ""
//            return [
//                "callMode": callMode,
//                "callState": callState,
//                "callTime": callTime,
//                "callType": callType,
//                "callerDevice": "",
//                "endTime": endTime,
//                "fromUser": fromUser,
//                "groupId": groupId,
//                "inviteUserList": [] as [String],
//                "isCarbonAnswered": false,
//                "isDeleted": false,
//                "isDisplay": true,
//                "isSync": isSync,
//                "roomId": roomId,
//                "rowId": 0,
//                "sessionStatus": "",
//                "startTime": startTime,
//                "toUser": toUser,
//                "nickName": displayName,
//                "userList": userList.filter { $0 != AppUtils.shared.getMyJid() && !$0.isEmpty }
//            ]
//        }

    let result: [String: Any] = [
            "data": "",
            "total_pages": 0 ?? 0
        ]
        return result
}




