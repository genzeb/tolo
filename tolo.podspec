Pod::Spec.new do |s|
  s.name         = "tolo"
  s.version      = "1.0.0"
  s.summary      = "A event publish/sibscribe framework for iOS."
  s.description  = "Tolo is an event publish/subscribe framework inspired by Otto and designed to decouple different parts of your iOS application while still allowing them to communicate efficiently. Traditional ways of subscribing for and triggering notifications are both cumbersome and error prone with minimal compile time error checking."
  s.homepage     = "http://genzeb.github.io/tolo/"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Ephraim Tekle" => "genzeb@gmail.com" }
  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/kswchoo/tolo.git", :tag => "v1.0.0" }
  s.source_files = "Tolo/Tolo/*.{h,m}"
  s.requires_arc = true
end
