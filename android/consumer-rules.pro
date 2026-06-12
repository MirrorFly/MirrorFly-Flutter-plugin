# Consumer ProGuard/R8 rules for the MirrorFly Flutter plugin.
# These are bundled into the published AAR and applied automatically to the
# host app's R8 run.
#
# Why this file exists:
# The plugin hands SDK objects (RecentChat, ProfileDetails, ChatMessage, ...)
# to the Flutter side as JSON, built with Gson in AppUtils.toJsonString()
# -> Gson().toJson(obj). Gson uses reflection on the Java/Kotlin *field names*
# to produce the JSON keys. When the host app is built with minifyEnabled true,
# R8 renames those fields to a, b, c, A, B, H... and the JSON keys come out
# obfuscated. The Dart models then fail to find their expected keys
# (e.g. "type 'Null' is not a subtype of type 'String'" in recent_chat_model).
#
# Keeping the field names of the SDK classes keeps the JSON keys stable.

# Gson needs these attributes for generic types and annotations.
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep the MirrorFly SDK members' *names* so Gson reflection produces the same
# JSON keys with or without minification. This only fixes names; unused code
# can still be shrunk.
-keepclassmembernames class com.mirrorflysdk.** { *; }

# Belt-and-suspenders: never obfuscate the model packages that are serialized.
-keep class com.mirrorflysdk.api.models.** { *; }
-keep class com.mirrorflysdk.models.** { *; }
-keep class com.mirrorflysdk.flycommons.models.** { *; }
-keep class com.mirrorflysdk.xmpp.chat.models.** { *; }
-keep class com.mirrorflysdk.flynetwork.model.** { *; }

# Keep the plugin entry point.
-keep class com.mirrorfly.mirrorfly_plugin.FlyChatPlugin { *; }
