#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run 'pod lib lint fly_chat.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fly_chat'
  s.version          = '0.0.1'
  s.summary          = 'A Mirrorfly Flutter Plugin'
  s.description      = 'Mirrorfly Chat Plugin for flutter supoort only Android and iOS'

  s.homepage         = 'https://github.com/MirrorFly/MirrorFly-Flutter-plugin'
  s.license          = { :type => 'Commercial', :file => '../LICENSE' }
  s.author           = { 'CONTUS TECH' => 'manivendhan.m@contus.in' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  #s.dependency          = { :git => 'https://github.com/MirrorFly/Mirrorfly-ios-framework.git', :branch => 'qa' }
  #s.dependency 'Mirrorfly-ios-framework', :git => 'https://github.com/MirrorFly/Mirrorfly-ios-framework.git', :branch => 'qa'
  s.platform = :ios, '12.1'
  s.requires_arc = true

  s.dependency 'libPhoneNumber-iOS'
  s.dependency 'Alamofire'
  s.dependency 'SocketRocket'
  s.dependency 'Socket.IO-Client-Swift'
  s.dependency 'XMPPFramework/Swift'
  s.dependency 'RealmSwift' , '10.20.1'
  s.dependency 'GoogleWebRTC'

  s.ios.vendored_frameworks = 'SDK/FlyCommon.xcframework' , 'SDK/FlyCall.xcframework' ,'SDK/FlyCore.xcframework', 'SDK/FlyXmpp.xcframework', 'SDK/FlyDatabase.xcframework', 'SDK/FlyNetwork.xcframework', 'SDK/FlyTranslate.xcframework'


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
