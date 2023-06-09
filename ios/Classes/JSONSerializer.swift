//
//  JSONSerializer.swift
//  fly_chat
//
//  Created by user on 23/03/23.
//

import Foundation
import FlyCommon

/// Handles Convertion from instances of objects to JSON strings. Also helps with casting strings of JSON to Arrays or Dictionaries.
open class JSONSerializer {
    
    /**
    Errors that indicates failures of JSONSerialization
    - JsonIsNotDictionary:    -
    - JsonIsNotArray:            -
    - JsonIsNotValid:            -
    */
    public enum JSONSerializerError: Error {
        case jsonIsNotDictionary
        case jsonIsNotArray
        case jsonIsNotValid
    }
    
    static func toSimpleJson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //http://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
    /**
    Tries to convert a JSON string to a NSDictionary. NSDictionary can be easier to work with, and supports string bracket referencing. E.g. personDictionary["name"].
    - parameter jsonString:    JSON string to be converted to a NSDictionary.
    - throws: Throws error of type JSONSerializerError. Either JsonIsNotValid or JsonIsNotDictionary. JsonIsNotDictionary will typically be thrown if you try to parse an array of JSON objects.
    - returns: A NSDictionary representation of the JSON string.
    */
    public static func toDictionary(_ jsonString: String) throws -> NSDictionary {
        if let dictionary = try jsonToAnyObject(jsonString) as? NSDictionary {
            return dictionary
        } else {
            throw JSONSerializerError.jsonIsNotDictionary
        }
    }
    
    /**
    Tries to convert a JSON string to a NSArray. NSArrays can be iterated and each item in the array can be converted to a NSDictionary.
    - parameter jsonString:    The JSON string to be converted to an NSArray
    - throws: Throws error of type JSONSerializerError. Either JsonIsNotValid or JsonIsNotArray. JsonIsNotArray will typically be thrown if you try to parse a single JSON object.
    - returns: NSArray representation of the JSON objects.
    */
    public static func toArray(_ jsonString: String) throws -> NSArray {
        if let array = try jsonToAnyObject(jsonString) as? NSArray {
            return array
        } else {
            throw JSONSerializerError.jsonIsNotArray
        }
    }
    
    /**
    Tries to convert a JSON string to AnyObject. AnyObject can then be casted to either NSDictionary or NSArray.
    - parameter jsonString:    JSON string to be converted to AnyObject
    - throws: Throws error of type JSONSerializerError.
    - returns: Returns the JSON string as AnyObject
    */
    fileprivate static func jsonToAnyObject(_ jsonString: String) throws -> Any? {
        var any: Any?
        
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                any = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            }
            catch let error as NSError {
                let sError = String(describing: error)
                NSLog(sError)
                throw JSONSerializerError.jsonIsNotValid
            }
        }
        return any
    }

    /**
    Generates the JSON representation given any custom object of any custom class. Inherited properties will also be represented.
    - parameter object:    The instantiation of any custom class to be represented as JSON.
    - returns: A string JSON representation of the object.
    */
    public static func toJson(_ object: Any, prettify: Bool = false) -> String {
        var json = ""
        if (!(object is Array<Any>)) {
            json += "{"
        }
        let mirror = Mirror(reflecting: object)
        
        var children = [(label: String?, value: Any)]()
        
        if let mirrorChildrenCollection = AnyRandomAccessCollection(mirror.children) {
            children += mirrorChildrenCollection
        }
        else {
            let mirrorIndexCollection = AnyCollection(mirror.children)
            children += mirrorIndexCollection
        }
        
        var currentMirror = mirror
        while let superclassChildren = currentMirror.superclassMirror?.children {
            
            if let mirrorChildrenCollection = AnyRandomAccessCollection(superclassChildren) {
                children += mirrorChildrenCollection
            }
            else {
                let mirrorIndexCollection = AnyCollection(superclassChildren)
                children += mirrorIndexCollection
            }
            let randomCollection = AnyRandomAccessCollection(superclassChildren)!
            
           // children += randomCollection
            currentMirror = currentMirror.superclassMirror!
            print("children count \(children.count)")
            
        }
        
        var filteredChildren = [(label: String?, value: Any)]()
        
        for (optionalPropertyName, value) in children {
//            print("optionalPropertyName")
            if optionalPropertyName == "mediaChatMessage" {
                print("Media value")
            }
            
           // for (optionalPropertyName, value) in children {
//                            if !optionalPropertyName!.contains("notMapped_") {
//                                filteredChildren += [(optionalPropertyName, value)]
//                            }
                       // }

            if let optionalPropertyName = optionalPropertyName {

                if !optionalPropertyName.contains("notMapped_") {
                    filteredChildren.append((optionalPropertyName, value))
                }

            }
            else {
                filteredChildren.append((nil, value))
            }
        }
        
        
        var skip = false
        var hasChildren = false
        let size = filteredChildren.count
        var index = 0
        
        var first = true
        
        for (optionalPropertyName, value) in filteredChildren {
            skip = false
            
            let propertyName = optionalPropertyName
            let property = Mirror(reflecting: value)
            
            if propertyName == "mediaChatMessage" {
//                print("Media value \(value)")
            }
            
            if propertyName == "mediaThumbImage" {
//                print("mediaThumbImage value \(value)")
            }
            
            if propertyName == "replyParentChatMessage"{
//                print("replyParentChatMessage--> \(value)")
//                print("replyParentChatMessage--> \(String(describing: value))")
            }
            
            
//            if(propertyName == "nickName" && value as! String == "67890"){
//                print("property nickName-->\(propertyName)")
//                print("property nickName-->\(value)")
//            }
            
        if let mirrorChildrenCollection = AnyRandomAccessCollection(property.children), mirrorChildrenCollection.count > 0 {
           // if let superclassChildren = property.superclassMirror?.children, superclassChildren.count > 0 {
               // hasChildren = true
            }
           
            
//            var isObject = false
//            let mirrorChildren = Mirror(reflecting: value)
//
//            var childrenChildren = [(label: String?, value: Any)]()
//
//            if let mirrorChildrenCollection = AnyRandomAccessCollection(mirrorChildren.children) {
//                childrenChildren += mirrorChildrenCollection
//                isObject = true
//            }
//            else {
//                let mirrorIndexCollection = AnyCollection(mirrorChildren.children)
//                childrenChildren += mirrorIndexCollection
//                isObject = true
//            }
//
//            var currentMirror = mirror
//            while let superclassChildren = currentMirror.superclassMirror?.children {
//                let randomCollection = AnyRandomAccessCollection(superclassChildren)!
//                childrenChildren += randomCollection
//                currentMirror = currentMirror.superclassMirror!
//                isObject = true
//            }
//
//
//
//            var filteredChildren = [(label: String?, value: Any)]()
//
//            for (optionalPropertyName, value) in children {
//
//                if let optionalPropertyName = optionalPropertyName {
//
//                    if !optionalPropertyName.contains("notMapped_") {
//                        filteredChildren.append((optionalPropertyName, value))
//                    }
//
//                }
//                else {
//                    filteredChildren.append((nil, value))
//                }
//            }
            
            
            
            var handledValue = String()
            
//            if isObject == true {
//                JSONSerializer.toJson(value)
//                skip = true
//            }
            
//            print("property displaytype \(String(describing: property.displayStyle))")
            if (propertyName != nil && propertyName == "some" && property.displayStyle == Mirror.DisplayStyle.struct){
                handledValue = toJson(value)
                skip = true
            }
//            else if property.displayStyle == Mirror.DisplayStyle. {
//                handledValue = toJson(value)
//                skip = true
//            }
            else if (value is Int ||
                     value is Int32 ||
                     value is Int64 ||
                     value is Double ||
                     value is Float ||
                     value is Bool) && property.displayStyle != Mirror.DisplayStyle.optional {
                handledValue = String(describing: value)
            }
            else if property.displayStyle == Mirror.DisplayStyle.enum {
                           handledValue = "\"\(value)\""
                        }
          
            else if let array = value as? [Int?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Double?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Float?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [Bool?] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? String(value!) : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [String?] {
               
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += value != nil ? "\"\(value!)\"" : "null"
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? [String] {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    handledValue += "\"\(value)\""
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if let array = value as? NSArray {
                handledValue += "["
                for (index, value) in array.enumerated() {
                    if !(value is Int) &&
                       !(value is Int32) &&
                       !(value is Int64) &&
                       !(value is Double) && !(value is Float) && !(value is Bool) && !(value is String) {
                        handledValue += toJson(value)
                    }
                    else {
                        handledValue += "\(value)"
                    }
                    handledValue += (index < array.count-1 ? ", " : "")
                }
                handledValue += "]"
            }
            else if property.displayStyle == Mirror.DisplayStyle.class ||
                property.displayStyle == Mirror.DisplayStyle.struct ||
                        String(describing: value).contains("#")   {
                handledValue = toJson(value)
            }
            else if(propertyName == "messageTextContent" || propertyName == "lastMessageContent") &&  String(describing: value) != "nil" {
                var convert = String(describing: value).replacingOccurrences(of: "\n", with: "\\n")
//                convert = convert.utf8EncodedString()
//                    handledValue =  "\"\(convert)\""
                handledValue =  "\"\(convert)\""
//                if !convert.isEmpty {
//                    handledValue =  #""\#(convert)""#
//                } else {
//                    handledValue = "\"\(value)\""
//                }
                
            }
            
            else if (propertyName == "mediaChatMessage") &&  String(describing: value) != "nil" {
               // let refined = String(describing: value).replacingOccurrences(of: "some", with: "")
                print("mediaThumbImage check")
                print("force-->\(value)")
//                 else {
                var force = value as! MediaChatMessage
                var image: String = "\(force.mediaThumbImage)"
                force.mediaThumbImage = image.replacingOccurrences(of: "\n", with: "")
                handledValue = toJson(force)

//                }
               
                
            }
            
            else if(propertyName == "locationChatMessage") &&  String(describing: value) != "nil" {
                let force =  value
                handledValue = toJson(force)
            }
            
            else if(propertyName == "contactPhoneNumbers") &&  String(describing: value) != "nil" {
                print("contactPhoneNumbers-----")
//                print(value)
                
            }
            else if (propertyName == "contactChatMessage") &&  String(describing: value) != "nil" {
               // let refined = String(describing: value).replacingOccurrences(of: "some", with: "")
            
                let force =  value
                print("contactChatMessage block")
//                print(force)
                handledValue = toJson(force)
                print("handledValue-----")
//                print(handledValue)
                
            }
        
            else if (propertyName == "replyParentChatMessage" && String(describing: value) != "nil"){
                let force = value
                handledValue = toJson(force)
            }
            else if property.displayStyle == Mirror.DisplayStyle.optional {
                let str = String(describing: value)
                if str != "nil" {
                    // Some optional values cannot be unpacked if type is "Any"
                    // We remove the "Optional(" and last ")" from the value by string manipulation
                    var d = String(str).dropFirst(9)
                    d = d.dropLast(1)
//                    handledValue = String(d)
                    handledValue =  "\"\(d)\""
                    handledValue = handledValue.replacingOccurrences(of: "\"\"", with: "\"")
                } else {
                    handledValue = "null"
                }
            }
            else {
               
                    handledValue = String(describing: value) != "nil" ? "\"\(value)\"" : "null"
                
            }
            if (propertyName == "mediaChatMessage" || propertyName == "locationChatMessage") &&  String(describing: value) != "nil" {
//                print(handledValue)
            }
           
            
           if !skip {
                
                // if optional propertyName is populated we'll use it
                if let propertyName = propertyName {
                    json += "\"\(propertyName)\": \(handledValue)" + (index < size-1 ? ", " : "")
                }
                // if not then we have a member an array
                else {
                    // if it's the first member we need to prepend ]
                    if first {
                        json += "["
                        first = false
                    }
                    // if it's not the last we need a comma. if it is the last we need to close ]
                    json += "\(handledValue)" + (index < size-1 ? ", " : "]")
                }
                
            } else {
                json = "\(handledValue)" + (index < size-1 ? ", " : "")
            }
            if (propertyName == "mediaChatMessage" || propertyName == "locationChatMessage") &&  String(describing: value) != "nil" {
//                print(json)
            }
            index += 1
        }
        
        if !skip  {
            if (!(object is Array<Any>)) {
                json += "}"
            }
        }
        
        if prettify {
           let jsonData = json.data(using: String.Encoding.utf8)!
           let jsonObject = try! JSONSerialization.jsonObject(with: jsonData, options: [])
           let prettyJsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
           json = NSString(data: prettyJsonData, encoding: String.Encoding.utf8.rawValue)! as String
        }
        
        return json
    }
    
}
extension String{
    func utf8EncodedString()-> String {
            let messageData = self.data(using: .nonLossyASCII)
            let text = String(data: messageData!, encoding: .utf8) ?? ""
            return text
        }
}
