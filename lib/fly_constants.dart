/// Defines error codes used within the MirrorFly SDK.
///
/// This class provides a centralized list of error codes that are used
/// throughout the MirrorFly to represent various error states.
class FlyErrorCode {
  /// Error code indicating an unhandled exception has occurred.
  static const unHandle = "401";
}

/// Defines error messages corresponding to the error codes in [FlyErrorCode].
///
/// This class maps error codes to human-readable error messages that can be
/// displayed to the user or used for debugging purposes.
class FlyErrorMessage {
  /// Error message for an unhandled exception.
  static const unHandle = "UnHandle Exception";
}

/// Contains constant values used throughout the FlyChat SDK.
///
/// This class provides a repository of constant values that are used in
/// various parts of the SDK, such as default values or special markers.
class FlyConstants {
  /// Represents an empty or uninitialized value.
  static const empty = "";
}