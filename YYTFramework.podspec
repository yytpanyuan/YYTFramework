Pod::Spec.new do |s|

s.name         = "YYTFramework"
s.version      = "0.5.3"
s.summary      = "manage some the third libs"

s.description  = <<-DESC
Admob and GDK and Baidu SSP and Ads and some other the third libs.
DESC

s.homepage     = "https://github.com/yytpanyuan/YYTFramework"
s.license      = "MIT"
s.author       = { "yytpanyuan" => "yytsoon@gmail.com" }
s.platform     = :ios,'10.0'

s.source       = { :git => "https://github.com/yytpanyuan/YYTFramework.git", :tag => "#{s.version}" }
s.source_files = "Source/*.{h,m}"
#s.public_header_files = "Source/*.h"
#s.vendored_frameworks = ["Source/*.framework"]
#s.vendored_libraries = ["Source/*.a"]
s.resources    = "Source/**/*.{bundle,xib,png}"
s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
s.framework    = "AdSupport", "StoreKit", "SystemConfiguration", "CoreTelephony", "CoreLocation", "CoreMotion", "MessageUI", "AVFoundation", "CoreMedia", "QuartzCore", "Security"
s.libraries        = "xml2"

s.requires_arc = true

s.dependency 'Google-Mobile-Ads-SDK'
s.dependency 'BaiduMobAdSDK', '4.83'
s.dependency 'GDTMobSDK'
s.dependency 'Ads-CN'
s.dependency 'Masonry'

end
