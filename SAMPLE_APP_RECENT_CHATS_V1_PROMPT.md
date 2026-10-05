# Prompt for the sample app work: paged recent chat list (v1)

Copy everything below the line into Claude Code, opened in
`/Users/user/Documents/flutter/workspace/p078-mirrorfly-flutter-sample-app`.

---

I am working on the MirrorFly Flutter sample app in this folder. The plugin at
`/Users/user/Documents/flutter/workspace/p078-mirrorfly-flutter-plugin` (branch
`feature/recent_chats_v1_sync`, commit 80ce94e2) now has five new methods for a paged
recent chat list that comes from the server API `chat/recent-chats-v1`. Your job is to
make the sample app use them. Do not change the plugin or the native SDKs. If you find a
plugin bug, stop and tell me instead of fixing it there.

## Rules

- Plain, simple English in every comment and in your replies. No jargon, no AI style
  wording. One short comment line wherever you add code into an existing file, saying why.
- Do not use subagents.
- Keep the legacy list code. Add a flag `useRecentChatV1` (default true) in
  `lib/app/common/constants.dart` so the old flow still works when it is false.
- Do not save search results anywhere. Search is server only and shows in memory results.
- Error codes from the new methods are SDK numbers (799 bad input, 403 feature missing,
  800 no network, 808 a call for that mode is already running, 801 fallback). Do not treat
  them like the legacy "500".
- When done, run `flutter analyze` and build and run on the Android emulator with
  `--flavor dev`. iOS full build fails on GoogleMaps pods, that is a known issue, skip it.
- Re-check your work in a loop until you find no gaps, then show me the diff summary.

## The plugin API (already done, in `package:mirrorfly_plugin/mirrorfly.dart`)

```dart
enum RecentChatMode { all, groups, unread, archive }   // .value gives "all" etc.

Mirrorfly.loadRecentChatListV1({required RecentChatMode mode, int size = 40,
    required Function(FlyResponse response) flyCallback});
Mirrorfly.nextRecentChatListV1({required RecentChatMode mode, int size = 40,
    required Function(FlyResponse response) flyCallback});
Mirrorfly.reloadRecentChatListV1({required RecentChatMode mode, int size = 40,
    required Function(FlyResponse response) flyCallback});
Future<bool> Mirrorfly.hasNextRecentChatListV1({required RecentChatMode mode});
Mirrorfly.searchRecentChatsFromServer({required RecentChatMode mode,
    required String searchText, int page = 1, int size = 20,
    required Function(FlyResponse response) flyCallback});

// On success, response.data is a JSON string. Parse it with:
final page = recentChatListV1ResponseFromJson(response.data);
// page.data        List<RecentChatData>, newest first (same model as the legacy list)
// page.hasNext     true when nextRecentChatListV1 can give more rows
// page.fromDB      true when rows came from the local table (offline or back paging)
// page.totalRecords, page.totalPages, page.page, page.mode
// page.message     set only when the server could not be reached (show as a toast once)
// page.searchText  search only: the text that produced this result
```

How the methods behave, so the UI can be built right:
- `loadRecentChatListV1` gives the first set of rows for one mode. Online it fetches
  page 1 from the server and saves it, then reads the rows from the local table. Offline
  it reads the local table and sets `fromDB` true and `message`.
- `nextRecentChatListV1` gives the next set of rows. Call it only when `hasNext` was true.
  It fetches the next server page only if the local table does not already have it.
- `reloadRecentChatListV1` fetches page 1 again (pull to refresh). It never deletes rows.
  Call it after login, after the XMPP connection comes back, and after the user archives,
  unarchives, deletes or leaves a chat.
- Each mode (all, groups, unread, archive) has its own paging on the native side. The
  four modes can be loaded at the same time without disturbing each other.
- Code 808 means a call for that mode is already running. Just ignore it and wait for
  the running call's callback.
- Search: results are not saved. Only search when the text has at least 2 characters,
  with a 400 ms debounce. When the reply comes, compare `page.searchText` with the text
  that is in the field now and drop the reply if they differ. When search is cleared,
  show the list you already had, do not call `loadRecentChatListV1` again.
- The rows are the same `RecentChatData` model the legacy list uses, so the existing
  row widget, tap handling, long press menu and unread badge can be reused.
- Live updates still come through the existing listeners (`onMessageReceived`,
  `onRecentChatUpdated` and the others). When one fires, update or move the row in
  the in memory list the same way the legacy code does today.

## Functions to implement

In `lib/app/modules/dashboard/controllers/dashboard_controller.dart`:

1. `loadRecentChatsV1()` – called from `onInit` and from the places that call
   `getRecentChatList()` today (lines near 171, 1635, 1705, 1889, and from
   `main_controller.dart` 561 and 567, `base_controller.dart` 1719). When
   `useRecentChatV1` is false, keep calling the legacy `getRecentChatList()`.
   Calls `loadRecentChatListV1(mode: RecentChatMode.all)`, fills `recentChats`,
   stores `hasNext`, shows `page.message` as a toast once when `fromDB` is true.
2. `loadNextRecentChatsV1()` – replaces the legacy next page call used by the scroll
   listener (near lines 1805 to 1826). Guard with a `isLoadingNext` flag and `hasNext`.
3. `reloadRecentChatsV1()` – pull to refresh, and called from the connection
   restored callback and after archive, unarchive, delete, leave group actions.
4. `searchRecentChatsV1(String text)` – replaces `searchConversation` (near line 1468)
   when the flag is on. Debounce, min 2 characters, drop late replies, no saving.
5. `clearRecentChatSearchV1()` – restores the list from before the search without a
   new load call.
6. Mode tabs (optional, only if the dashboard already has a filter UI for groups or
   unread): a `selectedMode` field and the three calls above taking the mode from it.
   Each mode keeps its own list and `hasNext` in memory.

In `lib/app/modules/archived_chats/archived_chat_list_controller.dart`:

7. `loadArchivedChatsV1()`, `loadNextArchivedChatsV1()`, `reloadArchivedChatsV1()` –
   same as 1 to 3 with `RecentChatMode.archive`. Replace `getArchivedChatList`
   (line 39) when the flag is on. Add a scroll listener for the next page.

In `lib/app/modules/dashboard/controllers/dashboard_controller.dart` line 272 and the
archived count shown on the dashboard: keep the legacy `getArchivedChatList` call for
the count when the flag is off; when on, use the `totalRecords` from the archive mode.

## Check list before you say it is done

- The list opens with page 1, scrolls and loads the next page until `hasNext` is false.
- Kill the app, turn off the network, open the app: the list shows from the local table
  with the toast message once, scrolling still works for pages already fetched.
- Turn the network on, pull to refresh: page 1 comes from the server.
- Archive a chat: it leaves the "all" list and shows in the archived list after reload.
- Search "group 4": results show, typing more narrows them, clearing restores the list.
- A new message in a chat moves it to the top with the right unread count.
- `flutter analyze` has no errors. No plugin file was changed.
