class CallAction {
  static const String inviteUsers = "INVITE_USERS";
  static const String answerCall = "ANSWER_CALL";
  static const String denyCall = "DENY_CALL";
  static const String localHangup = "LOCAL_HANGUP";
  static const String remoteHangup = "REMOTE_HANGUP";
  static const String remoteOtherBusy = "REMOTE_OTHER_BUSY";
  static const String remoteBusy = "REMOTE_BUSY";
  static const String remoteEngaged = "REMOTE_ENGAGED";
  static const String callAgain = "CALL_AGAIN";
  static const String cancelCallAgain = "CANCEL_CALL_AGAIN";
  static const String switchCamera = "SWITCH_CAMERA";
  static const String remoteVideoStatus = "REMOTE_VIDEO_STATUS";
  static const String remoteVideoPaused = "REMOTE_VIDEO_PAUSED";
  static const String remoteVideoResumed = "REMOTE_VIDEO_RESUMED";
  static const String changeToAudioCall = "CHANGE_TO_AUDIO_CALL";
  static const String videoCallConversionCancel =
      "ACTION_VIDEO_CALL_CANCEL_CONVERSION";
  static const String videoCallConversionAccepted =
      "ACTION_VIDEO_CALL_CONVERSION_ACCEPTED";
  static const String videoCallConversionRejected =
      "ACTION_VIDEO_CALL_CONVERSION_REJECTED";
  static const String remoteVideoAdded = "REMOTE_VIDEO_ADDED";
  static const String audioDeviceChanged = "AUDIO_DEVICE_CHANGED";
  static const String cameraSwitchSuccess = "CAMERA_SWITCH_SUCCESS";
  static const String cameraSwitchFailure = "CAMERA_SWITCH_FAILURE";
  static const String permissionDenied = "PERMISSION_DENIED";
  static const String callRequestResponse = "CALL_REQUEST_RESPONSE";
  static const String userSpeaking = "USER_SPEAKING";
  static const String userStoppedSpeaking = "USER_STOPPED_SPEAKING";
  static const String makeServerConnection = "ACTION_MAKE_SERVER_CONNECTION";
  static const String closeServerConnection = "ACTION_CLOSE_SERVER_CONNECTION";
}

class MuteStatus {
  static const String remoteAudioUnMute = "REMOTE_AUDIO_UN_MUTE";
  static const String remoteAudioMute = "REMOTE_AUDIO_MUTE";
  static const String remoteVideoMute = "REMOTE_VIDEO_MUTE";
  static const String remoteVideoUnMute = "REMOTE_VIDEO_UN_MUTE";
}

class CallType {
  static const String audio = "audio";
  static const String video = "video";
  static const String oneToOne = "OneToOne";
  static const String groupCall = "GroupCall";
}

class AudioLevel {
  static const String audioTooLow = "audio_too_low";
  static const String audioLow = "audio_low";
  static const String audioMedium = "audio_medium";
  static const String audioHigh = "audio_high";
  static const String audioPeak = "audio_peak";
}
extension AudioLevelExtension on num {
  String getAudioLevel() {
    switch(this){
      case 1: return AudioLevel.audioTooLow;
      case 3: return AudioLevel.audioLow;
      case 4: return AudioLevel.audioMedium;
      case 5: return AudioLevel.audioHigh;
      default: return AudioLevel.audioPeak;
    }
  }
}
class CallStatus {
  static const String connecting = "Connecting";
  static const String ringing = "Ringing";
  static const String attended = "Attended";
  static const String connected = "Connected";
  static const String disconnected = "Disconnected";
  static const String onHold = "Call on hold";
  static const String onResume = "ON_RESUME";
  static const String userJoined = "User_Joined";
  static const String userLeft = "User_Left";
  static const String inviteCallTimeout = "Invite call timeout";
  static const String callTimeout = "CALL TIME OUT";
  static const String reconnecting = "Reconnecting";
  static const String reconnected = "Reconnected";
  static const String calling = "Trying to Connect";
  static const String calling10s = "Calling... \n Trying to Connect";
  static const String callingAfter10s =
      "User Seems to be Offline, Trying to Connect";
}

class AudioDeviceType {
  static const String none = "none";
  static const String receiver = "receiver";
  static const String speaker = "speaker";
  static const String headset = "headset";
  static const String bluetooth = "bluetooth";
}
