// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

import 'package:mirrorfly_plugin/model/user_list_model.dart';

/// Converts a JSON string into a list of [ProfileDetails] objects.
///
/// This function decodes the given JSON string and uses the [fromJson] constructor
/// of the [ProfileDetails] class to create a list of instances.
///
/// Parameters:
///   [str] - A JSON string representation of a list of [ProfileDetails] objects.
///
/// Returns:
///   A list of [ProfileDetails] instances populated with data from the given JSON string.
List<ProfileDetails> memberFromJson(String str) => List<ProfileDetails>.from(
    json.decode(str).map((x) => ProfileDetails.fromJson(x)));

/// Converts a list of [ProfileDetails] objects into a JSON string.
///
/// This function takes a list of [ProfileDetails] objects, converts each into a map
/// using the [toJson] method, and then encodes this list of maps as a JSON string.
///
/// Parameters:
///   [data] - The list of [ProfileDetails] objects to be converted into a JSON string.
///
/// Returns:
///   A JSON string representation of the list of [ProfileDetails] objects.
String memberToJson(List<ProfileDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
