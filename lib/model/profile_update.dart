import 'dart:convert';

/// Converts a JSON string into a [ProfileUpdate] object.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [ProfileUpdate] class to create an instance.
///
/// Parameters:
///   [str] - A JSON string representation of a [ProfileUpdate] object.
///
/// Returns:
///   An instance of [ProfileUpdate] populated with data from the given JSON string.
ProfileUpdate profileUpdateFromJson(String str) =>
    ProfileUpdate.fromJson(json.decode(str));

/// Converts a [ProfileUpdate] object into a JSON string.
///
/// This function takes a [ProfileUpdate] object, converts it into a map
/// using the [toJson] method, and then encodes this map as a JSON string.
///
/// Parameters:
///   [data] - The [ProfileUpdate] object to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the [ProfileUpdate] object.
String profileUpdateToJson(ProfileUpdate data) => json.encode(data.toJson());

/// Represents the profile update data.
class ProfileUpdate {
  /// Initializes a new instance of the [ProfileUpdate] class.
  ProfileUpdate({
    this.data,
    this.message,
    this.status,
  });

  /// The profile update data.
  ProData? data;

  /// The success/ error message.
  String? message;

  /// The status of the profile update.
  bool? status;

  /// Converts a JSON object into a [ProfileUpdate] instance.
  factory ProfileUpdate.fromJson(Map<String, dynamic> json) => ProfileUpdate(
        data: json["data"] == null ? null : ProData.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  /// Converts a [ProfileUpdate] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "data": data ?? data?.toJson(),
        "message": message,
        "status": status,
      };
}

/// Represents the profile data.
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

  /// The email of the user.
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

  /// Converts a JSON object into a [ProData] instance.
  factory ProData.fromJson(Map<String, dynamic> json) => ProData(
        email: json["email"],
        image: json["image"],
        mobileNumber: json["mobileNumber"],
        name: json["name"],
        nickName: json["nickName"],
        status: json["status"],
      );

  /// Converts a [ProData] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "email": email,
        "image": image,
        "mobileNumber": mobileNumber,
        "name": name,
        "nickName": nickName,
        "status": status,
      };
}
