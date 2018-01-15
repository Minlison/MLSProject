#
#  Be sure to run `pod spec lint umeng.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "umeng"
  s.version      = "1.0.6"
  s.summary      = "友盟SDK pod 管理"
  s.description  = <<-DESC
                   友盟SDK pod 管理"
                   DESC

  s.homepage     = "http://www.umeng.com/codecenter.html"
  s.license      = "MIT"
  s.author             = { "MinLison" => "yuanhang.1991@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :path => "."}
  s.default_subspec = 'common'

  s.subspec 'thirdparties' do |ss|
    ss.vendored_frameworks = "thirdparties/UTDID.framework", "thirdparties/SecurityEnvSDK.framework"
    ss.public_header_files = "thirdparties/thirdparties.h"
    ss.source_files = "thirdparties/thirdparties.h"
  end

  s.subspec 'common' do |ss|
    ss.dependency "umeng/thirdparties"
    ss.public_header_files = "common/umcommon.h"
    ss.source_files = "common/umcommon.h"
    ss.vendored_frameworks = "common/UMCommon.framework"
    ss.xcconfig = {"OTHER_LDFLAGS" => "-ObjC "}
  end

  s.subspec 'analytics' do |ss|
    ss.libraries = "z"
    ss.frameworks = "CoreTelephony","SystemConfiguration"
    ss.dependency "umeng/common"
    ss.public_header_files = "analytics/umanalytics.h"
    ss.source_files = "analytics/umanalytics.h"
    ss.vendored_frameworks = "analytics/UMAnalytics.framework"
  end

  s.subspec 'push' do |ss|
    ss.dependency "umeng/common"
    ss.libraries = "z"
    ss.frameworks = "CoreTelephony","SystemConfiguration"
    ss.vendored_frameworks = "push/UMPush.framework"
    ss.public_header_files = "push/umpush.h"
    ss.source_files  = "push/umpush.h"
  end

  s.subspec 'social' do |ss|
    ss.libraries = "sqlite3","c++","z"
    ss.frameworks = "CoreGraphics","SystemConfiguration","CoreTelephony","ImageIO"
    ss.source_files = "social/SocialLibraries/**/*.h", "social/umsocial.h"
    ss.public_header_files = "social/SocialLibraries/**/*.h", "social/umsocial.h"
    ss.vendored_frameworks = "social/UMSocialSDK/*.framework"
    ss.vendored_libraries = "social/SocialLibraries/**/*.a","social/UMSocialSDKPlugin/*.a"
    ss.resources = "social/UMSocialSDK/*.bundle"
  end
  s.subspec 'socialui' do |ss|
    ss.dependency "umeng/social"
    ss.vendored_frameworks = "social/UMSocialUI/*.framework"
    ss.resources = "social/UMSocialUI/*.bundle"
    ss.public_header_files = "social/umsocialui.h"
    ss.source_files = "social/umsocialui.h"
  end

  s.subspec 'idfa' do |ss|
    ss.source_files = "social/UniqueId/*.h"
    ss.vendored_libraries = "social/UniqueId/*.a"
    ss.frameworks = "AdSupport"
    ss.public_header_files = "social/UniqueId/*.h"
    ss.source_files = "social/uniqueid.h"
  end

  s.subspec 'share' do |ss|
    ss.dependency "umeng/common"
    ss.libraries = "sqlite3","c++","z"
    ss.frameworks = "CoreGraphics","SystemConfiguration","CoreTelephony","ImageIO"
    ss.source_files = "share/SocialLibraries/**/*.h", "share/umshare.h"
    ss.vendored_frameworks = "share/UMShare.framework"
    ss.vendored_libraries = "share/SocialLibraries/**/*.a","share/UMSocialSDKPlugin/libUMSocialLog.a"
    ss.resources = "share/UMSocialSDKPlugin/UMSocialSDKPromptResources.bundle"
    ss.public_header_files = "share/SocialLibraries/**/*.h", "share/umshare.h"
  end

  s.subspec 'shareUI' do |ss|
    ss.dependency "umeng/share"
    ss.vendored_frameworks = "share/UMSocialUI/UShareUI.framework"
    ss.resources = "share/UMSocialUI/UMSocialSDKResources.bundle"
    ss.public_header_files = "share/umshareui.h"
    ss.source_files = "share/umshareui.h"
  end
  
  s.subspec 'umerror' do |ss|
    ss.libraries = "z","c++"
    ss.dependency "umeng/analytics"
    ss.frameworks = "SystemConfiguration","Foundation","UIKit"
    ss.vendored_frameworks = "umerror/UMErrorCatch.framework"
    ss.public_header_files = "umerror/umerror.h"
    ss.source_files = "umerror/umerror.h"
  end
  s.subspec 'umessage' do |ss|
    ss.libraries = "sqlite3","z","c++"
    ss.source_files = "umessage/*.h", "umessage/UMssageHeader.h"
    ss.frameworks = "SystemConfiguration","UserNotifications","UIKit"
    ss.vendored_libraries = "umessage/*.a"
    ss.public_header_files = "umessage/*.h","umessage/UMssageHeader.h"
  end
  s.subspec 'umessageidfa' do |ss|
    ss.libraries = "sqlite3","z","c++"
    ss.source_files = 'umessageidfa/*.h', "umessageidfa/UMssageHeader.h"
    ss.frameworks = "SystemConfiguration","UserNotifications","UIKit"
    ss.vendored_libraries = "umessageidfa/*.a"
    ss.public_header_files = 'umessageidfa/*.h', "umessageidfa/UMssageHeader.h"
  end
end
