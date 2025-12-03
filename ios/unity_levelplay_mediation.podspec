#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint unity_levelplay_mediation.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'unity_levelplay_mediation'
  s.version          = '9.0.1'
  s.summary          = 'Unity LevelPlay - The Leading Mobile Advertising Technology Platform'
  s.description      = <<-DESC
Monetize & Promote Your Apps
Mobile SDK for Unity LevelPlay
                       DESC
  s.homepage         = 'https://unity.com/products/levelplay'
  s.license = { :type => 'Commercial', :text => 'https://unity.com/legal/terms-of-service' }
  s.author           = { 'Unity Technologies' => 'https://unity.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.resource_bundles = {
      'unity_levelplay_mediation' => ['Classes/**/*.xib']
  }

  s.dependency 'IronSourceSDK','9.2.0.0'
end

