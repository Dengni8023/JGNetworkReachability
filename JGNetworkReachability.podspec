
Pod::Spec.new do |s|

s.name          = "JGNetworkReachability"
s.version       = "0.0.6"

s.summary       = "iOS 弹出系统Alert通用方法定义"
s.description   = <<-DESC

	iOS 弹出系统Alert便捷方法定义
	
	功能包括：
	1、支持多Block回调监听
	2、支持多Selector回调监听
	3、支持通知中心监听
DESC

s.homepage      = "https://github.com/dengni8023/JGNetworkReachability"
s.license       = {
	:type => 'MIT',
	:file => 'LICENSE',
}
s.authors       = {
	"等你8023" => "945835664@qq.com",
},

s.source        = {
	:git => "https://github.com/dengni8023/JGNetworkReachability.git",
	:tag => "#{s.version}",
}
s.platforms     = {
	:ios => 8.0,
}
s.source_files  = "JGNetworkReachability/*.{h,m}"
# s.resource    = "JGNetworkReachability/JGNetworkReachability.bundle"

# s.framework  = "SomeFramework"
# s.frameworks = "SomeFramework", "AnotherFramework"

# s.library   = "iconv"
# s.libraries = "iconv", "xml2"

# s.dependency "SDWebImage", "~> 4.0"
# s.dependency "SDWebImage/GIF"
# s.dependency "SVProgressHUD", "~> 2.1"

s.dependency "JGSourceBase", "~> 0.0.1"

s.requires_arc = true

end

