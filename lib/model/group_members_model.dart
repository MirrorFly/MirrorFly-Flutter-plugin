// To parse this JSON data, do
//
//     final member = memberFromJson(jsonString);

import 'dart:convert';

import 'package:mirrorfly_plugin/model/user_list_model.dart';

List<ProfileDetails> memberFromJson(String str) =>
    List<ProfileDetails>.from(json.decode(str).map((x) => ProfileDetails.fromJson(x)));

String memberToJson(List<ProfileDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
