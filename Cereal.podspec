Pod::Spec.new do |s|

  s.name         = "Cereal"
  s.version      = "1.3"
  s.summary      = "Object and data serialization in Swift"

  s.description  = <<-DESC
                   Cereal is essentially NSCoding for Swift. Objects can be encoded and decoded
	           into a format that can be written to disk, user defaults, property lists, or
		   transferred to other devices through frameworks like WatchConnectivity.
                   DESC

  s.license      = "MIT"
  s.homepage           = "https://github.com/Weebly/Cereal.git"
  s.author             = { "ketzusaka" => "james@weebly.com" }
  s.social_media_url   = "http://twitter.com/ketzusaka"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  #s.tvos.deployment_target = "1.0"

  s.source       = { :git => "https://github.com/Weebly/Cereal.git", :tag => "v1.3" }
  s.requires_arc = true
  s.source_files = "Cereal/*.swift"

end
