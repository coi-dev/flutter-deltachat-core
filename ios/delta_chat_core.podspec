#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                  = 'delta_chat_core'
  s.version               = '0.4.0'
  s.summary               = 'Flutter DeltaChat Core Plugin'
  s.homepage              = 'https://open-xchange.com'
  s.license               = { :file => '../LICENSE' }
  s.author                = { 'Open-Xchange GmbH' => 'info@open-xchange.com' }
  s.source                = { :path => '.' }
  s.source_files          = 'Classes/**/*.{c,h,m,swift}', 'Libraries/**/*.h', '.swiftlint.yml', 'Libraries/deltachat.h'
  s.public_header_files   = 'Classes/**/*.h', 'Libraries/**/*.h', 'Libraries/deltachat.h'
  s.vendored_libraries    = 'Libraries/libdeltachat.a'

  s.xcconfig = {
    'HEADER_SEARCH_PATHS': '"$(SRCROOT)/../.symlinks/plugins/delta_chat_core"',
  }
  
  s.dependency 'Flutter'
  s.dependency 'MessageKit'
  s.dependency 'SwiftyBeaver'

  s.description = <<-DESC
A Flutter plugin for COI (Chat Over IMAP) via the DeltaChat Core library.
DESC
end
