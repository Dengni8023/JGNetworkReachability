source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
# iOS 8使用动态framework
use_frameworks!

# workspace
workspace "JGNetworkReachability"

# platform
platform :ios, '8.0'

# Demo中必须保留，即使内部无任何Pod依赖，否则Demo中无法使用JGAlertController依赖的Pod库
# JGNetworkReachabilityDemo
target "JGNetworkReachabilityDemo" do
    
    # Local
    pod 'JGNetworkReachability', :path => "."
    
    # project
    project "JGNetworkReachabilityDemo/JGNetworkReachabilityDemo.xcodeproj"
end

