Pod::Spec.new do |s|
  s.name         = "TDDropInAlertView"
  s.version      = "0.0.1"
  s.summary      = "An API-compatible replacement for UIAlertView intended for use with legacy projects."
  s.homepage     = "https://github.com/TENDIGI/TDDropInAlertView"
  s.license      = "Apache License, Version 2.0"
  s.author             = { "Nick Lee" => "nick@tendigi.com" }
  s.social_media_url   = "http://twitter.com/nickplee"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/TENDIGI/TDDropInAlertView.git", :tag => "0.0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.frameworks = "Foundation", "UIKit"
  s.requires_arc = true
end
