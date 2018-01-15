#
#  Be sure to run `pod spec lint umeng.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "pgyer"
  s.version      = "1.0.0"
  s.summary      = "蒲公英管理"
  s.description  = <<-DESC
                   蒲公英 pod 管理"
                   DESC

  s.homepage     = "https://www.pgyer.com"
  s.license      = "MIT"
  s.author       = { "MinLison" => "yuanhang.1991@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :path => "."}
  s.default_subspec = 'update', 'pgyersdk'

  s.subspec 'pgyersdk' do |ss|
    ss.vendored_frameworks = "sdk/PgySDK.framework"
    ss.frameworks = "CoreTelephony","SystemConfiguration","OpenGLES","CoreMotion","AudioToolbox","AvFoundation"
  end

  s.subspec 'update' do |ss|
    ss.frameworks = "CoreTelephony","SystemConfiguration","OpenGLES","CoreMotion","AudioToolbox","AvFoundation"
    ss.vendored_frameworks = "sdk/PgyUpdate.framework"
  end
end
