Pod::Spec.new do |s|
  s.name         = "mpos-ui"
  s.version      = "0.0.1"
  s.license		   = "private"
  s.summary		   = 'Some summary'
  s.homepage     = 'https://bitbucket.org/payworks/io.payworks.mpos.ios'
  s.author       = { 'Simon Eumes' => 'se@payworksmobile.com' }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  
  s.source =  { :path => "" }
  s.source_files =  "Internal/**/*.{h,m}", "External/**/*.{h,m}" 
  s.prefix_header_file = 'Resources/mpos-ui.pch'	  
  
  # s.resource_bundle = {'mpos.core-resources' => ['Resources/*.storyboard', 'Resources/generic/*.json', 'Resources/i18n/receipts/*.json', 'Resources/i18n/errors/40x1/*.json', 'Resources/i18n/displays/20x4/*.json', 'Resources/i18n/displays/40x2/*.json', 'Resources/*.json'] }
  s.resource     = '../packaged/mpos-ui-resources.bundle'

  s.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) LOGGING_VERBOSE=1' }
  s.dependency 'MPBSignatureViewController',                    '~> 1.5.1'
  #s.dependency 'payworks.specs.iso7816',				'~> 0.1.1'
  # s.dependency 'MPAFNetworking/NSURLConnection',		'= 2.5.4'

  # s.frameworks = 'ExternalAccessory', 'Security', 'MobileCoreServices', 'SystemConfiguration'
  # s.library = 'icucore'
  
end
