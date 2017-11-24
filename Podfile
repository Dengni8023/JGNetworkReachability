source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
# iOS 8使用动态framework
use_frameworks!

# workspace
workspace "JGNetworkReachability"

# platform
platform :ios, '8.0'

# JGNetworkReachability
target "JGNetworkReachability" do
    
    # JGSourceBase
    pod 'JGSourceBase', "~> 0.0.1"
    
    # project
    project "JGNetworkReachability.xcodeproj"
end

# Demo中必须保留，即使内部无任何Pod依赖，否则Demo中无法使用JGAlertController依赖的Pod库
# JGNetworkReachabilityDemo
target "JGNetworkReachabilityDemo" do
    
    # project
    project "JGNetworkReachability.xcodeproj"
end

