Pod::Spec.new do |s|
  s.name         = "RNBraintreeDropIn"
  s.version      = "1.2.0"
  s.summary      = "RNBraintreeDropIn"
  s.description  = <<-DESC
                  RNBraintreeDropIn
                   DESC
  s.homepage     = "https://github.com/bamlab/react-native-braintree-payments-drop-in"
  s.license      = "MIT"
  s.author             = { "author" => "lagrange.louis@gmail.com" }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/ShortboxedInc/react-native-braintree-dropin-ui.git", :tag => "main" }
  s.source_files  = "ios/**/*.{h,m}"
  s.requires_arc = true
  s.dependency    'React'
  s.dependency    'Braintree', '~> 5'
  s.dependency    'BraintreeDropIn', '~> 9'
  s.dependency    'Braintree/DataCollector'
  s.dependency    'Braintree/ApplePay'
  s.dependency    'Braintree/Venmo'
end
