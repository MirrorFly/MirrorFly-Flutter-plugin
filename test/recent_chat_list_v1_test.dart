import 'package:flutter_test/flutter_test.dart';
import 'package:mirrorfly_plugin/model/recent_chat_list_v1.dart';

void main() {
  test('mode values match the native side', () {
    expect(RecentChatMode.all.value, 'all');
    expect(RecentChatMode.groups.value, 'groups');
    expect(RecentChatMode.unread.value, 'unread');
    expect(RecentChatMode.archive.value, 'archive');
  });

  test('parses a list page with paging values', () {
    const jsonString = '{"data":[{"jid":"123@xmpp.test","nickName":"group 50",'
        '"isGroup":true,"unreadMessageCount":2,"isChatArchived":false,'
        '"lastMessageTime":1791133794416889}],'
        '"hasNext":true,"fromDB":false,"totalRecords":52,"totalPages":3,'
        '"page":1,"mode":"all"}';
    final page = recentChatListV1ResponseFromJson(jsonString);
    expect(page.data.length, 1);
    expect(page.data.first.jid, '123@xmpp.test');
    expect(page.data.first.nickName, 'group 50');
    expect(page.hasNext, true);
    expect(page.fromDB, false);
    expect(page.totalRecords, 52);
    expect(page.totalPages, 3);
    expect(page.page, 1);
    expect(page.modeEnum, RecentChatMode.all);
    expect(page.message, isNull);
    expect(page.searchText, isNull);
  });

  test('parses an offline page with a message and no rows', () {
    const jsonString = '{"data":[],"hasNext":false,"fromDB":true,'
        '"totalRecords":-1,"totalPages":0,"page":0,"mode":"unread",'
        '"message":"No internet"}';
    final page = recentChatListV1ResponseFromJson(jsonString);
    expect(page.data, isEmpty);
    expect(page.hasNext, false);
    expect(page.fromDB, true);
    expect(page.totalRecords, -1);
    expect(page.modeEnum, RecentChatMode.unread);
    expect(page.message, 'No internet');
  });

  test('parses a search result and tolerates missing keys', () {
    const jsonString = '{"data":[],"searchText":"group 4","mode":"groups"}';
    final page = recentChatListV1ResponseFromJson(jsonString);
    expect(page.searchText, 'group 4');
    expect(page.modeEnum, RecentChatMode.groups);
    expect(page.hasNext, false);
    expect(page.fromDB, false);
    expect(page.totalRecords, -1);
    expect(page.totalPages, 0);
    expect(page.page, 0);
  });
}
