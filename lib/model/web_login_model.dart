import 'dart:convert';

/// Converts a JSON string into a list of [WebLogin] objects.
///
/// This function decodes the given JSON string and maps each JSON object
/// to a [WebLogin] instance using the [WebLogin.fromJson] constructor.
///
/// Parameters:
///   [str] - A JSON string representation of a list of [WebLogin] objects.
///
/// Returns:
///   A list of [WebLogin] instances populated with data from the given JSON string.
List<WebLogin> webLoginFromJson(String str) =>
    List<WebLogin>.from(json.decode(str).map((x) => WebLogin.fromJson(x)));

/// Converts a list of [WebLogin] objects into a JSON string.
///
/// This function takes a list of [WebLogin] objects, converts each object into a map
/// using the [toJson] method, and then encodes the list of maps as a JSON string.
///
/// Parameters:
///   [data] - The list of [WebLogin] objects to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the list of [WebLogin] objects.
String webLoginToJson(List<WebLogin> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Represents a web login instance.
///
/// This class holds the details of a web login, including the ID, last login time,
/// operating system name, unique QR token, and web browser name.
///
/// Parameters:
///   [id] - The unique identifier of the web login.
///   [lastLoginTime] - The last login time.
///   [osName] - The name of the operating system used for the login.
///   [qrUniqeToken] - A unique token associated with the QR code used for the login.
///   [webBrowserName] - The name of the web browser used for the login.
class WebLogin {
  /// Initializes a new instance of the [WebLogin] class.
  WebLogin({
    required this.id,
    required this.lastLoginTime,
    required this.osName,
    required this.qrUniqeToken,
    required this.webBrowserName,
  });

  /// The unique identifier of the web login.
  int id;

  /// The last login time.
  String lastLoginTime;

  /// The name of the operating system used for the login.
  String osName;

  /// A unique token associated with the QR code used for the login.
  String qrUniqeToken;

  /// The name of the web browser used for the login.
  String webBrowserName;

  /// Creates a [WebLogin] instance from a JSON map.
  ///
  /// This factory constructor is used to create an instance of [WebLogin]
  /// from a map structure representing JSON data. This is useful for
  /// deserializing JSON data retrieved from a database or an API.
  ///
  /// Parameters:
  ///   [json] - A map representing JSON data.
  ///
  /// Returns:
  ///   An instance of [WebLogin].
  factory WebLogin.fromJson(Map<String, dynamic> json) => WebLogin(
        id: json["id"],
        lastLoginTime: json["lastLoginTime"],
        osName: json["osName"],
        qrUniqeToken: json["qrUniqeToken"],
        webBrowserName: json["webBrowserName"],
      );

  /// Converts an instance of [WebLogin] to a JSON map.
  ///
  /// This method is used to serialize [WebLogin] instances into a map
  /// structure that can easily be converted to JSON. This is useful for
  /// storing the instance in a database or sending it over a network.
  ///
  /// Returns:
  ///   A map representing the serialized form of the [WebLogin] instance.
  Map<String, dynamic> toJson() => {
        "id": id,
        "lastLoginTime": lastLoginTime,
        "osName": osName,
        "qrUniqeToken": qrUniqeToken,
        "webBrowserName": webBrowserName,
      };
}
