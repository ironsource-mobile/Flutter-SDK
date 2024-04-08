#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ironsource_mediation.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ironsource_mediation'
  s.version          = '1.2.1'
  s.summary          = 'The Leading Mobile Advertising Technology Platform'
  s.description      = <<-DESC
Monetize & Promote Your Apps
Mobile sdk for IronSource
                       DESC
  s.homepage         = 'http://www.is.com/'
  s.license = { :type => 'Commercial', :text => 'https://platform.ironsrc.com/partners/terms-and-conditions-new-user' }
  s.author           = { 'IronSource' => 'http://www.is.com/contact/' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  # ironSource
  s.dependency 'IronSourceSDK','7.9.1.0'
end
