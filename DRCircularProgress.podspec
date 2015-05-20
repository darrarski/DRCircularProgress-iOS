Pod::Spec.new do |s|
  s.name         = 'DRCircularProgress'
  s.version      = '1.0.2'
  s.summary      = 'Circular progress view for iOS apps'
  s.homepage     = 'https://github.com/darrarski/DRCircularProgress-iOS'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Dariusz Rybicki' => 'darrarski@gmail.com' }
  s.source       = { :git => 'https://github.com/darrarski/DRCircularProgress-iOS', :tag => 'v1.0.2' }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source_files = 'DRCircularProgress'
  s.requires_arc = true
end
