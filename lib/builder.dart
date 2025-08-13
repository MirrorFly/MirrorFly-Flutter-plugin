/// Initializes a new instance of the `ChatBuilder` class.
///
/// @param domainBaseUrl The base URL for making API calls.
/// @param storageFolderName The name of the local storage folder (optional).
/// @param iOSContainerID The ID of the iOS container.
/// @param licenseKey The license key for authentication.
/// @param enableMobileNumberLogin Determines if login via mobile number is enabled (default is false).
/// @param isTrialLicenceKey Indicates if the provided license key is a trial key (default is true).
/// @param chatHistoryEnable Determines if chat history should be enabled (optional).
/// @param enableDebugLog Determines if debug logging is enabled (default is false).
class ChatBuilder {
  /// A builder class for creating chat configurations.
  ///
  /// This class allows for the configuration of various chat-related settings,
  /// including the base URL for API calls, storage options, and authentication details.
  /// It supports enabling or disabling features such as mobile number login, chat history,
  /// and debug logging.
  ChatBuilder(
      {required this.domainBaseUrl,
      this.storageFolderName = "Mirrorfly Flutter",
      required this.iOSContainerID,
      required this.licenseKey,
      this.enableMobileNumberLogin = false,
      this.isTrialLicenceKey = true,
      this.chatHistoryEnable = true,
      // this.maximumRecentChatPin,
      // this.groupConfig,
      // bool useProfileName = false,
      // this.ivKey,
      this.enableDebugLog = false,
      this.enableAndroidCallKitUI = true});

  /// The base URL for making API calls.
  String domainBaseUrl;

  /// The name of the local storage folder. Optional.
  String storageFolderName;

  /// The ID of the App Groups container. Required for iOS platforms.
  String iOSContainerID;

  /// The license key for authentication.
  String licenseKey;

  /// Determines if login via mobile number is enabled. Defaults to false.
  bool enableMobileNumberLogin;

  /// Indicates if the provided license key is a trial key. Defaults to true.
  bool isTrialLicenceKey;

  /// Determines if chat history should be enabled. Optional.
  bool chatHistoryEnable;

  // int? maximumRecentChatPin;
  // GroupConfig? groupConfig;
  // bool useProfileName = true;
  // String? ivKey;

  /// Determines if debug logging is enabled. Defaults to false.
  bool enableDebugLog;

  /// Determines whether the Android CallKit UI is enabled. Defaults to true.
  /// If set to false, incoming calls will not trigger the call UI.
  /// Instead, you will receive an event through the `onIncomingCallReceived` stream.
  @Deprecated("Instead of use Mirrorfly.configureAndroidCallKit()")
  bool? enableAndroidCallKitUI;
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
  /// Allows customization of group chat features, including enabling group creation,
  /// setting a maximum number of members, and specifying admin-only permissions for
  /// adding or removing members.
  ///
  /// @param enableGroupCreation Determines whether group creation is enabled.
  /// @param maxMembersCount Specifies the maximum number of members allowed in a group.
  /// @param adminOnlyAddRemoveAccess Determines if only admins can add or remove members, defaults to true.
  GroupConfig(
      {required this.enableGroupCreation,
      required this.maxMembersCount,
      this.adminOnlyAddRemoveAccess = true});

  /// Determines whether users can create new groups.
  ///
  /// When set to `true`, users have the ability to create groups. Defaults to `false` to restrict
  /// group creation to administrators or through server-side configuration.
  bool enableGroupCreation;

  /// Specifies the maximum number of members allowed in a group.
  ///
  /// This limit helps in managing group sizes and ensuring that groups do not exceed
  /// a manageable number of participants.
  int maxMembersCount;

  /// Controls whether only group admins can add or remove members.
  ///
  /// If `true`, only administrators have the permissions to modify the group's membership.
  /// This can be useful for maintaining control over group composition and preventing spam.
  bool adminOnlyAddRemoveAccess;
}

/// `BuilderParsing` is an extension on `ChatBuilder` that provides a method to build a map
/// from the properties of a `ChatBuilder` instance.
///
/// The map can be used to easily access the properties of the `ChatBuilder` instance.
extension BuilderParsing on ChatBuilder {
  /// Builds a map from the properties of a `ChatBuilder` instance.
  ///
  /// This method converts the configuration settings of a chat builder into a map,
  /// making it easier to access and manipulate the chat configuration settings.
  ///
  /// @return A map representing the configuration of the chat builder.
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
      "enableAndroidCallKitUI": enableAndroidCallKitUI,
    };
  }
}

/// `GroupConfigParsing` is an extension on `GroupConfig` that provides a method to build a map
/// from the properties of a `GroupConfig` instance.
///
/// The map can be used to easily access the properties of the `GroupConfig` instance.
///
extension GroupConfigParsing on GroupConfig? {
  /// Builds a map representation of the `GroupConfig` instance.
  ///
  /// This method converts the group configuration settings into a map,
  /// facilitating easier access and manipulation of group configuration settings.
  ///
  /// @return A map representing the group configuration settings, or null if the instance is null.
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
  /// This constructor allows for the configuration of the SDK initialization process,
  /// including specifying storage options, authentication details, and various feature toggles.
  InitializeSDKBuilder(
      {this.storageFolderName,
      required this.iOSContainerID,
      required this.licenseKey,
      this.enableMobileNumberLogin = false,
      this.chatHistoryEnable,
      this.enableDebugLog = false,
      this.enablePrivateStorage = false,
      this.enableAndroidCallKitUI = true});

  /// The name of the local storage folder. Optional for Android platforms.
  String? storageFolderName;

  /// The ID of the iOS container. Required for iOS platforms.
  String iOSContainerID;

  /// The license key for authentication. Required.
  String licenseKey;

  /// Determines if login via mobile number is enabled. Defaults to false.
  bool enableMobileNumberLogin;

  /// Determines if chat history should be enabled. Defaults to false.
  bool? chatHistoryEnable;

  /// Determines if debug logging is enabled. Defaults to false.
  bool enableDebugLog;

  /// Determines if private storage is enabled. Defaults to false.
  bool enablePrivateStorage;

  /// Determines if default android incoming call ui is enabled. Defaults to true
  @Deprecated("Instead of use Mirrorfly.configureAndroidCallKit()")
  bool? enableAndroidCallKitUI;
}

/// `InitializeSDKBuilderParsing` is an extension on `InitializeSDKBuilder` that provides a method to build a map
/// from the properties of an `InitializeSDKBuilder` instance.
extension InitializeSDKBuilderParsing on InitializeSDKBuilder {
  /// Builds a map from the properties of an `InitializeSDKBuilder` instance.
  ///
  /// This method converts the configuration settings of the SDK initialization process into a map,
  /// facilitating easier access and manipulation of these settings. The map includes keys for
  /// storage folder name, iOS container ID, license key, mobile number login enablement,
  /// chat history enablement, debug log enablement, and private storage enablement.
  ///
  /// @return A map representing the configuration settings of the SDK initialization process.
  Map build() {
    return {
      "storageFolderName": storageFolderName,
      "iOSContainerID": iOSContainerID,
      "licenseKey": licenseKey,
      "enableMobileNumberLogin": enableMobileNumberLogin,
      "chatHistoryEnable": chatHistoryEnable,
      "enableDebugLog": enableDebugLog,
      "enablePrivateStorage": enablePrivateStorage,
      "enableAndroidCallKitUI": enableAndroidCallKitUI,
    };
  }
}
