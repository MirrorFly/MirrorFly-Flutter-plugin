/// Defines various call actions that can be performed during a call session.
///
/// This class holds constants for different types of call actions such as inviting users, answering a call,
/// denying a call, hanging up, and more. These actions are used to control the flow and state of calls
/// within the application.
///
class CallAction {

  /// Represents an action to invite users to a call.
  static const String inviteUsers = "INVITE_USERS";

  /// Represents an action to answer a call.
  static const String answerCall = "ANSWER_CALL";

  /// Represents an action to deny a call.
  static const String denyCall = "DENY_CALL";

  /// Represents an action to hang up a call.
  static const String localHangup = "LOCAL_HANGUP";

  /// Represents an action to hang up a call remotely.
  static const String remoteHangup = "REMOTE_HANGUP";

  /// Represents an action to cancel a call.
  static const String remoteOtherBusy = "REMOTE_OTHER_BUSY";

  /// Represents an action to cancel a call.
  static const String remoteBusy = "REMOTE_BUSY";

  /// Represents an action to cancel a call.
  static const String remoteEngaged = "REMOTE_ENGAGED";

  /// Represents an action to cancel a call.
  static const String callAgain = "CALL_AGAIN";

  /// Represents an action to cancel a call.
  static const String cancelCallAgain = "CANCEL_CALL_AGAIN";

  /// Represents an action to cancel a call.
  static const String switchCamera = "SWITCH_CAMERA";

  /// Represents an action to cancel a call.
  static const String remoteVideoStatus = "REMOTE_VIDEO_STATUS";

  /// Represents an action to cancel a call.
  static const String remoteVideoPaused = "REMOTE_VIDEO_PAUSED";

  /// Represents an action to cancel a call.
  static const String remoteVideoResumed = "REMOTE_VIDEO_RESUMED";

  /// Represents an action to cancel a call.
  static const String changedToAudioCall = "CHANGE_TO_AUDIO_CALL";

  /// Represents an action to cancel a call.
  static const String videoCallConversionCancel =
      "ACTION_VIDEO_CALL_CANCEL_CONVERSION";

  /// Represents an action to cancel a call.
  static const String videoCallConversionAccepted =
      "ACTION_VIDEO_CALL_CONVERSION_ACCEPTED";

  /// Represents an action to cancel a call.
  static const String videoCallConversionRejected =
      "ACTION_VIDEO_CALL_CONVERSION_REJECTED";

  /// Represents an action to cancel a call.
  static const String videoCallConversionRequest =
      "ACTION_VIDEO_CALL_CONVERSION";

  /// Represents an action to cancel a call.
  static const String remoteVideoAdded = "REMOTE_VIDEO_ADDED";

  /// Represents an action to cancel a call.
  static const String audioDeviceChanged = "AUDIO_DEVICE_CHANGED";

  /// Represents an action to cancel a call.
  static const String cameraSwitchSuccess = "CAMERA_SWITCH_SUCCESS";

  /// Represents an action to cancel a call.
  static const String cameraSwitchFailure = "CAMERA_SWITCH_FAILURE";

  /// Represents an action to cancel a call.
  static const String permissionDenied = "PERMISSION_DENIED";

  /// Represents an action to cancel a call.
  static const String callRequestResponse = "CALL_REQUEST_RESPONSE";

  /// Represents an action to cancel a call.
  static const String userSpeaking = "USER_SPEAKING";

  /// Represents an action to cancel a call.
  static const String userStoppedSpeaking = "USER_STOPPED_SPEAKING";

  /// Represents an action to cancel a call.
  static const String makeServerConnection = "ACTION_MAKE_SERVER_CONNECTION";

  /// Represents an action to cancel a call.
  static const String closeServerConnection = "ACTION_CLOSE_SERVER_CONNECTION";
}

/// Represents the mute status for audio and video during a call.
///
/// This class holds constants to represent the various mute statuses that can occur for both audio and video streams
/// in a call. These statuses are used to control and indicate the mute state of the remote participant's audio and video.
///
class MuteStatus {

  /// Represents the status when the local participant's audio is un muted.
  static const String localAudioUnMute = "LOCAL_AUDIO_UN_MUTE";

  /// Represents the status when the local participant's audio is muted.
  static const String localAudioMute = "LOCAL_AUDIO_MUTE";

  /// Represents the status when the local participant's video is un muted.
  static const String localVideoMute = "LOCAL_VIDEO_MUTE";

  /// Represents the status when the local participant's video is muted.
  static const String localVideoUnMute = "LOCAL_VIDEO_UN_MUTE";

  /// Represents the status when the remote participant's audio is un muted.
  static const String remoteAudioUnMute = "REMOTE_AUDIO_UN_MUTE";

  /// Represents the status when the remote participant's audio is muted.
  static const String remoteAudioMute = "REMOTE_AUDIO_MUTE";

  /// Represents the status when the remote participant's video is un muted.
  static const String remoteVideoMute = "REMOTE_VIDEO_MUTE";

  /// Represents the status when the remote participant's video is muted.
  static const String remoteVideoUnMute = "REMOTE_VIDEO_UN_MUTE";
}

/// Represents the call type for a call session.
class CallType {
  /// Represents an audio call.
  static const String audio = "audio";

  /// Represents a video call.
  static const String video = "video";
}

/// Represents the call mode for a call session.
class CallMode {
  /// Represents a one-to-one call.
  static const String oneToOne = "onetoone";

  /// Represents a group call.
  static const String groupCall = "onetomany";
}

/// Represents the call state for a call session.
class AudioLevel {

  /// Represents the audio level when the audio is too low.
  static const String audioTooLow = "audio_too_low";

  /// Represents the audio level when the audio is low.
  static const String audioLow = "audio_low";

  /// Represents the audio level when the audio is medium.
  static const String audioMedium = "audio_medium";

  /// Represents the audio level when the audio is high.
  static const String audioHigh = "audio_high";

  /// Represents the audio level when the audio is at its peak.
  static const String audioPeak = "audio_peak";
}

/// Extension on [num] to determine audio level descriptions.
///
/// This extension provides a method [getAudioLevel] on [num] instances to return a string representation
/// of the audio level based on the numeric value. It utilizes the [AudioLevel] class constants to match
/// the numeric value to a specific audio level description.
///
/// Returns:
///   A string representing the audio level. It matches the numeric value to one of the predefined audio levels
///   in the [AudioLevel] class, such as "audio_too_low", "audio_low", "audio_medium", "audio_high", or "audio_peak".
///   If the numeric value does not match any case, it defaults to "audio_too_low".
extension AudioLevelExtension on num {

  /// Returns the audio level description based on the numeric value.
  String getAudioLevel() {
    switch (this) {
      case 1:
        return AudioLevel.audioTooLow;
      case 2:
        return AudioLevel.audioLow;
      case 3:
        return AudioLevel.audioMedium;
      case 4:
        return AudioLevel.audioHigh;
      case 5:
        return AudioLevel.audioPeak;
      default:
        return AudioLevel.audioTooLow;
    }
  }
}

/// Represents the call state for a call session.
class CallStatus {

  /// Represents the call state when the call is connecting.
  static const String connecting = "Connecting";

  /// Represents the call state when the call is ringing.
  static const String ringing = "Ringing";

  /// Represents the call state when the call is in progress.
  static const String attended = "Attended";

  /// Represents the call state when the call is on hold.
  static const String connected = "Connected";

  /// Represents the call state when the call is disconnected.
  static const String disconnected = "Disconnected";

  /// Represents the call state when the call is on hold.
  static const String onHold = "Call on hold";

  /// Represents the call state when the call is in progress.
  static const String onResume = "ON_RESUME";

  /// Represents the call state when the call is on hold.
  static const String userJoined = "User_Joined";

  /// Represents the call state when the call is in progress.
  static const String userLeft = "User_Left";

  /// Represents the call state when the call is on hold.
  static const String inviteCallTimeout = "Invite call timeout";

  /// Represents the call state when the call is in progress.
  static const String callTimeout = "CALL TIME OUT";

  /// Represents the call state when the call is on hold.
  static const String reconnecting = "Reconnecting";

  /// Represents the call state when the call is in progress.
  static const String reconnected = "Reconnected";

  /// Represents the call state when the call is on hold.
  static const String calling = "Trying to Connect";

  /// Represents the call state when the call is in progress.
  static const String calling10s = "Calling... \n Trying to Connect";

  /// Represents the call state when the call is on hold.
  static const String callingAfter10s =
      "User Seems to be Offline, Trying to Connect";

  /// Represents the call state when the call is in progress.
  static const String callFailed = "Call_Failed";
}

/// Represents the call state for a call session.
class AudioDeviceType {

  /// Represents the audio device type when no audio device is connected.
  static const String none = "none";

  /// Represents the audio device type when the audio device is the receiver.
  static const String receiver = "receiver";

  /// Represents the audio device type when the audio device is the speaker.
  static const String speaker = "speaker";

  /// Represents the audio device type when the audio device is the headset.
  static const String headset = "headset";

  /// Represents the audio device type when the audio device is the bluetooth.
  static const String bluetooth = "bluetooth";
}

/// Represents the call state for a call session.
class CallState {

  /// Represents the call state when the call is connecting.
  static const int missedCall = 0;

  /// Represents the call state when the call is ringing.
  static const int outgoingCall = 1;

  /// Represents the call state when the call is in progress.
  static const int incomingCall = 2;
}

/// Represents the call state for a call session.
class CallDirection {

  /// Represents the call direction when the call is outgoing.
  static const String outgoing = "Outgoing";

  /// Represents the call direction when the call is incoming.
  static const String incoming = "Incoming";
}
