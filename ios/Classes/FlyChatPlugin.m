#import "FlyChatPlugin.h"
#if __has_include(<fly_chat/fly_chat-Swift.h>)
#import <fly_chat/fly_chat-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fly_chat-Swift.h"
#endif

@implementation FlyChatPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlyChatPlugin registerWithRegistrar:registrar];
}
@end
