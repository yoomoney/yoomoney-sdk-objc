Pod::Spec.new do |s|
  s.name             = "YooMoneySDKObjc"
  s.version          = "2.4.0"
  s.summary          = "YooMoney SDK"
  s.homepage         = "https://github.com/yoomoney/yoomoney-sdk-objc/"
  s.license          = 'MIT'
  s.author           = "Yuriy Vyazov"
  s.source           = { :git => "git@github.com:yoomoney/yoomoney-sdk-objc.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/yoomoneynews'
  s.documentation_url = 'https://yoomoney.ru/docs/wallet'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
end
