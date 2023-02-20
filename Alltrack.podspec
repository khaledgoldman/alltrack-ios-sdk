Pod::Spec.new do |s|
  s.name           = "Alltrack"
  s.version        = "0.0.1"
  s.summary        = "This is the iOS SDK of alltrack. You can read more about it at http://alltrack.com."
  s.homepage       = "https://github.com/alltrack/ios_sdk"
  s.license        = { :type => 'MIT', :file => 'MIT-LICENSE' }
  s.author         = { "Alltrack" => "sdk@alltrack.com" }
  s.source         = { :git => "https://github.com/alltrack/ios_sdk.git", :tag => "v4.33.4" }
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.framework      = 'SystemConfiguration'
  s.ios.weak_framework = 'AdSupport'
  s.tvos.weak_framework = 'AdSupport'
  s.requires_arc   = true
  s.default_subspec = 'Core'
  s.pod_target_xcconfig = { 'BITCODE_GENERATION_MODE' => 'bitcode' }

  s.subspec 'Core' do |co|
    co.source_files   = 'Alltrack/*.{h,m}', 'Alltrack/ALTAdditions/*.{h,m}'
  end

  s.subspec 'Sociomantic' do |sm|
    sm.source_files = 'plugin/Sociomantic/*.{h,m}'
    sm.dependency 'Alltrack/Core'
  end

  s.subspec 'Criteo' do |cr|
    cr.source_files = 'plugin/Criteo/*.{h,m}'
    cr.dependency 'Alltrack/Core'
  end

  s.subspec 'Trademob' do |tm|
    tm.source_files = 'plugin/Trademob/*.{h,m}'
    tm.dependency 'Alltrack/Core'
  end

  s.subspec 'WebBridge' do |wb|
    wb.source_files = 'AlltrackBridge/*.{h,m}', 'AlltrackBridge/WebViewJavascriptBridge/*.{h,m}'
    wb.dependency 'Alltrack/Core'
    wb.ios.deployment_target = '9.0'
  end
end
