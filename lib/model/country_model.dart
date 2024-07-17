// To parse this JSON data, do
//
//     final countryData = countryDataFromJson(jsonString);

import 'dart:convert';

/// Converts a JSON string into a list of [CountryData] objects.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [CountryData] class to create a list of instances.
///
/// Parameters:
///   [str] - A JSON string representation of a list of [CountryData] objects.
///
/// Returns:
///   A list of [CountryData] instances populated with data from the given JSON string.
List<CountryData> countryDataFromJson(String str) => List<CountryData>.from(
    json.decode(str).map((x) => CountryData.fromJson(x)));

/// Converts a list of [CountryData] objects into a JSON string.
///
/// This function takes a list of [CountryData] objects, converts each into a map
/// using the [toJson] method, and then encodes this list of maps as a JSON string.
///
/// Parameters:
///   [data] - The list of [CountryData] objects to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the list of [CountryData] objects.
String countryDataToJson(List<CountryData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// Provides functionality to parse and convert country data from and to JSON.
///
/// This file contains the [CountryData] class which is used to model country data,
/// including the country's name, dial code, and code. It provides methods to parse
/// a JSON string into a list of [CountryData] instances and to convert a list of
/// [CountryData] instances back into a JSON string.
///
class CountryData {
  /// Constructs a [CountryData] instance with the given [name], [dialCode], and [code].
  ///
  /// Parameters:
  ///   - `name`: The name of the country.
  ///   - `dialCode`: The dial code of the country.
  ///   - `code`: The ISO code of the country.
  CountryData({
    required this.name,
    required this.dialCode,
    required this.code,
  });

  /// The name of the country.
  String? name;

  /// The dial code of the country.
  String? dialCode;

  /// The ISO code of the country.
  String? code;

  /// Converts a JSON object into a [CountryData] instance.
  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        name: json["name"],
        dialCode: json["dial_code"],
        code: json["code"],
      );

  /// Converts a [CountryData] instance into a JSON object.
  Map<String, dynamic> toJson() => {
        "name": name,
        "dial_code": dialCode,
        "code": code,
      };
}
