Pod::Spec.new do |s|
  s.name         = "RTLTextView"
  s.version      = "1.0"
  s.summary      = "Right to left text input inside a UITextField and UITextView"
  s.homepage     = "https://github.com/mstrchrstphr/LocationPickerView"
  s.screenshots  = ""
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Tulakshana Weerasooriya" => "tula_post@yahoo.com" }
  s.source       = { :git => "https://github.com/Tulakshana/RTLTextView.git"}
  s.source_files = 'RTLTextView/Classes/**/*.{h,m}'
  s.framework  = 'UIKit'
  s.requires_arc = true
  s.platform     = :ios, '7.0'
end
