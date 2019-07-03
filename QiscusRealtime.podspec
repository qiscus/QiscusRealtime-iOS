Pod::Spec.new do |s|

s.name         = "QiscusRealtime"
s.version      = "0.3.4"
s.summary      = "Qiscus SDK Realtime Message for iOS"
s.description  = <<-DESC
QiscusRealtime SDK for iOS contains Chat User Interface.
DESC
s.homepage     = "https://qiscus.com"
s.license      = "MIT"
s.author       = "Qiscus"
s.source       = { :git => "https://github.com/qiscus/QiscusRealtime-iOS.git", :tag => "#{s.version}" }
s.source_files  = "QiscusRealtime/**/*.{swift}"
s.platform      = :ios, "9.0"

s.dependency 'CocoaMQTT', '~> 1.2.2'

end

