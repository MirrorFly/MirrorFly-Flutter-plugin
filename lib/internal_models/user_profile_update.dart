import 'dart:convert';

/// Converts a JSON string into a [ProfileUpdate] object.
///
/// This function decodes the provided JSON string into a map and then uses the [ProfileUpdate.fromJson]
/// constructor to create a [ProfileUpdate] object.
///
/// Parameters:
///   [str] - A JSON string representing a profile update.
///
/// Returns:
///   A [ProfileUpdate] object.
ProfileUpdate profileUpdateFromJson(String str) =>
    ProfileUpdate.fromJson(json.decode(str));

/// Converts a [ProfileUpdate] object into a JSON string.
///
/// This function takes a [ProfileUpdate] object, converts it to a map using the [toJson] method,
/// and then encodes the map as a JSON string.
///
/// Parameters:
///   [data] - A [ProfileUpdate] object.
///
/// Returns:
///   A JSON string representing the profile update.
String profileUpdateToJson(ProfileUpdate data) => json.encode(data.toJson());

/// Converts a JSON string into a JSON string representing a [ProfileUpdate] object.
///
/// This function checks if the provided string is null or empty. If it is, it returns an empty string.
/// Otherwise, it converts the string into a [ProfileUpdate] object using [profileUpdateFromJson],
/// and then back into a JSON string using [profileUpdateToJson].
///
/// Parameters:
///   [str] - A JSON string or null.
///
/// Returns:
///   A JSON string representing a [ProfileUpdate] object, or an empty string if the input is null or empty.
String convertProfileUpdateJsonFromString(String? str) =>
    (str == null || str.isEmpty)
        ? ""
        : profileUpdateToJson(profileUpdateFromJson(str));

/// Represents the update information for a user profile.
///
/// This class encapsulates the data related to a profile update, including the updated data,
/// a message, and the status of the update.
///
/// Properties:
///   [data] - The updated data for the profile as a [ProData] object.
///   [message] - A message related to the profile update.
///   [status] - The status of the profile update as a boolean.
///
/// Constructors:
///   [ProfileUpdate] - Initializes a new instance of the [ProfileUpdate] class with optional parameters for updated data,
///                     message, and status.
class ProfileUpdate {
  /// Initializes a new instance of the [ProfileUpdate] class.
  ProfileUpdate({
    this.data,
    this.message,
    this.status,
  });

  /// The updated data for the profile.
  ProData? data;

  /// A message related to the profile update.
  String? message;

  /// The status of the profile update.
  bool? status;

  /// Converts a map into a [ProfileUpdate] object.
  factory ProfileUpdate.fromJson(Map<String, dynamic> json) => ProfileUpdate(
        data: json["data"] == null ? null : ProData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  /// Converts a [ProfileUpdate] object into a map.
  Map<String, dynamic> toJson() => {
        "data": data ?? data?.toJson(),
        "message": message,
        "status": status,
      };
}

/// Represents the updated data for a user profile.
class ProData {
  /// Initializes a new instance of the [ProData] class.
  ProData({
    this.email,
    this.image,
    this.mobileNumber,
    this.name,
    this.nickName,
    this.status,
  });

  /// The email address of the user.
  String? email;

  /// The image of the user.
  String? image;

  /// The mobile number of the user.
  String? mobileNumber;

  /// The name of the user.
  String? name;

  /// The nickname of the user.
  String? nickName;

  /// The status of the user.
  String? status;

  /// Converts a map into a [ProData] object.
  factory ProData.fromJson(Map<String, dynamic> json) => ProData(
        email: json["email"],
        image: json["image"],
        mobileNumber: json["mobileNumber"],
        name: json["name"],
        nickName: json["nickName"],
        status: json["status"],
      );

  /// Converts a [ProData] object into a map.
  Map<String, dynamic> toJson() => {
        "email": email,
        "image": image,
        "mobileNumber": mobileNumber,
        "name": name,
        "nickName": nickName,
        "status": status,
      };
}
