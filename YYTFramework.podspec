Pod::Spec.new do |s|

s.name         = "YYTFramework"
s.version      = "0.0.2"
s.summary      = "manage some the third libs"

s.description  = <<-DESC
admob and Baidu SSP and some other the third libs.
DESC

s.homepage     = "https://github.com/yytpanyuan/YYTFramework"
s.license      = "MIT"
s.author       = { "yytpanyuan" => "yytsoon@gmail.com" }
s.platform     = :ios,'7.0'

s.source       = { :git => "https://github.com/yytpanyuan/YYTFramework.git", :tag => "#{s.version}" }
s.source_files = "Source/*.{h,m,bundle,framework}"
s.exclude_files= "Source/*.{framework}"
s.resources    = "Source/*.{bundle}"
s.framework    = "AdSupport", "StoreKit", "SystemConfiguration", "CoreTelephony", "CoreLocation", "CoreMotion", "MessageUI", "libc++"
s.requires_arc = true

s.dependency 'Firebase/Core'
s.dependency 'Firebase/AdMob'

end
