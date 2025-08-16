import 'dart:convert';

/// Parses a JSON string into an [UpdateTokenResponse] object.
///
/// [str]: The JSON string to parse.
/// Returns an [UpdateTokenResponse] instance.
UpdateTokenResponse updateTokenResponseFromJson(String str) =>
    UpdateTokenResponse.fromJson(json.decode(str));

/// Converts an [UpdateTokenResponse] object to a JSON string.
///
/// [data]: The [UpdateTokenResponse] object to be converted.
/// Returns a JSON string.
String updateTokenResponseToJson(UpdateTokenResponse data) =>
    json.encode(data.toJson());

/// Converts a nullable JSON string into a JSON string representation of an [UpdateTokenResponse],
/// or returns an empty string if null or empty.
///
/// [str]: The nullable JSON string to convert.
/// Returns a JSON string representation of the [UpdateTokenResponse] if [str] is valid;
/// otherwise, an empty string.
String convertTokenResponseToJson(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : updateTokenResponseToJson(updateTokenResponseFromJson(str));

/// Model class representing the updated tokens from the server.
class UpdateTokenResponse {
  /// Updated FCM or device push token.
  String? updatedDeviceToken;

  /// Updated VOIP push token.
  String? updatedVoipToken;

  UpdateTokenResponse({
    this.updatedDeviceToken,
    this.updatedVoipToken,
  });

  /// Creates an [UpdateTokenResponse] from a JSON map.
  factory UpdateTokenResponse.fromJson(Map<String, dynamic> json) =>
      UpdateTokenResponse(
        updatedDeviceToken: json["updatedDeviceToken"],
        updatedVoipToken: json["updatedVOIPToken"],
      );

  /// Converts the [UpdateTokenResponse] instance to a JSON map.
  Map<String, dynamic> toJson() => {
    "updatedDeviceToken": updatedDeviceToken,
    "updatedVOIPToken": updatedVoipToken,
  };
}
