/// A model representing a recent search.
///
/// This class holds the details of a recent search, including the JID, MID,
/// search type, chat type, and a flag indicating if it was a search operation.
///
/// Parameters:
///   [jid] - The JID (Jabber ID) associated with the search.
///   [mid] - The MID (Message ID) associated with the search.
///   [searchType] - The type of search performed.
///   [chatType] - The type of chat associated with the search.
///   [isSearch] - A boolean indicating if the operation was a search.
class RecentSearch {
  /// Initializes a new instance of the [RecentSearch] class.
  RecentSearch({
    required this.jid,
    required this.mid,
    required this.searchType,
    required this.chatType,
    required this.isSearch,
  });

  /// The JID (Jabber ID) associated with the search.
  String? jid;

  /// The MID (Message ID) associated with the search.
  String? mid;

  /// The type of search performed.
  String? searchType;

  /// The type of chat associated with the search.
  String? chatType;

  /// A boolean indicating if the operation was a search.
  bool? isSearch;

  /// Creates a [RecentSearch] instance from a JSON map.
  ///
  /// This factory constructor is used to create an instance of [RecentSearch]
  /// from a map structure representing JSON data. This is useful for
  /// deserializing JSON data retrieved from a database or an API.
  ///
  /// Parameters:
  ///   [json] - A map representing JSON data.
  ///
  /// Returns:
  ///   An instance of [RecentSearch].
  factory RecentSearch.fromJson(Map<String, dynamic> json) => RecentSearch(
        jid: json["jid"],
        mid: json["mid"],
        searchType: json["search_type"],
        chatType: json["chat_type"],
        isSearch: json["is_search"],
      );

  /// Converts an instance of [RecentSearch] to a JSON map.
  ///
  /// This method is used to serialize [RecentSearch] instances into a map
  /// structure that can easily be converted to JSON. This is useful for
  /// storing the instance in a database or sending it over a network.
  ///
  /// Returns:
  ///   A map representing the serialized form of the [RecentSearch] instance.
  Map<String, dynamic> toJson() => {
        "jid": jid,
        "mid": mid,
        "search_type": searchType,
        "chat_type": chatType,
        "is_search": isSearch,
      };
}
