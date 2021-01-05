#
# Be sure to run `pod lib lint CHKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHKit'
  s.version          = '0.1.0'
  s.summary          = 'CHKit is nothing'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is nothing
                       DESC

  s.homepage         = 'https://github.com/wbitos/CHKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wbitos' => 'wbitos@126.com' }
  s.source           = { :git => 'https://github.com/wbitos/CHKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5'

  s.source_files = 'CHKit/Classes/**/*'
  
   s.resource_bundles = {
     'CHKit' => ['CHKit/Assets/Assets.xcassets']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'ObjectMapper'
  s.dependency 'SnapKit'
  s.dependency 'JLRoutes'
  s.dependency 'ReactiveCocoa'
  s.dependency 'PromiseKit'
  s.dependency 'FMDB'
  s.dependency 'FCUUID'
  s.dependency 'DynamicColor', '~> 5.0.1'
  s.dependency 'MJRefresh'
  s.dependency 'JGProgressHUD'
  s.dependency 'WebViewJavascriptBridge'
  s.dependency 'NVActivityIndicatorView'
  s.dependency 'JXPagingView/Paging'
  s.dependency 'JXSegmentedView'
  s.dependency 'LunarTerm'
  s.dependency 'Alamofire'
  s.dependency 'AlamofireObjectMapper'
  s.dependency 'lottie-ios'
  s.dependency 'SDWebImage'
  s.dependency 'SDWebImage/GIF'
end
