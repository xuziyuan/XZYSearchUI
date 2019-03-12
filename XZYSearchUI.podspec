Pod::Spec.new do |s|
  s.name         = "XZYSearchUI"
  s.version      = "1.0.0"
  s.summary      = "A Search UI Tools"
  s.description  = "A Search UI Tools addtion with cocoapod support."
  s.homepage     = "https://github.com/xuziyuan/XZYSearchUI.git"
  #s.social_media_url   = "http://www.weibo.com/u/5267312788"
  s.license= { :type => "MIT", :file => "LICENSE" }
  s.author       = { "xuziyuan" => "danxuschool@163.com" }
  s.source       = { :git => "https://github.com/xuziyuan/XZYSearchUI.git", :tag => s.version }
  s.source_files = "XZYSearchUI/*.{h,m}"
  s.ios.deployment_target = '8.0'
  s.frameworks   = 'UIKit'
  s.requires_arc = true

end
