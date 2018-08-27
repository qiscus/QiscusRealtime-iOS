Pod::Spec.new do |s|

s.name         = "QiscusRealtime"
s.version      = "0.1.1"
s.summary      = "Qiscus SDK Realtime Message for iOS"
s.description  = <<-DESC
QiscusRealtime SDK for iOS contains Chat User Interface.
DESC
s.homepage     = "https://qisc.us"
s.license      = "MIT"
s.author       = "Qiscus"
s.source       = { :git => "https://github.com/qiscus/qiscus-sdk-ios.git", :tag => "#{s.version}" }
s.source_files  = "QiscusRealtime/**/*.{swift}"
s.platform      = :ios, "9.3"

s.dependency 'CocoaMQTT', '1.1.2'

end

