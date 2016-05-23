Pod::Spec.new do |s|
  s.name             = "YandexMoneySDKObjc"
  s.version          = "2.1.6"
  s.summary          = "Yandex.Money SDK" 
  s.homepage         = "https://github.com/yandex-money/yandex-money-sdk-objc"
  s.license          = 'MIT'
  s.author           = { "Yuriy Vyazov" => "ymiapp@yandex.ru" }
  s.source           = { :git => "https://github.com/yandex-money/yandex-money-sdk-objc.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/yamoneynews'
  s.documentation_url = 'http://api.yandex.ru/money/'

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true
  
  s.source_files = 'Classes/**/*.{h,m}'

end
