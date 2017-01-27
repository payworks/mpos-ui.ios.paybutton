Pod::Spec.new do |spec|
	spec.name				= 'payworks.paybutton'
	spec.version			= '$$VERSION$$'
	spec.license			= { :type => 'Copyright', :text => '©2016 payworks GmbH. All rights reserved.' }
	spec.homepage			= 'http://www.payworksmobile.com/developers'
	spec.authors			= { 'payworks' => 'developers@payworksmobile.com' }
	spec.summary			= 'A delightful UI framework build on top of the venerated payment integration framework powered by payworks'
	spec.platform			= :ios, '8.0'
	spec.requires_arc		= true
	spec.source				= { :http => 'http://releases.payworks.io/artifactory/mpos-ios/io/payworks/mpos.ios.ui/'+spec.version.to_s+'/mpos.ios.ui-'+spec.version.to_s+'.zip' }
	spec.resource			= 'mpos-ui-resources.bundle'
	spec.vendored_frameworks = 'mpos-ui.framework'
	
	spec.ios.dependency			'payworks/mpos/core', spec.version.to_s
	spec.ios.dependency     	'Lockbox', '~> 2.1.0'

end
