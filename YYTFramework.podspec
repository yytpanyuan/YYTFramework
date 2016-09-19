Pod::Spec.new do |s|

s.name         = "YYTFramework"
s.version      = "0.0.1"
s.summary      = "manage some the third libs"

s.description  = <<-DESC
admob and Baidu SSP and some other the third libs.
DESC

s.homepage     = "https://github.com/yytpanyuan/YYTFramework"
s.license      = "MIT"
s.author       = { "yytpanyuan" => "yytsoon@gmail.com" }
s.platform     = :ios,'6.0'

s.source       = { :git => "https://github.com/yytpanyuan/YYTFramework.git", :tag => "#{s.version}" }
s.source_files = "YYTFramework/YYTFramework/Classes/*.{h,m}"
s.framework    = "UIKit"
s.requires_arc = true
end