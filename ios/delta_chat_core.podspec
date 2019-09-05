#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                  = 'delta_chat_core'
  s.version               = '0.1.0'
  s.summary               = 'Flutter DeltaChat Core Plugin'
  s.homepage              = 'https://open-xchange.com'
  s.license               = { :file => '../LICENSE' }
  s.author                = { 'Open-Xchange GmbH' => 'info@open-xchange.com' }
  s.source                = { :path => '.' }
  s.source_files = 'Classes/**/*.{a,c,h,m,swift}'
  s.public_header_files   = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.xcconfig = {
    'HEADER_SEARCH_PATHS' => '"$(SRCROOT)/../.symlinks/plugins/delta_chat_core/ios/Classes"',
    'LIBRARY_SEARCH_PATHS' => '"$(SRCROOT)/../.symlinks/plugins/delta_chat_core/ios/Classes"',
  }
  
  s.description = <<-DESC
A Flutter plugin for COI (Chat Over IMAP) via the DeltaChat Core library.
DESC
end

