//
//  MirrorFlyErrorCodes.swift
//  mirrorfly_plugin
//
//  Created by Mani Vendhan on 11/01/24.
//

import Foundation

class FLErrorCode {
    
    ///
    /// Reverted back to old code, waiting doe Android Error Codes to be done to match the exact same
    ///
    /// 807, 1000, 1009
    ///  Called When the method Channel gives Fialure Response
    public static let INVALID_DATA : String = "500"//"FL-422"
    
    ///
    /// This Error Code will be used for the below scenerios in SDK
    /// 804 -> Invalid Licence Key
    /// 799
    ///
    public static let INVALID_CREDENTAILS : String = "500" //FL-401"
    
    public static let INITALIZATION_FAILED : String = "500" //"FL-500"
    
    /// 803
    public static let FILE_DATA_NOT_AVAILABLE : String = "500" //"FL-404"
    public static let ARGUMENTS_EMPTY_OR_NULL : String = "500" //"FL-803"
    
    /// 405
    public static let MAX_LOGIN_REACHED : String = "405"//"FL-405"
    
    /// 403
    public static let FORBIDDEN_ACTION : String = "403"//"FL-403"
    
    /// 798
    public static let MISSING_PARAMS : String = "500" //"FL-400"
    
    /// 808
    public static let CANNOT_PROCESS : String = "500" //"FL-808"
    
    /// 800
    public static let INTERNET_UNAVAILABLE : String = "500" //"FL-503"
    
    /// 900
    public static let NOT_CONNECTED_TO_XMPP : String = "500" //"FL-900"
    
    /// 1000
    public static let UNEXPECTED : String = "500" //"FL-805"
    
    ///
    /// Called for Calls Common Errors
    ///
    public static let CALL_FAILED : String = "500" //"FL-423"
    
    /// PERMISSION_DENIED, PERMISSION_NOT_GRANTED
    public static let PERMISSION_NOT_GRANTED : String = "500" //"FL-785"
    
    
}

class FLErrorMessage {
    
    /// FL-401
    public static let INVALID_CREDENTAILS_MESSAGE : String = "SDK failed to Initialize"
    /// FL-404
    public static let FILE_DATA_NOT_AVAILABLE_MESSAGE : String = "File/Data Not Available or Invalid File"
    /// FL-405
    public static let MAX_LOGIN_REACHED_MESSAGE : String = "You have reached the maximum device limit, If you want to continue one of your device will logged out."
    /// FL-403
    public static let USER_BLOCKED_MESSAGE : String = "User Blocked"
    /// FL-400
    public static let METHOD_FETCH_FAILED : String = "Error while processing the request"
    
    
    ///
    /// General Error Messages in Chat
    ///
    public static let REGISTRATION_FAILED_MESSAGE : String = "Error while Registering the User"
    public static let AUTHTOKEN_REFRESH_FAILED_MESSAGE : String = "Error while refreshing Auth Token"
    public static let JID_FETCH_FAILED : String = "Error while fetching JID"
    public static let USER_PARAM_MISSING : String = "User Name is Empty"
    public static let PARAMS_MISSING : String = "Required parameters Missing/Invalid"
    public static let MESSAGE_SENDING_FAILED : String = "Error while sending message"
    public static let MESSAGE_EDITING_FAILED : String = "Error while editing message"
    public static let CAPTION_EDITING_FAILED : String = "Error while editing caption text"
    public static let COMPRESSION_FAILED : String = "Error while compressing media file"
    public static let SDK_INITIALISATION_ERROR : String = "Error while Initialising SDK"
    public static let INVALID_LICENSE_KEY : String = "Invalid License Key"
    public static let INVALID_JID : String = "Invalid JID"
    public static let INTERNET_UNAVAILABLE : String = "Seems to be a problem in Network Connectivity"
    public static let FEATURE_NOT_AVAILABLE : String = "Feature unavailable"
    public static let DOWNLOAD_FAILED : String = "Download Failed"
    public static let AUTHTOKEN_EXPIRED : String = "Invalid Auth Token"
    public static let MESSAGE_DELETE_FAILED : String = "Error while Deleting Message"
    public static let MESSAGES_DELETE_FAILED : String = "Error while Deleting Messages"
    public static let GROUP_JID_FETCH_FAILED : String = "Error while fetching Group JID"
    public static let RECENT_CHAT_DELETE_FAILED : String = "Error while deleting recent chats"
    public static let NOT_CONNECTED_TO_XMPP_MESSAGE : String = "XMPP not connected"
    public static let MISSING_ARGUMENTS : String = "Required arguments missing"
    public static let JSON_PARSING_ERROR : String = "Error while parsing the response"
    public static let MESSAGE_QUERY_EMPTY : String = "Message List not initialized. Please initialize it using the initializeMessageList() method"
    public static let MESSAGE_QUERY_PROCESSING : String = "Fetching Query is already in Progress"
    public static let CREATE_TOPIC_FAILED : String = "Error while creating Topic"
    public static let FETCH_TOPIC_FAILED : String = "Error while fetching Topic List"
    public static let INVALID_LOCATION : String = "Invalid Location"
    public static let UNFAVOURITE_MESSAGE_FAILED : String = "Error while unFavourite Messages"
    public static let QR_LOGIN_FAILED : String = "Error while processing QR login"
    public static let CONTACT_US_FAILED_MESSAGE : String = "Error while submitting the reponse, Please try after sometime"
    
    
    
    /// General Error Messages in Calls
    public static let MICROPHONE_PERMISSION_NOT_ENABLED : String = "Microphone Permission is not enabled"
    public static let CAMERA_PERMISSION_NOT_ENABLED : String = "Camera Permission is not enabled"
    public static let CALL_FAILED_MESSAGE : String = "Error while making the call"
    public static let INVITE_FAILED_MESSAGE : String = "Error while inviting users"
    public static let SWITCH_FAILED_MESSAGE : String = "Error while switching call"
    
    
}
