/// `ChatBuilder` is a class used to build a chat configuration.
///
/// @property domainBaseUrl The base URL for making API calls.
/// @property storageFolderName The name of the local storage folder.
/// @property iOSContainerID The ID of the iOS container.
/// @property licenseKey The license key.
/// @property enableMobileNumberLogin A flag to enable login via mobile number.
/// @property isTrialLicenceKey A flag to indicate whether the license key is a trial key.
/// @property chatHistoryEnable A flag to enable chat history.
/// @property enableDebugLog A flag to enable debug logging.
class ChatBuilder {
  ChatBuilder(
      {required this.domainBaseUrl,
      this.storageFolderName,
      required this.iOSContainerID,
      required this.licenseKey,
      this.enableMobileNumberLogin = false,
      this.isTrialLicenceKey = true,
      this.chatHistoryEnable,
      // this.maximumRecentChatPin,
      // this.groupConfig,
      // bool useProfileName = false,
      // this.ivKey,
      this.enableDebugLog = false});

  String domainBaseUrl;
  String? storageFolderName;
  String iOSContainerID;
  String licenseKey;
  bool enableMobileNumberLogin;
  bool isTrialLicenceKey;
  bool? chatHistoryEnable;

  // int? maximumRecentChatPin;
  // GroupConfig? groupConfig;
  // bool useProfileName = true;
  // String? ivKey;
  bool enableDebugLog;
}

/// `GroupConfig` is a class used to configure group chat functionality.
///
/// These properties include flags to enable group creation and admin-only add/remove access,
/// and a property to set the maximum number of members in a group.
///
/// @property enableGroupCreation A flag to enable group creation.
/// @property maxMembersCount The maximum number of members in a group.
/// @property adminOnlyAddRemoveAccess A flag to enable admin-only add/remove access.
class GroupConfig {
  GroupConfig(
      {required this.enableGroupCreation,
      required this.maxMembersCount,
      this.adminOnlyAddRemoveAccess = true});

  bool enableGroupCreation;
  int maxMembersCount;
  bool adminOnlyAddRemoveAccess;
}

/// `BuilderParsing` is an extension on `ChatBuilder` that provides a method to build a map
/// from the properties of a `ChatBuilder` instance.
///
/// The map can be used to easily access the properties of the `ChatBuilder` instance.
extension BuilderParsing on ChatBuilder {
  Map build() {
    return {
      "domainBaseUrl": domainBaseUrl,
      "storageFolderName": storageFolderName,
      "iOSContainerID": iOSContainerID,
      "licenseKey": licenseKey,
      "enableMobileNumberLogin": enableMobileNumberLogin,
      "isTrialLicenceKey": isTrialLicenceKey,
      "chatHistoryEnable": chatHistoryEnable,
      // "maximumRecentChatPin":maximumRecentChatPin,
      // "groupConfig":groupConfig.build(),
      // "useProfileName":useProfileName,
      // "ivKey":ivKey,
      "enableDebugLog": enableDebugLog,
    };
  }
}

/// `GroupConfigParsing` is an extension on `GroupConfig` that provides a method to build a map
/// from the properties of a `GroupConfig` instance.
///
/// The map can be used to easily access the properties of the `GroupConfig` instance.
///
extension GroupConfigParsing on GroupConfig? {
  Map? build() {
    if (this != null) {
      return {
        "enableGroup": this!.enableGroupCreation,
        "maxMembersCount": this!.maxMembersCount,
        "adminOnlyAddRemoveAccess": this!.adminOnlyAddRemoveAccess
      };
    } else {
      return null;
    }
  }
}

/// `InitializeSDKBuilder` is a class used to build a configuration for initializing the SDK.
///
/// @property storageFolderName The name of the local storage folder.
/// @property iOSContainerID The ID of the iOS container.
/// @property licenseKey The license key.
/// @property enableMobileNumberLogin A flag to enable login via mobile number.
/// @property chatHistoryEnable A flag to enable chat history.
/// @property enableDebugLog A flag to enable debug logging.
/// @property enablePrivateStorage A flag to enable private Storage.

class InitializeSDKBuilder {
  InitializeSDKBuilder({
    this.storageFolderName,
    required this.iOSContainerID,
    required this.licenseKey,
    this.enableMobileNumberLogin = false,
    this.chatHistoryEnable,
    this.enableDebugLog = false,
    this.enablePrivateStorage = false,
  });

  String? storageFolderName;
  String iOSContainerID;
  String licenseKey;
  bool enableMobileNumberLogin;
  bool? chatHistoryEnable;
  bool enableDebugLog;
  bool enablePrivateStorage;
}

/// `InitializeSDKBuilderParsing` is an extension on `InitializeSDKBuilder` that provides a method
/// to build a map from the properties of an `InitializeSDKBuilder` instance.
///
/// The map can be used to easily access the properties of the `InitializeSDKBuilder` instance.

extension InitializeSDKBuilderParsing on InitializeSDKBuilder {
  Map build() {
    return {
      "storageFolderName": storageFolderName,
      "iOSContainerID": iOSContainerID,
      "licenseKey": licenseKey,
      "enableMobileNumberLogin": enableMobileNumberLogin,
      "chatHistoryEnable": chatHistoryEnable,
      "enableDebugLog": enableDebugLog,
      "enablePrivateStorage": enablePrivateStorage,
    };
  }
}
