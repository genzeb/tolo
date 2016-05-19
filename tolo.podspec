Pod::Spec.new do |s|
  s.name         = "tolo"
  s.version      = "1.0.3"
  s.summary      = "A event publish/sibscribe framework for iOS."
  s.description  = "Tolo is an event publish/subscribe framework inspired by Otto and designed to decouple different parts of your iOS application while still allowing them to communicate efficiently. Traditional ways of subscribing for and triggering notifications are both cumbersome and error prone with minimal compile time error checking."
  s.homepage     = "http://genzeb.github.io/tolo/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Ephraim Tekle" => "genzeb@gmail.com" }
  s.ios.deployment_target = "5.0"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/kswchoo/tolo.git", :tag => "v1.0.3" }
  s.source_files = "Tolo/Tolo/*.{h,m}"
  s.requires_arc = true
end
