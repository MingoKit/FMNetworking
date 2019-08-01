Pod::Spec.new do |s|
  s.name         = 'FMNetworking'
  s.summary      = 'A delightful networking framework.'
  s.version      = '1.1.2'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { '袁凤鸣' => 'yfmingo@163.com' }# 作者信息
  s.social_media_url = 'https://www.yfmingo.cn/'
  s.homepage     = 'https://github.com/yfming93/FMNetworking'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/yfming93/FMNetworking.git', :tag => s.version.to_s }
  
  s.dependency "AFNetworking", "~> 3.2.1"
  s.requires_arc = true
  s.source_files = 'FMNetworking/**/*.{h,m}'
  s.public_header_files = 'FMNetworking/**/*.{h}'
  
  

  s.libraries = 'z'
  s.frameworks = 'UIKit', 'CoreFoundation' ,'QuartzCore', 'CoreGraphics', 'CoreImage', 'CoreText', 'ImageIO', 'Accelerate'

end
