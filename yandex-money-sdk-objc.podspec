#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "yandex-money-sdk-objc"
  s.version          = "0.1.0"
  s.summary          = "A short description of yandex-money-sdk-objc."
  s.description      = <<-DESC
                       An optional longer description of yandex-money-sdk-objc

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "http://money.yandex.ru"
  s.license          = ''
  s.author           = { "Александр Мертвецов" => "mertvetsov@yamoney.ru" }
  s.source           = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EXAMPLE'

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.source_files = 'Classes', 'Classes/**/*.{h,m}'

end
