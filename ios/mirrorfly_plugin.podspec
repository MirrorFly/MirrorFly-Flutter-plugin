#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run 'pod lib lint fly_chat.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mirrorfly_plugin'
  s.version          = '0.0.9'
  s.summary          = 'A Mirrorfly Flutter Plugin'
  s.description      = 'A Mirrorfly Flutter plugin to Experience an outstanding real time messaging solution. The powerful communication that adds an extra mileage to build your chat app.'

  s.homepage         = 'https://www.mirrorfly.com/docs/chat/flutter/quick-start/'
  s.license          = { :type => 'Commercial', :file => '../LICENSE' }
  s.author           = { 'CONTUS TECH' => 'manivendhan.m@contus.in' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.1'
  s.requires_arc = true

  s.dependency 'libPhoneNumber-iOS'
  s.dependency 'Alamofire'
  s.dependency 'SocketRocket'
  s.dependency 'Socket.IO-Client-Swift', '~> 15.2.0'
  s.dependency 'XMPPFramework/Swift'
  s.dependency 'RealmSwift' , '10.20.1'
  s.dependency 'GoogleWebRTC'
  #s.dependency 'MirrorFlySDK', '5.10.5'

  s.ios.vendored_frameworks = 'SDK/MirrorFlySDK.xcframework'



  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  #s.pod_target_xcconfig = { 'VALID_ARCHS' => 'armv7 arm64 x86_64', 'IPHONEOS_DEPLOYMENT_TARGET' => '12.1',}
#  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
#s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
#s.user_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
#  s.pod_target_xcconfig = {
#    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
#  }
  s.swift_version = '5.0'
end
