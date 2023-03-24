
///Used as a Builder class for [FlyChat]
///
/// @property apiKey for the SDK
/// @property enableMobileNumberLogin to enable login via mobile number
/// @property isTrialLicenceKey to provide trial/live register and contact sync
/// @property domainBaseUrl provides the base url for making api calls
/// @property storageFolderName provides the Local Storage Folder Name
/// @property iOSContainerID provides the App Group of the iOS Project
/// * @property licenseKey provides the License Key
/// @property groupConfig provides the data required for group implementation
class ChatBuilder {
  ChatBuilder({
    required this.domainBaseUrl,
    this.storageFolderName,
    required this.iOSContainerID,
    required this.licenseKey,
    this.enableMobileNumberLogin = false,
    this.isTrialLicenceKey = true,
    this.maximumRecentChatPin,
    this.groupConfig,
    // bool useProfileName = false,
    this.ivKey,
    this.enableSDKLog = false
  });

  String domainBaseUrl;
  String? storageFolderName;
  String iOSContainerID;
  String licenseKey;
  bool enableMobileNumberLogin;
  bool isTrialLicenceKey;
  int? maximumRecentChatPin;
  GroupConfig? groupConfig;
  // bool useProfileName = true;
  String? ivKey;
  bool enableSDKLog;
}
class GroupConfig {
  GroupConfig({
    required this.enableGroup,
    required this.maxMembersCount,
    this.adminOnlyAddRemoveAccess = true
  });
  bool enableGroup;
  int maxMembersCount;
  bool adminOnlyAddRemoveAccess;
}

extension BuilderParsing on ChatBuilder{
  Map build(){
    return {
      "domainBaseUrl":domainBaseUrl,
      "storageFolderName":storageFolderName,
      "iOSContainerID":iOSContainerID,
      "licenseKey":licenseKey,
      "enableMobileNumberLogin":enableMobileNumberLogin,
      "isTrialLicenceKey":isTrialLicenceKey,
      "maximumRecentChatPin":maximumRecentChatPin,
      "groupConfig":groupConfig.build(),
      // "useProfileName":useProfileName,
      "ivKey":ivKey,
      "enableSDKLog":enableSDKLog,
    };
  }
}

extension GroupConfigParsing on GroupConfig?{
  Map? build(){
    if(this!=null){
      return {
        "enableGroup":this!.enableGroup,
        "maxMembersCount":this!.maxMembersCount,
        "adminOnlyAddRemoveAccess":this!.adminOnlyAddRemoveAccess
      };
    }
    else {
      return null;
    }
  }
}