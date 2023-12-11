//
//  JSONConverter.swift
//  mirrorfly_plugin
//
//  Created by user on 17/05/23.
//

import Foundation
import MirrorFlySDK

//class JSONConverter {
//    static func convertObjectToJSON(_ jsonObjectToConvert: Any) -> String? {
//        let jsonEncoder = JSONEncoder()
//        jsonEncoder.outputFormatting = .prettyPrinted
//        do {
//            let jsonData = try jsonEncoder.encode(jsonObjectToConvert)
//            let jsonString = String(data: jsonData, encoding: .utf8)
//            return jsonString
//        } catch {
//            print("Error converting object to JSON: \(error)")
//            return nil
//        }
//    }
//}


extension Encodable {
    func toJson() -> String? {
        let jsonEncoder = JSONEncoder()
//        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    func convertToJson() -> String? {
            do {
                let jsonData = try JSONEncoder().encode(self)
                return String(data: jsonData, encoding: .utf8)
            } catch {
                print("Error converting object to JSON: \(error)")
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


enum JSONParsingError: Error {
    case extractionError
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


func extractData(from jsonString: String) -> [String: Any]? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }

    do {
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])

        if let jsonDict = jsonObject as? [String: Any], let data = jsonDict["data"] as? [String: Any] {
            return data
        } else {
            return nil
        }
    } catch {
        print("Error extracting data JSON object: \(error)")
        return nil
    }
}

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

enum FileHelper {
//    static func saveInDirectory(fileUrl: String?) -> String? {
//        let fileManager = FileManager.default
//        let fileURL = URL(fileURLWithPath: fileUrl!)
//        let fileData = getFileData(from: fileURL)
//        guard let localFilePath = FlyUtils.getGroupContainerIDPath()?.appendingPathComponent(fileUrl!) else {
//            return nil
//        }
//
//        if let value = fileData {
//            do {
//                try value.write(to: localFilePath)
//                return localFilePath.absoluteString
//            } catch let error {
//                print("#write: compressAndSaveImage catch \(error.localizedDescription)")
//            }
//        }
//
//        return nil
//    }
    
    

}

func saveInDirectory(with data: Data?, fileName: String?) -> String? {
        //let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
        let localFilePath = FlyUtils.getGroupContainerIDPath()?.appendingPathComponent(fileName!)
    print("localFilePath\(String(describing: localFilePath))")
        if let value = data, let url = localFilePath {
            do {
                try value.write(to: url)
            }catch let error {
                print("#write : compressAndSaveImage catch \(error.localizedDescription)")
            }
        }
        return localFilePath?.absoluteString
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

func getFileData(from fileURL: URL) -> Data? {
    do {
        let fileData = try Data(contentsOf: fileURL)
        return fileData
    } catch {
        print("Error reading file data: \(error)")
        return nil
    }
}

//}

func fileExists(atPath filePath: String) -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: filePath)
}

func getCallLogs(flyData: [String: Any]) -> [String: Any]{

    
    guard let data = flyData["data"] as? [String: Any] else {
        print("Error: Unable to extract 'data' from originalData.")
        return [:]
    }

    guard let callList = data["callList"] as? [Any] else {
        print("Error: Unable to extract 'callList' from 'data'.")
        print("Error: data: \(data)")
        return [:]
    }


    let callListData: [[String: Any]] = callList.compactMap { callLogObject in
        let callLog = callLogObject as? MirrorFlySDK.CallLog
        let roomId = callLog?.callLogId ?? ""
        let fromUser = callLog?.fromUserId ?? ""
        let toUser = callLog?.toUserId ?? ""
        let callType = callLog?.callType.rawValue ?? ""
        let callTime = callLog?.callReceivedTime ?? 0.0
        let endTime = callLog?.callEndedTime ?? 0.0
        let callState = callLog?.callState.rawValue ?? ""
        let callMode = callLog?.callMode.rawValue ?? ""
        let userList = callLog?.userList ?? []
        let groupId = callLog?.groupId ?? ""
        let isSync = callLog?.isLogSynced ?? false
        let startTime = callLog?.callAttendedTime ?? 0.0
//        let displayName = callLog?.displayName
            return [
                "callMode": callMode,
                "callState": callState,
                "callTime": callTime,
                "callType": callType,
                "callerDevice": "",
                "endTime": endTime,
                "fromUser": fromUser,
                "groupId": groupId,
                "inviteUserList": [] as [String],
                "isCarbonAnswered": false,
                "isDeleted": false,
                "isDisplay": true,
                "isSync": isSync,
                "roomId": roomId,
                "rowId": 0,
                "sessionStatus": "",
                "startTime": startTime,
                "toUser": toUser,
                "userList": userList
            ]
        }

    let result: [String: Any] = [
            "data": callListData,
            "total_pages": data["totalPages"] ?? 0
        ]
        return result
//    return callListData
}

//extension String {
//    func extractJSONObject() -> Any? {
//        return JSONExtractor.extractJSONObject(from: self)
//    }
//}



