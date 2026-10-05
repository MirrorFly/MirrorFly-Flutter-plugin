// Models for the paged recent chat lists and the server search
// (native API chat/recent-chats-v1).

import 'dart:convert';

import 'recent_chat.dart';

/// Which recent chat list to load.
///
/// - [all]     groups and single chats, not archived
/// - [groups]  groups only, not archived
/// - [unread]  groups and single chats with unread messages, not archived
/// - [archive] archived chats only
enum RecentChatMode {
  /// Groups and single chats, not archived.
  all,

  /// Groups only, not archived.
  groups,

  /// Groups and single chats with unread messages, not archived.
  unread,

  /// Archived chats only.
  archive
}

/// Gives the text value of a [RecentChatMode].
extension RecentChatModeValue on RecentChatMode {
  /// The value sent to the native side and to the server ("all", "groups", "unread", "archive").
  String get value => toString().split('.').last;
}

/// Result of one call to [Mirrorfly.loadRecentChatListV1], [Mirrorfly.nextRecentChatListV1],
/// [Mirrorfly.reloadRecentChatListV1] or [Mirrorfly.searchRecentChatsFromServer].
///
/// Use [recentChatListV1ResponseFromJson] on `FlyResponse.data` to get this object.
class RecentChatListV1Response {
  /// The chats of this page or search result, newest first.
  final List<RecentChatData> data;

  /// True when more rows can be loaded with [Mirrorfly.nextRecentChatListV1]
  /// (or with the next page, for search).
  final bool hasNext;

  /// True when the rows came from the local table without a server call. Always false for search.
  final bool fromDB;

  /// Total chats the server reported for this mode or search. -1 when unknown.
  final int totalRecords;

  /// Total server pages for this mode or search. 0 when unknown.
  final int totalPages;

  /// Last server page fetched for this mode, or the page asked for in a search.
  final int page;

  /// The mode value this result belongs to.
  final String mode;

  /// Set only when the server could not be reached and the rows came from the local table.
  final String? message;

  /// For search results only: the text that produced this result, so a late reply can be ignored.
  final String? searchText;

  /// Creates a response from already parsed values. Normally use [recentChatListV1ResponseFromJson].
  RecentChatListV1Response({
    required this.data,
    required this.hasNext,
    required this.fromDB,
    required this.totalRecords,
    required this.totalPages,
    required this.page,
    required this.mode,
    this.message,
    this.searchText,
  });

  /// Builds the response from the decoded JSON map sent by the native side.
  factory RecentChatListV1Response.fromJson(Map<String, dynamic> json) {
    final rows = json["data"];
    return RecentChatListV1Response(
      data: rows is List
          ? rows
              .map((x) => RecentChatData.fromJson(x as Map<String, dynamic>))
              .toList()
          : <RecentChatData>[],
      hasNext: json["hasNext"] == true,
      fromDB: json["fromDB"] == true,
      totalRecords: _asInt(json["totalRecords"], -1),
      totalPages: _asInt(json["totalPages"], 0),
      page: _asInt(json["page"], 0),
      mode: json["mode"]?.toString() ?? "",
      message: json["message"]?.toString(),
      searchText: json["searchText"]?.toString(),
    );
  }

  /// The mode as an enum value, or null when the native side sent something unexpected.
  RecentChatMode? get modeEnum {
    for (final m in RecentChatMode.values) {
      if (m.value == mode) return m;
    }
    return null;
  }

  static int _asInt(dynamic value, int fallback) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}

/// Parses the JSON string returned in `FlyResponse.data` by the recent chat v1 methods.
RecentChatListV1Response recentChatListV1ResponseFromJson(String str) =>
    RecentChatListV1Response.fromJson(json.decode(str) as Map<String, dynamic>);
